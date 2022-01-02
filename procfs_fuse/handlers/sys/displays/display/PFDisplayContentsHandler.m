//
//  PFDisplayContentesHandler.m
//  procfs_fuse
//
//  Created by Sudhip Nashi on 12/20/21.
//

#import "PFDisplayContentsHandler.h"
#import "GenericHandlers.h"

@import Foundation;
@import CoreGraphics;
@import AppKit;

bool pf_CGIsValidDisplay(CGDirectDisplayID displayId) {
    uint32_t arraySize;
    
    CGError error = CGGetActiveDisplayList(0, NULL, &arraySize);
    if (error != kCGErrorSuccess) {
        NSLog(@"Uh-oh! CGError returned from pf_CGIsValidDisplay was %d", error);
        return false;
    }
    
    CGDirectDisplayID* ids = calloc(arraySize, sizeof(CGDirectDisplayID));
    
    error = CGGetActiveDisplayList(arraySize, ids, NULL);
    if (error != kCGErrorSuccess) {
        NSLog(@"Uh-oh! CGError returned from pf_CGIsValidDisplay was %d (2)", error);
        free(ids);
        return false;
    }
    
    bool validDisplay = false;
    for (uint32_t i = 0; i < arraySize; i++) {
        if (ids[i] == displayId)
            validDisplay = true;
    }
    
    free(ids);
    return validDisplay;
}

@implementation PFDisplayContentsHandler {
    NSData* _data;
    CGDirectDisplayID _displayId;
}

-(void)initializeData {
    CGImageRef ref = CGDisplayCreateImage(_displayId);
    
    NSBitmapImageRep* rep = [[NSBitmapImageRep alloc] initWithCGImage:ref];
    _data = [rep representationUsingType:NSBitmapImageFileTypeTIFF properties:@{}];
    
    CGImageRelease(ref);
}

-(id)initWithDisplayID:(CGDirectDisplayID)displayId {
    self = [super init];
    
    _displayId = displayId;
    if (!pf_CGIsValidDisplay(displayId)) {
        return nil;
    }
    
    return self;
}

-(int)read:(size_t)bufsize destbuf:(char*)destbuf offset:(off_t)offset {
    if (!_data) {
        [self initializeData];
    }
    
    return [self copyDataFromBuffer:_data toDestinationBuffer:destbuf destinationBufferSize:bufsize offset:offset];
}

@end
