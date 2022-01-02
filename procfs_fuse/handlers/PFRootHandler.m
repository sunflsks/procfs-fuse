//
//  RootHandler.m
//  procfs_fuse
//
//  Created by Sudhip Nashi on 12/17/21.
//

#import "procfs_fuse.h"
#import "../BackendProtocols.h"
#import "GenericHandlers.h"
#import "sys/PFSysHandler.h"
#import "PFRootHandler.h"
#import "Utils.h"
#import <libproc.h>

@import Foundation;

@implementation PFRootHandler

-(NSArray<PFDirectoryEntry*>*)getDirectoryEntries {
    NSMutableArray* dentries = [NSMutableArray array];
    PFDirectoryEntry* displays = [[PFDirectoryEntry alloc] initWithName:@"sys" stat: [[[PFSysHandler alloc] init] getattr]];
    
    NSArray<NSNumber*>* pidArray = getAllPIDs();
    
    for (NSNumber* num in pidArray) {
        [dentries addObject:[PFDirectoryEntry directoryEntryWithName:[num stringValue] stat:[PFGenericPseudoFileHandler genericGetattr]]];
    }
    
    [dentries addObject:displays];
    
    return dentries;
}

@end
