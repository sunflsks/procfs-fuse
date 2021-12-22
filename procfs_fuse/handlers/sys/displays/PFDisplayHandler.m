//
//  DisplayHandler.m
//  procfs_fuse
//
//  Created by Sudhip Nashi on 12/18/21.
//

#import <Foundation/Foundation.h>

//
//  GenericHandlers.m
//  procfs_fuse
//
//  Created by Sudhip Nashi on 12/17/21.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import "BackendProtocols.h"
#import "GenericHandlers.h"
#import "PFDisplayHandler.h"
#import "PFDisplayDirHandler.h"

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
