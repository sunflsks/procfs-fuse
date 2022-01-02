//
//  FileObjectMatcher.m
//  procfs_fuse
//
//  Created by Sudhip Nashi on 12/18/21.
//

#import <Foundation/Foundation.h>
#import "PFFileObjectMatcher.h"
#import "BackendProtocols.h"
#import "Handlers.h"

@interface PFFileObjectMatcher (Private)
+(id<PFBackendRepresentation>)handleSysDirectory:(NSString*)path;
+(id<PFBackendRepresentation>)handleDisplayDirectory:(NSString*)path;
@end

@implementation PFFileObjectMatcher

+(id<PFBackendRepresentation>)getObjectForPath:(NSString *)path {
    if ([path isEqualToString:@"/"]) {
        return [[PFRootHandler alloc] init];
    }
    
    if ([path hasPrefix:@"/sys"]) {
        NSString* pathToPass = [path substringFromIndex:@"/sys".length];
        return [self handleSysDirectory:pathToPass];
    }
    
    if ([path rangeOfString:@"\\/\\d*" options:NSRegularExpressionSearch].location != NSNotFound) {
        return [[PFGenericPseudoDirectoryHandler alloc] init];
    }
    
    // if the object cannot be found in the tree above, return nil
    return nil;
}

+(id<PFBackendRepresentation>)handleSysDirectory:(NSString *)path {
    if (path.length == 0) {
        return [[PFSysHandler alloc] init];
    }
    
    if ([path hasPrefix:@"/displays"]) {
        // cut the path so that /proc/displays can be moved around w/ minimal
        // hardcoding
        NSString* pathToPass = [path substringFromIndex:@"/displays".length];
        return [self handleDisplayDirectory:pathToPass];
    }
    
    if ([path hasPrefix:@"/cursor"]) {
        NSString* pathToPass = [path substringFromIndex:@"/cursor".length];
        return [self handleCursorDirectory:pathToPass];
    }
    
    return nil;
}

+(id<PFBackendRepresentation>)handleCursorDirectory:(NSString*)path {
    if (path.length == 0) {
        return [[PFCursorHandler alloc] init];
    }
    
    if ([path isEqualToString:@"/position"]) {
        return [[PFCursorPositionHandler alloc] init];
    }
    
    return nil;
}

+(id<PFBackendRepresentation>)handleDisplayDirectory:(NSString*)path {
    if (path.length == 0) {
        return [[PFDisplayHandler alloc] init];
    }
    
    NSString* regexForDisplayIDs = @"\\/display\\d*";
    NSString* regexForDisplayIDsAndSubdirs = @"\\/display\\d+(.*)";
    
    NSPredicate* displayIDsAndSubdirsPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regexForDisplayIDsAndSubdirs];
    NSPredicate* displayIDsPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regexForDisplayIDs];
    
    // path is under /displays/display<num>
    if ([displayIDsAndSubdirsPredicate evaluateWithObject:path]) {
        NSString* firstPathComponent = [path pathComponents][1];
        int displayID = [[firstPathComponent stringByReplacingOccurrencesOfString:@"[^0-9]+" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, firstPathComponent.length)] intValue];
        
        if ([displayIDsPredicate evaluateWithObject:path]) {
            return [[PFDisplayDirHandler alloc] initWithDisplayId:displayID];
        }
        
        // path is /displays/display<num>/whatever
        
        NSString* displayIDSubdir = [path stringByReplacingOccurrencesOfString:regexForDisplayIDs withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, path.length)];
        
        if ([displayIDSubdir isEqualToString:@"/properties"]) {
            return [[PFDisplayPropertiesHandler alloc] initWithDisplayID:displayID];
        }
        
        if ([displayIDSubdir isEqualToString:@"/contents.png"]) {
            return [[PFDisplayContentsHandler alloc] initWithDisplayID:displayID];
        }
    }
    
    return nil;
}

@end
