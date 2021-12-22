//
//  SysHandler.m
//  procfs_fuse
//
//  Created by Sudhip Nashi on 12/20/21.
//

#import <Foundation/Foundation.h>
#import "../GenericHandlers.h"
#import "displays/PFDisplayDirHandler.h"
#import "PFSysHandler.h"

@implementation PFSysHandler

-(NSArray<PFDirectoryEntry*>*)getDirectoryEntries {
    return @[
        [[PFDirectoryEntry alloc] initWithName:@"displays" stat:[[[PFDisplayDirHandler alloc] init] getattr]]
    ];
}

@end
