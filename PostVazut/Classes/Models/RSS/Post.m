#import "Post.h"
#import <objc/runtime.h>
#import "TFHpple.h"
#import "Timer.h"

@implementation Post 

@synthesize title = _title;
@synthesize body = _body;
@synthesize url = _url;
@synthesize dateString = _dateString;
@synthesize date = _date;
@synthesize author = _author;
@synthesize rank = _rank;
@synthesize thumbnail = _thumbnail;
@synthesize categories = _categories;
@synthesize gallery = _gallery;
@synthesize imdbLink = _imdbLink;
@synthesize metacriticLink = _metacriticLink;
@synthesize rottenTomatoesLink = _rottenTomatoesLink;
@synthesize trailers = _trailers;
@synthesize ratings = _ratings;

- (id)initWithXML:(GDataXMLElement*)xmlItem 
{
    self = [super init];

    _title = [[[xmlItem elementsForName:@"title"] objectAtIndex:0] stringValue];
    _title = [self charactersToAscii:_title];

    _url = [[[xmlItem elementsForName:@"link"] objectAtIndex:0] stringValue];
    _dateString = [[[xmlItem elementsForName:@"pubDate"] objectAtIndex:0] stringValue];
    _dateString = [_dateString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];    
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];    
    NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [inputFormatter setLocale: usLocale];
    [inputFormatter setDateFormat:@"EEE, dd MMM yyyy HH:mm:ss Z"];
    _date = [inputFormatter dateFromString: _dateString];
    
    _author = [[[xmlItem elementsForName:@"author"] objectAtIndex:0] stringValue];
    //_author = [_author stringByReplacingOccurrencesOfString:@"noreply@blogger.com " withString:@""];
    _author = [self scanInString:_author between:@"(" and:@")"];
   
    _thumbnail = [[xmlItem elementsForName:@"media:thumbnail"] objectAtIndex:0];
    
    NSArray *postCategories = [xmlItem elementsForName:@"category"];
    _categories = [NSMutableArray array];
    for (GDataXMLElement* postCategory in postCategories) {
        [_categories insertObject:[self charactersToAscii:[postCategory stringValue]] atIndex:0];
    }    
    
    GDataXMLElement *thumbnailElement = [[xmlItem elementsForName:@"media:thumbnail"] objectAtIndex:0];
    _thumbnail = [[thumbnailElement attributeForName:@"url"] stringValue];
    

    _body = [[[xmlItem elementsForName:@"description"] objectAtIndex:0] stringValue];
    [self buildImageGalleryFromBody:_body];

    _trailers = [NSMutableArray array];    
    _ratings = [NSMutableArray array];    
    
    @try {
        [self extractMovieReferenceTagsFromBody:_body];
    }
    @catch (NSException *exception) {
        NSLog(@"Extract movie references %@",exception);
    }
    
    @try {
        _body = [self splitHTMLNewlines:_body];
        _body = [_body stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];    
    }
    @catch (NSException *exception) {
        NSLog(@"Split HTML newlines %@",exception);
    }

    @try {
        _body = [self stripExternalRanks:_body];
    }
    @catch (NSException *exception) {
        NSLog(@"Split HTML newlines %@",exception);
    }
    
    @try {
        _body = [self stripTags:_body tagOpen:@"<a" tagClose:@"</a>"];
        _body = [self stripTags:_body tagOpen:@"<span" tagClose:@">"];
        _body = [self stripTags:_body tagOpen:@"<div" tagClose:@">"];
        _body = [self stripTags:_body tagOpen:@"</di" tagClose:@">"];
        _body = [self stripTags:_body tagOpen:@"<img" tagClose:@">"];
        _body = [self stripTags:_body tagOpen:@"</sp" tagClose:@">"];
        _body = [self stripTags:_body tagOpen:@"<canv" tagClose:@">"];
        _body = [self stripTags:_body tagOpen:@"</canv" tagClose:@">"];
        _body = [self stripTags:_body tagOpen:@"<p" tagClose:@">"];
        _body = [self stripTags:_body tagOpen:@"</p" tagClose:@">"];
        _body = [self stripTags:_body tagOpen:@"<e" tagClose:@">"];
        _body = [self stripTags:_body tagOpen:@"</e" tagClose:@">"];
        _body = [self stripTags:_body tagOpen:@"<b" tagClose:@">"];
        _body = [self stripTags:_body tagOpen:@"</b" tagClose:@">"];
        _body = [self stripTags:_body tagOpen:@"<i" tagClose:@">"];
        _body = [self stripTags:_body tagOpen:@"</i" tagClose:@">"];
        
    }
    @catch (NSException *exception) {
        NSLog(@"HTML Tags %@",exception);
    }

    //_body = [self charactersToAscii:_body];
    
    @try {
        _rank = [self scanRank:_body];
    }
    @catch (NSException *exception) {
        _rank = @"n/a";
    }
    @finally {
        float rankInteger = [_rank floatValue];
        if (rankInteger == 0) {
            _rank = @"n/a";
        } else {
            _rank = [NSString stringWithFormat:@"%.1f",rankInteger];
        }
    }
    
    
    return self;
}

