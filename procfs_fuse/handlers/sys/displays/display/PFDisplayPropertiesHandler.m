//
//  DisplayResHandler.m
//  procfs_fuse
//
//  Created by Sudhip Nashi on 12/19/21.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <AppKit/AppKit.h>
#import "PFDisplayPropertiesHandler.h"
#import "../../../GenericHandlers.h"

static inline NSString* pf_boolToString(boolean_t boolean) {
    return (boolean ? @"true" : @"false");
}

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

@implementation PFDisplayPropertiesHandler {
    NSData* data;
}

-(id)initWithDisplayID:(CGDirectDisplayID)displayId {
    self = [super init];
    
    if (!pf_CGIsValidDisplay(displayId)) {
        return nil;
    }
    
    size_t height = CGDisplayPixelsHigh(displayId);
    size_t width = CGDisplayPixelsWide(displayId);
    boolean_t isActive = CGDisplayIsActive(displayId);
    boolean_t isAsleep = CGDisplayIsAsleep(displayId);
    boolean_t isBuiltin = CGDisplayIsBuiltin(displayId);
    boolean_t isMain = CGDisplayIsMain(displayId);
    CGSize displaySize = CGDisplayScreenSize(displayId);
    CGColorSpaceRef colorSpaceRef = CGDisplayCopyColorSpace(displayId);
    uint32_t modelNumber = CGDisplayModelNumber(displayId);
    uint32_t serialNumber = CGDisplaySerialNumber(displayId);
    uint32_t unitNumber = CGDisplayUnitNumber(displayId);
    uint32_t vendorNumber = CGDisplayVendorNumber(displayId);
    double rotationAngle = CGDisplayRotation(displayId);
    
    NSString* colorSpace = [[NSColorSpace alloc] initWithCGColorSpace:colorSpaceRef].localizedName;
    
    NSMutableString* contentsString = [NSMutableString string];
    
    [contentsString appendString:[NSString stringWithFormat:@"Resolution: %zux%zu\n", height, width]];
    [contentsString appendString:[NSString stringWithFormat:@"Is Active: %@\n", pf_boolToString(isActive)]];
    [contentsString appendString:[NSString stringWithFormat:@"Is Asleep: %@\n", pf_boolToString(isAsleep)]];
    [contentsString appendString:[NSString stringWithFormat:@"Is Built-in Display: %@\n", pf_boolToString(isBuiltin)]];
    [contentsString appendString:[NSString stringWithFormat:@"Is Main Display: %@\n", pf_boolToString(isMain)]];
    [contentsString appendString:[NSString stringWithFormat:@"Size (in mm): %f x %f\n", displaySize.width, displaySize.height]];
    [contentsString appendString:[NSString stringWithFormat:@"Model Number: 0x%x\n", modelNumber]];
    [contentsString appendString:[NSString stringWithFormat:@"Serial Number: 0x%x\n", serialNumber]];
    [contentsString appendString:[NSString stringWithFormat:@"Unit Number: 0x%x\n", unitNumber]];
    [contentsString appendString:[NSString stringWithFormat:@"Vendor Numberr: 0x%x\n", vendorNumber]];
    [contentsString appendString:[NSString stringWithFormat:@"Rotation Angle: %f degrees\n", rotationAngle]];
    [contentsString appendString:[NSString stringWithFormat:@"Color Space: %@\n", colorSpace]];
    
    data = [contentsString dataUsingEncoding:NSUTF8StringEncoding];
    CGColorSpaceRelease(colorSpaceRef);
    
    return self;
}

-(int)read:(size_t)bufsize destbuf:(char*)destbuf offset:(off_t)offset {
    return [self copyDataFromBuffer:data toDestinationBuffer:destbuf destinationBufferSize:bufsize offset:offset];
}

@end
