//
//  DisplayHandler.m
//  procfs_fuse
//
//  Created by Sudhip Nashi on 12/18/21.
//

#import "BackendProtocols.h"
#import "GenericHandlers.h"
#import "PFDisplayHandler.h"
#import "display/PFDisplayDirHandler.h"

@import Foundation;
@import CoreGraphics;

#define MAX_DISPLAY_CNT 128

@implementation PFDisplayHandler

- (nonnull NSArray<PFDirectoryEntry *> *)getDirectoryEntries {
    uint32_t displayCount;
    CGDirectDisplayID* displayIDs = calloc(MAX_DISPLAY_CNT, sizeof(CGDirectDisplayID));
    CGGetOnlineDisplayList(MAX_DISPLAY_CNT, displayIDs, &displayCount);
    
    NSMutableArray* ret = [NSMutableArray array];
    
    for (uint32_t i = 0; i < displayCount; i++) {
        NSString* name = [NSString stringWithFormat:@"display%d", displayIDs[i]];
        [ret addObject:[[PFDirectoryEntry alloc] initWithName:name stat:[[[PFDisplayDirHandler alloc] initWithDisplayId:displayIDs[i]] getattr]]];
    }
    
    free(displayIDs);
    
    return ret;
}

@end
