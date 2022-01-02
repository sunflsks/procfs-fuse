//
//  DisplayDirHandler.h
//  procfs_fuse
//
//  Created by Sudhip Nashi on 12/18/21.
//

#ifndef DisplayDirHandler_h
#define DisplayDirHandler_h

#import "GenericHandlers.h"

@interface PFDisplayDirHandler : PFGenericPseudoDirectoryHandler
-(id)initWithDisplayId:(int)displayid;
@end

#endif /* DisplayDirHandler_h */