- (id)initWithCoreData:(PostItem*)postItem 
{
    self = [super init];

    _title = [self charactersToAscii:postItem.title];
    _url = postItem.url;
    _dateString = @"";
    _date = postItem.date;
    _author = postItem.author;
    _thumbnail = postItem.thumbnail;
    _imdbLink = postItem.imdb;
    _metacriticLink = postItem.metacritic;
    _rottenTomatoesLink = postItem.rottentomatoes;
    _body = [postItem.body stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"];
    _rank = postItem.rank;

    _categories = [NSMutableArray array];
    for (Categories*category in postItem.categories) {
        [_categories insertObject:[self charactersToAscii:category.name] atIndex:0];
    }
    
    _gallery = [NSMutableArray array];

    for (Gallery *galleryItem in postItem.gallery) {
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setValue:galleryItem.thumb forKey:@"thumb"];
        [dict setValue:galleryItem.image forKey:@"image"];
        [_gallery insertObject:dict atIndex:0];
    }

    _trailers = [NSMutableArray array];    
    for (Trailers*trailer in postItem.trailers) {
        [_trailers insertObject:trailer.url atIndex:0];
    }
    
    return self;
}

- (NSString*) charactersToAscii:(NSString*)input {
    
    // convert to a data object, using a lossy conversion to ASCII
    NSData *asciiEncoded = [input dataUsingEncoding:NSASCIIStringEncoding
                             allowLossyConversion:YES];
    
    // take the data object and recreate a string using the lossy conversion
    NSString *other = [[NSString alloc] initWithData:asciiEncoded
                                            encoding:NSASCIIStringEncoding];

    return other;
}

