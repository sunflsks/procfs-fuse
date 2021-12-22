//
//  PFContentsHandler.h
//  procfs_fuse
//
//  Created by Sudhip Nashi on 12/20/21.
//

#ifndef DisplayContentsHandler_h
#define DisplayContentsHandler_h

#import "../../../GenericHandlers.h"
#import <CoreGraphics/CoreGraphics.h>

@interface PFDisplayContentsHandler : PFGenericPseudoFileHandler
-(id)initWithDisplayID:(CGDirectDisplayID)displayId;
@end

#endif /* DisplayResHandler_h */
