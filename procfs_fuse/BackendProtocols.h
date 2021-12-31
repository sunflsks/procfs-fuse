//
//  BackendProtocols.h
//  procfs_fuse
//
//  Created by Sudhip Nashi on 12/17/21.
//

#import <Foundation/Foundation.h>
#import "DirectoryEntry.h"
#import "procfs_fuse.h"

NS_ASSUME_NONNULL_BEGIN

enum pf_access_outputcodes {
    ACCESS_OK,
    ACCESS_HELLNO,
    ACCESS_ERRNO
};

struct pf_access_output {
    enum pf_access_outputcodes output;
    int pf_errno;
};

@protocol PFBackendRepresentation <NSObject>
// getattr() call: fill out st with the attributes of the pseudo-file
-(struct stat)getattr;

// access() call: return YES or NO if the file can be accessed (mask [like F_OK, W_OK] is in `mask` var)
+(struct pf_access_output)access:(int)mode;

// dealloc: since our object is manually retained, this will be called
// manually whenever the file is closed for the last time. clean up and free
// shit
-(void)dealloc;
@end

@protocol PFPseudoFile <PFBackendRepresentation>
-(int)read:(size_t)bufsize destbuf:(char*)destbuf offset:(off_t)offset;
@end

@protocol PFPseudoDirectory <PFBackendRepresentation>
-(NSArray<PFDirectoryEntry*>*)getDirectoryEntries;
@end

NS_ASSUME_NONNULL_END
