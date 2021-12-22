#define _FILE_OFFSET_BITS 64
#include "procfs_fuse.h"
#include <Foundation/Foundation.h>
#include <errno.h>
#include "BackendProtocols.h"
#include "handlers/PFRootHandler.h"
#import "PFFileObjectMatcher.h"

int pf_getattr(const char* path, struct stat* st_ptr) {
    @autoreleasepool {
        id<PFBackendRepresentation> fileObject = [PFFileObjectMatcher getObjectForPath:[NSString stringWithUTF8String:path]];
        
        if (!fileObject) {
            return -ENOENT;
        }
        
        struct stat st = [fileObject getattr];
        
        memcpy(st_ptr, &st, sizeof(struct stat));
        return 0;
    }
}

int pf_readlink(const char* path, char* dest_buf, size_t bufsz) {
    return -ENOTSUP;
}

int pf_open(const char* path, struct fuse_file_info* fi) {
    @autoreleasepool {
        id<PFBackendRepresentation> objectHandler = [PFFileObjectMatcher getObjectForPath:[NSString stringWithUTF8String:path]];
        
        if (!objectHandler) {
            return -ENOENT;
        }
        
        if (![objectHandler isKindOfClass:[PFGenericPseudoFileHandler class]]) {
            return -ENOTSUP;
        }
        
        fi->fh = (uint64_t)CFBridgingRetain(objectHandler);
        return 0;
    }
}

int pf_read(const char* path, char* dest_buf, size_t bufsz, off_t offset, struct fuse_file_info* fi) {
    @autoreleasepool {
        PFGenericPseudoFileHandler* object = (__bridge PFGenericPseudoFileHandler*)(void*)fi->fh;
        if (![object isKindOfClass:[PFGenericPseudoFileHandler class]]) {
            return -ENOTSUP;
        }
        
        return [object read:bufsz destbuf:dest_buf offset:offset];
    }
}

int pf_statfs(const char* path, struct statvfs* statvfs_out) {
    statvfs_out->f_bsize = 0;
    statvfs_out->f_frsize = 0;
    statvfs_out->f_blocks = 0;
    statvfs_out->f_bfree = 0;
    statvfs_out->f_bavail = 0;
    statvfs_out->f_files = 0;
    statvfs_out->f_ffree = 0;
    statvfs_out->f_favail = 0;
    statvfs_out->f_fsid = 0;
    statvfs_out->f_flag = ST_RDONLY;
    statvfs_out->f_namemax = MAXPATHLEN;
    
    return 0;
}

int pf_release(const char* path, struct fuse_file_info* fi) {
    NSLog(@"releaseing");
    if (fi->fh) {
        // move the pointer back into ARC-land
        CFRelease((void*)fi->fh);
    }
    
    return 0;
}

int pf_opendir(const char* path, struct fuse_file_info* fi) {
    @autoreleasepool {
        id<PFBackendRepresentation> objectHandler = [PFFileObjectMatcher getObjectForPath:[NSString stringWithUTF8String:path]];
        
        if (!objectHandler) {
            return -ENOENT;
        }
        
        if (![objectHandler isKindOfClass:[PFGenericPseudoDirectoryHandler class]]) {
            return -ENOTDIR;
        }
        
        // the things we do to get rid of warnings
        fi->fh = (uint64_t)CFBridgingRetain(objectHandler);
        return 0;
    }
}

int pf_readdir(const char* path, void* buf, fuse_fill_dir_t filler, off_t offset, struct fuse_file_info* fi) {
    @autoreleasepool {
        void* handler = (void*)fi->fh;
        NSArray* dentry_buf = [(__bridge PFGenericPseudoDirectoryHandler*)handler getDirectoryEntries];
        
        for (PFDirectoryEntry* entry in dentry_buf) {
            struct stat st = entry.stat;
            filler(buf, entry.name.UTF8String, &st, 0);
        }

        return 0;
    }
}

int pf_releasedir(const char* path, struct fuse_file_info* fi) {
    return pf_release(path, fi);
}

int pf_access(const char* path, int somethign) {
    return -ENOTSUP;
}

int pf_readbuf(const char* path, struct fuse_bufvec** bufp, size_t size, off_t off, struct fuse_file_info* fi) {
    NSLog(@"here");
    struct fuse_bufvec* bufvec = calloc(1, sizeof(struct fuse_bufvec));
    
    *bufvec = FUSE_BUFVEC_INIT(size);
    
    char* mem = calloc(size, 1);
    int ret = pf_read(path, mem, size, off, fi);
    if (ret <= 0) {
        free(bufvec);
        return ret;
    }
    
    bufvec->buf[0].mem = mem;
    bufvec->buf[0].size = ret;
    
    *bufp = bufvec;
    
    return ret;
}

void* pf_init(struct fuse_conn_info* conn) {
    NSLog(@"Initialized");
    return NULL;
}

void pf_destroy(void* private_data) {
    NSLog(@"destroyed");
}

