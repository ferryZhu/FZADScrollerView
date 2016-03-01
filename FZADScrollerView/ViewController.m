//
//  ViewController.m
//  FZADScrollerView
//
//  Created by Ferryzhu on 16/3/1.
//  Copyright © 2016年 FerryZhu. All rights reserved.
//

#import "ViewController.h"
#import "FZADScrollerView.h"

@interface ViewController ()<FZADScrollerViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSMutableArray *images = [NSMutableArray array];
    for (int i = 1; i <= 4; i ++) {
        [images addObject:[self createImage:[NSString stringWithFormat:@"%d", i]]];
    }
    
    FZADScrollerView *adScrollerView = [[FZADScrollerView alloc] initWithFrame:CGRectMake(0.0, 0.0, [UIScreen mainScreen].bounds.size.width, 150) images:images];
    adScrollerView.delegate = self;
    [self.view addSubview:adScrollerView];
}

- (UIImage *)createImage:(NSString *)imageName
{
    return [UIImage imageNamed:imageName];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)didSelectImageAtIndexPath:(NSInteger)indexPath
{
    NSLog(@"didSelectImageIndexPath = %ld", indexPath);
}

@end
