#import "RSSLoader.h"
#import "Timer.h"

@interface RSSLoader (Private)

-(void)dispatchLoadingOperation;

@end

@implementation RSSLoader
@synthesize delegate, loaded,loadedLocalFile;


-(id)init
{
	if ([super init]!=nil) {
		self.loaded = NO;
        self.loadedLocalFile = NO;
	}
	return self;
}

-(void)loadFeedThenPerformAction:(SEL)action;
{
    [self dispatchLoadingOperation:@selector(fetchRSS:) thenPerformAction:action];
}

-(void)dealloc
{
	self.delegate = nil;
}

-(void)dispatchLoadingOperation: (SEL)selector thenPerformAction: (SEL) action
{
	NSOperationQueue *queue = [NSOperationQueue new];
	NSString *actionToCall = NSStringFromSelector(action);
	NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self
																			selector:selector
																			  object:actionToCall];
	
	[queue addOperation:operation];
}

-(void)fetchRSS:(NSString*)actionToPerform
{	
    NSData *xmlData;
    NSError *error;
    
    SEL actionAfterFetch = NSSelectorFromString(actionToPerform);
    
    if (!self.loadedLocalFile) {
        [Timer lapse:@"[RSSLoader fetchRSS]: Loading local XML"];
        
        NSString* path = [[NSBundle mainBundle] pathForResource:@"postvazut" ofType:@"xml"];
        xmlData = [[NSMutableData alloc] initWithContentsOfFile:path];
        
    } else {
        [Timer lapse:@"[RSSLoader fetchRSS]: Loading remote RSS"];
        
        NSString* rssURL = @"";
        rssURL = [rssURL stringByAppendingString:pvRSSUrl];
        NSDate *lastUpdate = [self.delegate getLastUpdate];
        if (lastUpdate == nil) {
            [self.delegate performSelectorOnMainThread:@selector(failedFeedUpdateWithError:) withObject:error waitUntilDone:YES];
            return;
        }
        NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
        //2012-04-25T11:00:00
        [outputFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
        rssURL = [rssURL stringByAppendingString:[outputFormatter stringFromDate:lastUpdate]];
        xmlData = [[NSMutableData alloc] initWithContentsOfURL:[NSURL URLWithString: rssURL] ];
    }
    
	
    GDataXMLDocument* doc = [[GDataXMLDocument alloc] initWithData:xmlData options:0 error:&error];
	[Timer lapse:@"[RSSLoader fetchRSS]: Parsing XML"];
    
	if (doc != nil) {
		self.loaded = YES;
        self.loadedLocalFile = YES;
		GDataXMLNode* node = [[[doc rootElement] nodesForXPath:@"channel/lastBuildDate" error:&error] objectAtIndex:0];
        //[self.delegate performSelectorOnMainThread:@selector(setLastUpdated:) withObject:node waitUntilDone:NO];
        [self.delegate setLastUpdated:node];
        
        NSArray *categories = [[doc rootElement] nodesForXPath:@"channel/category" error:&error];
		for (GDataXMLElement* xmlItem in categories) {
            //[self.delegate performSelectorOnMainThread:@selector(addCategoryWithXML:) withObject:xmlItem waitUntilDone:NO];
            [self.delegate addCategoryWithXML:xmlItem];
		}
		
		NSArray* items = [[doc rootElement] nodesForXPath:@"channel/item" error:&error];
		for (GDataXMLElement* xmlItem in items) {
            //[self.delegate performSelectorOnMainThread:@selector(addEntryWithXml:) withObject:xmlItem waitUntilDone:NO];
            [self.delegate addEntryWithXml:xmlItem];
		}
		
        [Timer lapse:@"[RSSLoader fetchRSS]: end"];
		[self.delegate performSelectorOnMainThread:actionAfterFetch withObject:nil waitUntilDone:YES];
	} else {
        [Timer lapse:@"[RSSLoader fetchRSS]: Remote RSS load failed."];
		[self.delegate performSelectorOnMainThread:@selector(failedFeedUpdateWithError:) withObject:error waitUntilDone:YES];
	}
    
	
}

@end
