#import <Foundation/Foundation.h>

@interface Timer : NSObject {
    NSDate *_timeStart;
    BOOL _debug;
}
@property (retain) NSDate *timeStart;
@property BOOL debugFlag;

+ (id) getInstance;
+ (void) start;
+ (void) lapse: (NSString *)message;
+ (void) setDebug: (BOOL) flag;

@end
