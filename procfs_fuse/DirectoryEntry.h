//
//  DirectoryEntries.h
//  procfs_fuse
//
//  Created by Sudhip Nashi on 12/17/21.
//

#ifndef DirectoryEntries_h
#define DirectoryEntries_h

@interface PFDirectoryEntry : NSObject
@property(nonatomic, readonly) struct stat stat;
@property(nonatomic, readonly) NSString* name;
-(id)initWithName:(NSString*)name stat:(struct stat)stat;
@end

#endif /* DirectoryEntries_h */
