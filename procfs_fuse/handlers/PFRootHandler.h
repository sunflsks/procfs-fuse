//
//  RootHandler.h
//  procfs_fuse
//
//  Created by Sudhip Nashi on 12/17/21.
//

#ifndef RootHandler_h
#define RootHandler_h

#import "GenericHandlers.h"

@interface PFRootHandler : PFGenericPseudoDirectoryHandler <PFPseudoDirectory>

@end

#endif /* RootHandler_h */
