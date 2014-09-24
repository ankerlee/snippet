//
//  ImageUtilTest.m
//  snippet
//
//  Created by lili on 14-9-24.
//
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "UIImage+util.h"

@interface ImageUtilTest : XCTestCase

@end

@implementation ImageUtilTest

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)test_imageMaskedWithColor
{
    UIImage *originalImg = [UIImage imageNamed:@"bubble"];
    UIImage *newImg = [originalImg imageMaskedWithColor:[UIColor orangeColor]];
    NSLog(@"---");
}

@end
