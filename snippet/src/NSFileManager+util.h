//
//  NSFileManager+util.h
//  snippet
//
//  Created by lili on 14/12/1.
//
//

#import <Foundation/Foundation.h>

NSString *NSDocumentsFolder();
NSString *NSLibraryFolder();
NSString *NSBundleFolder();

@interface NSFileManager (util)

+ (NSString *)pathForItemNamed:(NSString *)fname inFolder:(NSString *)path;
+ (NSString *)pathForDocumentNamed:(NSString *)fname;

+ (NSArray *)pathsForItemsMatchingExtension:(NSString *)ext inFolder:(NSString *)path;
+ (NSArray *)pathsForDocumentsMatchingExtension:(NSString *)ext;

+ (NSArray *)filesInFolder:(NSString *)path;


+ (BOOL)addSkipBackupAttributeToItemAtPath:(NSString *)path;
+ (BOOL)findOrCreateDirectoryPath:(NSString *)path;
+ (BOOL)findOrCreateDirectoryPath:(NSString *)path backup:(BOOL)shouldBackup dataProtection:(NSString *)dataProtection;

@end
