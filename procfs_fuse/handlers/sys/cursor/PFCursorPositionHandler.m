//
//  PFCursorPositionHandler.m
//  procfs_fuse
//
//  Created by Sudhip Nashi on 12/29/21.
//

#import "PFCursorPositionHandler.h"

@import CoreGraphics;
@import Foundation;

@implementation PFCursorPositionHandler {
    CGPoint mouseLocation;
    NSData* data;
}

-(instancetype)init {
    self = [super init];
    CGEventRef ref = CGEventCreate(NULL);
    if (!ref) {
        NSLog(@"Could not create cgevent! %s:%d", __FILE__, __LINE__);
        return nil;
    }
    
    mouseLocation = CGEventGetLocation(ref);
    CFRelease(ref);
    
    data = [[NSString stringWithFormat:@"x %f\ny %f\n", mouseLocation.x, mouseLocation.y] dataUsingEncoding:NSUTF8StringEncoding];
    
    return self;
}

-(int)read:(size_t)bufsize destbuf:(char*)destbuf offset:(off_t)offset {
    return [self copyDataFromBuffer:data toDestinationBuffer:destbuf destinationBufferSize:bufsize offset:offset];
}

@end