- (void) extractMovieReferenceTagsFromBody:(NSString*) body  {

    NSData* data=[body dataUsingEncoding: NSUTF8StringEncoding];
    TFHpple *xpathParser = [[TFHpple alloc] initWithHTMLData:data];
    NSArray *elements  = [xpathParser searchWithXPathQuery:@"//a"];
    for (TFHppleElement *element in elements)
    {
        NSString *href = [(NSDictionary*)[element attributes] objectForKey:@"href"];
        TFHppleElement *lastChild = [self getLastChild:element];
        NSString *nodeContent = [[lastChild content] lowercaseString];
        if ([nodeContent isEqualToString:@"imdb"]) {
            _imdbLink = href;
        } else if ([nodeContent isEqualToString:@"rt"]) {
            _rottenTomatoesLink = href;
        } else if ([nodeContent isEqualToString:@"mc"]) {
            _metacriticLink = href;
        } else if ([nodeContent isEqualToString:@"trailer"]) {
            [_trailers insertObject:href atIndex:0];
        } else if ([nodeContent isEqualToString:@"trailer 1"]) {
            [_trailers insertObject:href atIndex:0];
        } else if ([nodeContent isEqualToString:@"trailer 2"]) {
            [_trailers insertObject:href atIndex:0];
        } else if ([nodeContent isEqualToString:@"trailer 3"]) {
            [_trailers insertObject:href atIndex:0];
        }                
    }
    
    
//    NSString *pattern = @"<a href=\"(.+?)\">imdb</a>";
//    
//    NSRegularExpression* regex = [[NSRegularExpression alloc] initWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:nil];    
//    
//    NSArray* imgBalises = [regex matchesInString:body options:0 range:NSMakeRange(0, [body length])];
//    
//    
//    NSString* contentCopy = [body copy];
//    for (NSTextCheckingResult* b in imgBalises) // Loop through the URL list
//    {
//        NSString* url = [contentCopy substringWithRange:b.range];
//        
//        // So stuff to download the image
//        // And save it
//        NSLog(@"\n------------------\n%@\n------------------\n",url);
//        
//            
//    }
    
    

    //NSLog(@"found: '%@'", result);    
//    NSString *html = @"<div id=currency_converter_result>1 AED = <span class=bld>0.4765 ANG</span>";
//    NSRegularExpression *regex = [NSRegularExpression
//                                  regularExpressionWithPattern:@"<span[^>]*>(.+?)</span>"
//                                  options:NSRegularExpressionCaseInsensitive
//                                  error:nil];
//    NSTextCheckingResult *textCheckingResult = [regex firstMatchInString:html options:0 range:NSMakeRange(0, html.length)];
//    NSLog(@"found: '%@'", [html substringWithRange:[textCheckingResult rangeAtIndex:1]]);    
}

- (TFHppleElement *) getLastChild: (TFHppleElement *) element {
    if ([[element children] isKindOfClass:[NSArray class]]) {
        if ([[element children] count] > 0) element = [self getLastChild:[[element children] objectAtIndex:0]];
    }
    return element;
}

- (NSString*) extractTagHref: (NSString*) expression fromBody:(NSString*) body {

    NSRegularExpression *regex = [NSRegularExpression
                                  regularExpressionWithPattern:expression
                                  options:NSRegularExpressionCaseInsensitive
                                  error:nil];
    NSTextCheckingResult *textCheckingResult = [regex firstMatchInString:body options:0 range:NSMakeRange(0, body.length)];
    
    NSLog(@"result: %@",textCheckingResult);
    
    NSString *result = [body substringWithRange:[textCheckingResult rangeAtIndex:1]];
    return result;
    
}

-(void) buildImageGalleryFromBody:(NSString*) body {
    _gallery = [NSMutableArray array];
    NSData* data=[body dataUsingEncoding: NSUTF8StringEncoding];
    TFHpple *xpathParser = [[TFHpple alloc] initWithHTMLData:data];
    NSArray *elements  = [xpathParser searchWithXPathQuery:@"//img[@id]/.."];
    for (TFHppleElement *element in elements)
    {

        NSMutableDictionary *galleryItem = [[NSMutableDictionary alloc] init];
        
        if ([(NSDictionary*)[element attributes] objectForKey:@"href"] != NULL) {
            [galleryItem setValue:[(NSDictionary*)[element attributes] objectForKey:@"href"] forKey:@"image"];
        }
        
        if ([element.children count] > 0) {
            [galleryItem setValue:[(NSDictionary*)[[element.children objectAtIndex:0] attributes] objectForKey:@"src"] forKey:@"thumb"];
        }
        
        [_gallery insertObject:galleryItem atIndex:0];
        
    }
}

