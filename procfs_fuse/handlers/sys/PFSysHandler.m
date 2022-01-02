//
//  SysHandler.m
//  procfs_fuse
//
//  Created by Sudhip Nashi on 12/20/21.
//

#import "GenericHandlers.h"
#import "cursor/PFCursorHandler.h"
#import "displays/PFDisplayHandler.h"
#import "PFSysHandler.h"

@import Foundation;

@implementation PFSysHandler

-(NSArray<PFDirectoryEntry*>*)getDirectoryEntries {
    return @[
        [[PFDirectoryEntry alloc] initWithName:@"displays" stat:[[[PFDisplayHandler alloc] init] getattr]],
        [[PFDirectoryEntry alloc] initWithName:@"cursor" stat:[[[PFCursorHandler alloc] init] getattr]],
    ];
}

@end
