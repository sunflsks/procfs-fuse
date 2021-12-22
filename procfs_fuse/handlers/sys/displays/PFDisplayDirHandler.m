//
//  DisplayDirHandler.m
//  procfs_fuse
//
//  Created by Sudhip Nashi on 12/18/21.
//

#import <Foundation/Foundation.h>
#import "GenericHandlers.h"
#import "PFDisplayDirHandler.h"
#import "display/PFDisplayContentsHandler.h"
#import "display/PFDisplayPropertiesHandler.h"

@implementation PFDisplayDirHandler {
    int displayid;
}

-(id)initWithDisplayId:(int)displayid {
    self = [super init];
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