-(NSString*) splitHTMLNewlines:(NSString*) str {
    
    NSMutableString *html = [NSMutableString stringWithCapacity:[str length]];
    NSString *tagOpen = @"<br";
    NSString *tagClose = @">";
    
    NSScanner *scanner = [NSScanner scannerWithString:str];
    [scanner setCharactersToBeSkipped:[NSCharacterSet newlineCharacterSet]];    
    NSString *tempText = nil;
    
    while (![scanner isAtEnd])
    {
        [scanner scanUpToString:tagOpen intoString:&tempText];
        
        if (tempText != nil)
            [html appendString:tempText];
        
        [scanner scanUpToString:tagClose intoString:NULL];
        [html appendString:@" \r\n"];
        
        if (![scanner isAtEnd])
            [scanner setScanLocation:[scanner scanLocation] + [tagClose length]];
        
        tempText = nil;
    }
    
    return html;
}

-(void) extractExternalRanks:(NSString*) str {
    
    NSScanner *scanner = [NSScanner scannerWithString:str];
    [scanner setCharactersToBeSkipped:[NSCharacterSet newlineCharacterSet]];
    NSScanner *scanner2 = [NSScanner scannerWithString:str];
    [scanner2 setCharactersToBeSkipped:[NSCharacterSet newlineCharacterSet]];
    NSScanner *scanner3 = [NSScanner scannerWithString:str];
    [scanner3 setCharactersToBeSkipped:[NSCharacterSet newlineCharacterSet]];
    
    NSString *rankString = @"imdb";
    [scanner scanUpToString:rankString intoString:nil];
    [scanner setScanLocation:([scanner scanLocation] + [rankString length])];
    [scanner scanUpToString:@"/a>" intoString:nil];
    [scanner setScanLocation:([scanner scanLocation] + [@"/a>" length])];
    
    NSCharacterSet *numbers = [NSCharacterSet characterSetWithCharactersInString:@"0123456789 ."];
    
    NSString *imdbRank;
    [scanner scanCharactersFromSet:numbers intoString:&imdbRank];
    NSLog(@"%@",imdbRank);
    
    rankString = @"rt";
    [scanner2 scanUpToString:rankString intoString:nil];
    [scanner2 setScanLocation:([scanner scanLocation] + [rankString length])];
    [scanner2 scanUpToString:@"/a>" intoString:nil];
    [scanner2 setScanLocation:([scanner2 scanLocation] + [@"/a>" length])];

    NSString *rtRank;
    [scanner2 scanCharactersFromSet:numbers intoString:&rtRank];
    
    rankString = @"mc";
    [scanner3 scanUpToString:rankString intoString:nil];
    [scanner3 setScanLocation:([scanner scanLocation] + [rankString length])];
    [scanner3 scanUpToString:@"/a>" intoString:nil];
    [scanner3 setScanLocation:([scanner3 scanLocation] + [@"/a>" length])];
    
    NSString *mcRank;
    [scanner3 scanCharactersFromSet:numbers intoString:&mcRank];

    if (imdbRank != nil) {
        NSDictionary *imdbDict = [[NSDictionary alloc] init];
        [imdbDict setValue:imdbRank forKey:@"imdb"];
        [_ratings insertObject:imdbDict atIndex:0];
    }
    if (rtRank != nil) {
        NSDictionary *rtDict = [[NSDictionary alloc] init];
        [rtDict setValue:rtRank forKey:@"rt"];
        [_ratings insertObject:rtDict atIndex:0];
    }
    if (mcRank != nil) {
        NSDictionary *mcDict = [[NSDictionary alloc] init];
        [mcDict setValue:mcRank forKey:@"mc"];
        [_ratings insertObject:mcDict atIndex:0];
    }
    
    NSLog(@"%@",_ratings);

}

-(NSString*) getCategoriesAsString {
    return [self.categories componentsJoinedByString:@", "];
}

