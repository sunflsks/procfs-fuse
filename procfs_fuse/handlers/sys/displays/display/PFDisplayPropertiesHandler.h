//
//  DisplayResHandler.h
//  procfs_fuse
//
//  Created by Sudhip Nashi on 12/19/21.
//

#ifndef DisplayResHandler_h
#define DisplayResHandler_h

#import "../../../GenericHandlers.h"
#import <CoreGraphics/CoreGraphics.h>

@interface PFDisplayPropertiesHandler : PFGenericPseudoFileHandler
-(id)initWithDisplayID:(CGDirectDisplayID)displayId;
@end

#endif /* DisplayResHandler_h */
