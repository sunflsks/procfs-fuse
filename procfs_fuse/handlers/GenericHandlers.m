//
//  GenericHandlers.m
//  procfs_fuse
//
//  Created by Sudhip Nashi on 12/17/21.
//

#import "../BackendProtocols.h"
#import "GenericHandlers.h"

@import Foundation;

@implementation PFGenericPseudoDirectoryHandler

-(struct stat)getattr {
    struct stat st = {0};
    st.st_mode = S_IFDIR | S_IRUSR | S_IRGRP | S_IROTH;
    st.st_uid = getuid();
    st.st_gid = getgid();
    
    return st;
}

+ (struct pf_access_output)access:(int)mode {
    if (mode != R_OK) {
        return (struct pf_access_output) {
            ACCESS_HELLNO,
            0
        };
    }
    
    return (struct pf_access_output) {
        ACCESS_OK,
        0
    };
}

- (nonnull NSArray<PFDirectoryEntry *> *)getDirectoryEntries {
    return @[];
}

@end

@implementation PFGenericPseudoFileHandler

-(struct stat)getattr {
    struct stat st = {0};
    st.st_mode = S_IFREG | S_IRUSR | S_IRGRP | S_IROTH;
    st.st_uid = getuid();
    st.st_gid = getgid();
    st.st_nlink = 1;
    
    return st;
}

+(struct stat)genericGetattr {
    return [[[self alloc] init] getattr];
}

+ (struct pf_access_output)access:(int)mode {
    if (mode != R_OK) {
        return (struct pf_access_output) {
            ACCESS_HELLNO,
            0
        };
    }
    
    return (struct pf_access_output) {
        ACCESS_OK,
        0
    };
}

-(int)read:(size_t)bufsize destbuf:(char *)destbuf offset:(off_t)offset {
    return -ENOTSUP;
}

-(int)copyDataFromBuffer:(NSData*)data toDestinationBuffer:(char*)destbuf destinationBufferSize:(size_t)bufsize offset:(off_t)offset {
    if (offset >= data.length) {
        return 0;
    }
    
    if (offset + bufsize > data.length) {
        bufsize = data.length - offset;
    }
    
    NSData* newdata = [data subdataWithRange:NSMakeRange(offset, bufsize)];
    
    memcpy(destbuf, newdata.bytes, bufsize);
    
    return (int)bufsize;
}

@end
