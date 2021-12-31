//
//  RootHandler.m
//  procfs_fuse
//
//  Created by Sudhip Nashi on 12/17/21.
//

#import "../procfs_fuse.h"
#import "../BackendProtocols.h"
#import "GenericHandlers.h"
#import "sys/PFSysHandler.h"
#import "PFRootHandler.h"

@import Foundation;

@implementation PFRootHandler

-(NSArray<PFDirectoryEntry*>*)getDirectoryEntries {
    PFDirectoryEntry* displays = [[PFDirectoryEntry alloc] initWithName:@"sys" stat: [[[PFSysHandler alloc] init] getattr]];
    return @[ displays ];
}

@end
