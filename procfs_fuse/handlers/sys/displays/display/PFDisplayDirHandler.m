//
//  DisplayDirHandler.m
//  procfs_fuse
//
//  Created by Sudhip Nashi on 12/18/21.
//

#import "GenericHandlers.h"
#import "PFDisplayDirHandler.h"
#import "PFDisplayContentsHandler.h"
#import "PFDisplayPropertiesHandler.h"

@import Foundation;

bool pf_CGIsValidDisplay(CGDirectDisplayID displayId);

@implementation PFDisplayDirHandler {
    int displayid;
}

-(id)initWithDisplayId:(int)displayid {
    self = [super init];
    if (!pf_CGIsValidDisplay(displayid)) {
        return nil;
    }

    self->displayid = displayid;
    return self;
}

-(NSArray<PFDirectoryEntry*>*)getDirectoryEntries {
    return @[
        [[PFDirectoryEntry alloc] initWithName:@"properties" stat: [[[PFDisplayPropertiesHandler alloc] initWithDisplayID:displayid] getattr]],
        [[PFDirectoryEntry alloc] initWithName:@"contents.png" stat: [[[PFDisplayContentsHandler alloc] initWithDisplayID:displayid] getattr]]
    ];
}

@end
