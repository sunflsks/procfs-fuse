//
//  PFDIrectoryEntry.m
//  procfs_fuse
//
//  Created by Sudhip Nashi on 12/17/21.
//

#import <Foundation/Foundation.h>
#import <sys/stat.h>
#import "DirectoryEntry.h"

@implementation PFDirectoryEntry {
    struct stat st;
    NSString* name;
}

+(instancetype)directoryEntryWithName:(NSString*)name stat:(struct stat)stat {
    return [[self alloc] initWithName:name stat:stat];
}

-(instancetype)initWithName:(NSString *)name stat:(struct stat)stat {
    self = [super init];
    self->st = stat;
    self->name = name;
    
    return self;
}

-(struct stat)stat {
    return st;
}

-(NSString*)name {
    return name;
}

@end
