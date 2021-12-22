//
//  RootHandler.m
//  procfs_fuse
//
//  Created by Sudhip Nashi on 12/17/21.
//

#import <Foundation/Foundation.h>
#import "../procfs_fuse.h"
#import "../BackendProtocols.h"
#import "GenericHandlers.h"
#import "sys/PFSysHandler.h"
#import "PFRootHandler.h"

@implementation PFRootHandler

-(NSArray<PFDirectoryEntry*>*)getDirectoryEntries {
    PFDirectoryEntry* displays = [[PFDirectoryEntry alloc] initWithName:@"sys" stat: [[[PFSysHandler alloc] init] getattr]];
    return @[ displays ];
}

@end
