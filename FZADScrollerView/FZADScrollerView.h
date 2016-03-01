//
//  FZADScrollerView.h
//  FZADScrollerView
//
//  Created by Ferryzhu on 16/3/1.
//  Copyright © 2016年 FerryZhu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FZADScrollerViewDelegate <NSObject>

- (void)didSelectImageAtIndexPath:(NSInteger)indexPath;

@end

@interface FZADScrollerView : UIView

@property (nonatomic, strong) NSArray *images;

@property (nonatomic, strong) UIPageControl *pageControl;

@property (nonatomic, weak) id<FZADScrollerViewDelegate> delegate;

- (id)initWithFrame:(CGRect)frame images:(NSArray *)images;

@end
