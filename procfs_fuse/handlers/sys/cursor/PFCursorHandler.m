//
//  PFCursorHandler.m
//  procfs_fuse
//
//  Created by Sudhip Nashi on 12/29/21.
//

#import "PFCursorHandler.h"
#import "PFCursorPositionHandler.h"

@import Foundation;

@implementation PFCursorHandler

-(NSArray<PFDirectoryEntry*>*)getDirectoryEntries {
    return @[
        [PFDirectoryEntry directoryEntryWithName:@"position" stat:[PFCursorPositionHandler genericGetattr]]
    ];
}

@end
