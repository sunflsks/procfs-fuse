//
//  FileObjectMatcher.h
//  procfs_fuse
//
//  Created by Sudhip Nashi on 12/18/21.
//

#ifndef FileObjectMatcher_h
#define FileObjectMatcher_h

#include "GenericHandlers.h"
#include "BackendProtocols.h"

@interface PFFileObjectMatcher : NSObject
+(id<PFBackendRepresentation>)getObjectForPath:(NSString*)path;
@end

#endif /* FileObjectMatcher_h */
