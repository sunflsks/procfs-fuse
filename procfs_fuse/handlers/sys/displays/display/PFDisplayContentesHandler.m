//
//  PFDisplayContentesHandler.m
//  procfs_fuse
//
//  Created by Sudhip Nashi on 12/20/21.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import "PFDisplayContentsHandler.h"
#import "../../../GenericHandlers.h"
#import <AppKit/AppKit.h>

static inline bool pf_CGIsValidDisplay(CGDirectDisplayID displayId) {
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
    NSData* data;
}

-(id)initWithDisplayID:(CGDirectDisplayID)displayId {
    self = [super init];
    
    if (!pf_CGIsValidDisplay(displayId)) {
        return nil;
    }
    
    CGImageRef ref = CGDisplayCreateImage(displayId);
    
    NSBitmapImageRep* rep = [[NSBitmapImageRep alloc] initWithCGImage:ref];
    data = [rep representationUsingType:NSBitmapImageFileTypePNG properties:@{}];
    
    CGImageRelease(ref);
    
    return self;
}

-(int)read:(size_t)bufsize destbuf:(char*)destbuf offset:(off_t)offset {
    return [self copyDataFromBuffer:data toDestinationBuffer:destbuf destinationBufferSize:bufsize offset:offset];
}

-(struct stat)getattr {
    struct stat st = [super getattr];
    st.st_size = data.length;
    return st;
}

@end
