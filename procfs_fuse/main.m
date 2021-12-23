#include <CoreGraphics/CoreGraphics.h>
#include <Foundation/Foundation.h>
#include "procfs_fuse.h"
#include "ops.h"

// request access to restricted APIs
void request_access(void) {
    CGRequestScreenCaptureAccess();
}

struct fuse_operations procfs_ops = {
    // file information
	.getattr = pf_getattr,
    .access = pf_access,
    
    // file access
	.open = pf_open,
	.read = pf_read,
    .read_buf = pf_readbuf,
    
    // dir access
    .opendir = pf_opendir,
    .readdir = pf_readdir,
    
    // fs object disposal
	.release = pf_release,
	.releasedir = pf_releasedir,
    
    // symlink shit
    .readlink = pf_readlink,
    
    // filesystem-wide ops
    .statfs = pf_statfs,
	.init = pf_init,
	.destroy = pf_destroy,

	// this filesystem is read only, fuck all this
	// modifying shit
	.getdir = NULL,
	.mknod = NULL,
	.mkdir = NULL,
	.unlink = NULL,
	.rmdir = NULL,
	.symlink = NULL,
	.rename = NULL,
	.link = NULL,
	.chmod = NULL,
	.chown = NULL,
	.truncate = NULL,
	.utime = NULL,
	.flush = NULL,
	.fsync = NULL,
	.fsyncdir = NULL,
	.create = NULL,
	.lock = NULL,
	.utimens = NULL,
	.bmap = NULL,
	.ioctl = NULL,
	.poll = NULL,
	.flock = NULL,
	.fallocate = NULL,
};

int main(int argc, char** argv) {
    @autoreleasepool {
        NSTask* task = [NSTask launchedTaskWithLaunchPath:@"/usr/sbin/diskutil" arguments:@[@"umount", @"/opt/proc"]];
        [task waitUntilExit];
        request_access();
    }
    
    char* new_args[argc + 2];
    for (int i = 0; i <= argc; i++) {
        new_args[i] = argv[i];
    }
    
    new_args[argc + 0] = "-ofsname=procfs_fuse";
    
    return fuse_main(argc + 1, new_args, &procfs_ops, NULL);
}
