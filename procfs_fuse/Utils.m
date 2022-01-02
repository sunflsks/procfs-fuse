//
//  Utils.m
//  procfs_fuse
//
//  Created by Sudhip Nashi on 1/1/22.
//

@import Foundation;

#import <sys/sysctl.h>
#import <libproc.h>
#import "Utils.h"

static int name[] = { CTL_KERN, KERN_PROC, KERN_PROC_ALL, 0 };

NSArray<NSNumber*>* getAllPIDs(void) {
    NSMutableArray* pidArray = [NSMutableArray array];
    size_t size = 0;
    int err = 0;
    
    err = sysctl(name, (sizeof(name) / sizeof(int)) - 1, NULL, &size, NULL, 0);
    
    if (err == -1) {
        NSLog(@"Error in %s:%d: %s", __FILE__, __LINE__, strerror(errno));
        return nil;
    }
    
    struct kinfo_proc* proc = calloc(size, 1);
    
    err = sysctl(name, (sizeof(name)/sizeof(int)) - 1, proc, &size, NULL, 0);
    if (err == -1) {
        NSLog(@"Error in %s:%d: %s", __FILE__, __LINE__, strerror(errno));
        return nil;
    }
    
    int procCount = (int)(size / sizeof(struct kinfo_proc));
    
    for (int i = 0; i < procCount; i++) {
        int pid = proc[i].kp_proc.p_pid;
        [pidArray addObject:[NSNumber numberWithInt:pid]];
    }
    
    return pidArray;
}
