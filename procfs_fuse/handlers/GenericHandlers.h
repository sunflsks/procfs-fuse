//
//  GenericHandlers.h
//  procfs_fuse
//
//  Created by Sudhip Nashi on 12/17/21.
//

#ifndef GenericHandlers_h
#define GenericHandlers_h

#import <Foundation/Foundation.h>
#import "../DirectoryEntry.h"
#import "../BackendProtocols.h"

@interface PFGenericPseudoDirectoryHandler : NSObject <PFPseudoDirectory>
-(struct stat)getattr;
+(struct pf_access_output)access:(int)mode;
-(NSArray<PFDirectoryEntry*>*)getDirectoryEntries;
@end

@interface PFGenericPseudoFileHandler : NSObject <PFPseudoFile>
-(struct stat)getattr;
+(struct stat)genericGetattr;
+(struct pf_access_output)access:(int)mode;
-(int)read:(size_t)bufsize destbuf:(char*)destbuf offset:(off_t)offset;
-(int)copyDataFromBuffer:(NSData*)data toDestinationBuffer:(char*)destbuf destinationBufferSize:(size_t)bufsize offset:(off_t)offset;
@end

#endif /* GenericHandlers_h */
