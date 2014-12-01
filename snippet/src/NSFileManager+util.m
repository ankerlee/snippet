//
//  NSFileManager+util.m
//  snippet
//
//  Created by lili on 14/12/1.
//
//

#import "NSFileManager+util.h"

NSString *NSDocumentsFolder() {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return documentsDirectory;
}

NSString *NSLibraryFolder() {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *libraryDirectory = [paths objectAtIndex:0];
    return libraryDirectory;
}

NSString *NSBundleFolder() {
    return [[NSBundle mainBundle] bundlePath];
}

@implementation NSFileManager (util)

+ (NSString *)pathForItemNamed:(NSString *)fname inFolder:(NSString *)path {
    NSString *file;
    NSDirectoryEnumerator *dirEnum = [[NSFileManager defaultManager] enumeratorAtPath:path];
    while (file = [dirEnum nextObject])
        if ([[file lastPathComponent] isEqualToString:fname])
            return [path stringByAppendingPathComponent:file];
    return nil;
}

+ (NSString *)pathForDocumentNamed:(NSString *)fname {
    return [NSFileManager pathForItemNamed:fname inFolder:NSDocumentsFolder()];
}

+ (NSArray *)filesInFolder:(NSString *)path {
    NSString *file;
    NSMutableArray *results = [NSMutableArray array];
    NSDirectoryEnumerator *dirEnum = [[NSFileManager defaultManager] enumeratorAtPath:path];
    while (file = [dirEnum nextObject])
    {
        BOOL isDir;
        [[NSFileManager defaultManager] fileExistsAtPath:[path stringByAppendingPathComponent:file] isDirectory: &isDir];
        if (!isDir) [results addObject:file];
    }
    return results;
}

+ (NSArray *)pathsForItemsMatchingExtension: (NSString *)ext inFolder:(NSString *)path {
    NSString *file;
    NSMutableArray *results = [NSMutableArray array];
    NSDirectoryEnumerator *dirEnum = [[NSFileManager defaultManager] enumeratorAtPath:path];
    while (file = [dirEnum nextObject])
        if ([[file pathExtension] caseInsensitiveCompare:ext] == NSOrderedSame)
            [results addObject:[path stringByAppendingPathComponent:file]];
    return results;
}

+ (NSArray *)pathsForDocumentsMatchingExtension:(NSString *)ext {
    return [NSFileManager pathsForItemsMatchingExtension:ext inFolder:NSDocumentsFolder()];
}

+ (BOOL)addSkipBackupAttributeToItemAtPath:(NSString *)path {
    NSError *error = nil;
    BOOL success = [[NSURL fileURLWithPath:path] setResourceValue:[NSNumber numberWithBool:YES] forKey:NSURLIsExcludedFromBackupKey error:&error];
    if (!success) {
        NSLog(@"Error excluding %@ from backup %@", [[NSURL fileURLWithPath:path] lastPathComponent], error);
    }
    return success;
}

+ (BOOL)findOrCreateDirectoryPath:(NSString *)path {
    return [NSFileManager findOrCreateDirectoryPath:path backup:YES dataProtection:nil];
}

+ (BOOL)findOrCreateDirectoryPath:(NSString *)path backup:(BOOL)shouldBackup dataProtection:(NSString *)dataProtection {
    BOOL isDirectory;
    BOOL exists = [[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDirectory];
    if (exists) {
        if (isDirectory) {
            return YES;
        }
        return NO;
    }
    NSError *error;
    BOOL success = [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error];
    if (success && !shouldBackup) {
        [NSFileManager addSkipBackupAttributeToItemAtPath:path];
    }
    if (success && ![dataProtection isEqual:nil]) {
        [[NSFileManager defaultManager] setAttributes:@{NSFileProtectionKey:dataProtection} ofItemAtPath:path error:&error];
    }
    return success;
}

@end