- (NSString *) stripTags:(NSString *)str tagOpen:(NSString*)tagOpen tagClose:(NSString*)tagClose
{
    NSMutableString *html = [NSMutableString stringWithCapacity:[str length]];
    
    NSScanner *scanner = [NSScanner scannerWithString:str];
    [scanner setCharactersToBeSkipped:[NSCharacterSet newlineCharacterSet]];    
    NSString *tempText = nil;
    
    while (![scanner isAtEnd])
    {
        [scanner scanUpToString:tagOpen intoString:&tempText];
        
        if (tempText != nil)
            [html appendString:tempText];
        
        [scanner scanUpToString:tagClose intoString:NULL];
        
        if (![scanner isAtEnd])
            [scanner setScanLocation:[scanner scanLocation] + [tagClose length]];
        
        tempText = nil;
    }
    
    return html;
}

- (NSString *) scanRank:(NSString *)str
{

    NSScanner *scanner = [NSScanner scannerWithString:str];
    [scanner setCharactersToBeSkipped:[NSCharacterSet newlineCharacterSet]];
    
    NSString *rankString = @"Ce zic eu:";
    
    [scanner scanUpToString:rankString intoString:nil];
    [scanner setScanLocation:([scanner scanLocation] + [rankString length])];

    NSCharacterSet *numbers = [NSCharacterSet characterSetWithCharactersInString:@"0123456789 ."];
    
    NSString *theRank;
    [scanner scanCharactersFromSet:numbers intoString:&theRank];
    
    return theRank;

}

- (NSString *) stripExternalRanks:(NSString *)str
{

    NSMutableString *html = [NSMutableString stringWithCapacity:[str length]];
    NSScanner *scanner = [NSScanner scannerWithString:str];
    
    NSString *tempText = nil;
    NSString *tagOpen = @"-Ce zic ei:";
    NSString *tagClose = @"\n";
    
    while (![scanner isAtEnd])
    {
        [scanner scanUpToString:tagOpen intoString:&tempText];
        
        if (tempText != nil)
            [html appendString:tempText];
        
        [scanner scanUpToString:tagClose intoString:NULL];
        
        if (![scanner isAtEnd])
            [scanner setScanLocation:[scanner scanLocation] + [tagClose length]];
        
        tempText = nil;
    }
    
    return html;    
    
}


- (NSString *) scanInString:(NSString *)str between:(NSString*) from and:(NSString*)to
{
    
    NSScanner *scanner = [NSScanner scannerWithString:str];
    [scanner setCharactersToBeSkipped:[NSCharacterSet newlineCharacterSet]];
    
    NSString *output;
    
    [scanner scanUpToString:from intoString:nil];
    [scanner setScanLocation:([scanner scanLocation] + [from length])];
    [scanner scanUpToString:to intoString:&output];
    
    return output;
    
}
         
- (void)dealloc {
    _title = nil;
    _body = nil;
    _url = nil;
    _date = nil;
    _dateString = nil;
    _thumbnail = nil;
    _author = nil;
    _categories = nil;
}

- (NSString*) showDate {
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:@"dd MMM yyyy"];
    return [outputFormatter stringFromDate:_date];
}

- (NSComparisonResult) compareWithDate:(Post*) anotherPost {
    NSComparisonResult result = [self.date compare:anotherPost.date];
    if (result == NSOrderedAscending) return NSOrderedDescending;
    if (result == NSOrderedDescending) return NSOrderedAscending;
    return NSOrderedSame;
}

- (NSComparisonResult) compareWithBest:(Post*) anotherPost {
    float a = [self.rank floatValue];
    float b = [anotherPost.rank floatValue];
    if (a < b) return NSOrderedDescending;
    if (a > b) return NSOrderedAscending;
    return NSOrderedSame;
}


- (NSComparisonResult) compareWithWorst:(Post*) anotherPost {
    float a = [self.rank floatValue];
    float b = [anotherPost.rank floatValue];
    if (a < b) return NSOrderedAscending;
    if (a > b) return NSOrderedDescending;
    return NSOrderedSame;
}




@end
