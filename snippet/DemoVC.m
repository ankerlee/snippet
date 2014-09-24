//
//  DemoVC.m
//  snippet
//
//  Created by lili on 14-9-24.
//
//

#import "DemoVC.h"
#import "UIImage+util.h"

@interface DemoVC ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView2;

@end

@implementation DemoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UIImage *originalImg = [UIImage imageNamed:@"bubble"];
    //变色
    UIImage *newImg = [originalImg imageMaskedWithColor:[UIColor orangeColor]];
    //转向
    newImg = [newImg imageFlippedHorizontal];
    //拉伸
    newImg = [newImg stretchableImageWithCapInsets:UIEdgeInsetsMake(originalImg.size.height / 2 - 1, originalImg.size.width / 2 - 1, originalImg.size.height / 2 + 1, originalImg.size.width / 2 +1)];
    self.imageView.image = newImg;
    
    originalImg = [UIImage imageNamed:@"icon"];
    newImg = [originalImg imageAsCircle:YES withDiamter:120 borderColor:[UIColor orangeColor] borderWidth:1.0 shadowOffSet:CGSizeMake(1.0, 1.0)];
    self.imageView2.image = newImg;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
