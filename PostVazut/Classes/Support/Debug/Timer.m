#import "Timer.h"

static Timer *timerInstance = nil;

@implementation Timer

@synthesize timeStart = _timeStart;
@synthesize debugFlag = _debug;

+ (id)getInstance {
    @synchronized(self) {
        if (timerInstance == nil)
            timerInstance = [[self alloc] init];
    }
    return timerInstance;
}

-(id)init
{
	if ([super init]!=nil) {
        self.timeStart = nil;
        _debug = NO;
	}
	return self;
}

+ (void) start {
    Timer *instance = [Timer getInstance];
    instance.timeStart = [NSDate date];
    if (instance.debugFlag) {
        NSLog(@"==============================================\n");
        NSLog(@"[Timer start]\n");
        NSLog(@"==============================================\n\n");
    }
}

+ (void) lapse: (NSString *)message {
    Timer *instance = [Timer getInstance];
    if (instance.timeStart == nil) {
        NSLog(@"Run [Timer start] before [Timer lapse]\n");
    } else {
        NSDate *finish = [NSDate date];
        NSTimeInterval executionTime = [finish timeIntervalSinceDate:instance.timeStart];
        if (instance.debugFlag) {
            NSLog(@"==============================================\n");
            if (message != nil) {
                NSLog(@"%@\n",message);
            }
            NSLog(@"Time: %f\n", executionTime);
            NSLog(@"==============================================\n\n");
            
        }

    }    
}

+ (void) setDebug: (BOOL) flag {
    Timer *instance = [Timer getInstance];
    instance.debugFlag = flag;
}



@end
