//
//  FZADScrollerView.m
//  FZADScrollerView
//
//  Created by Ferryzhu on 16/3/1.
//  Copyright © 2016年 FerryZhu. All rights reserved.
//

#import "FZADScrollerView.h"

#define kFZADScrollerViewHeight     self.bounds.size.height
#define kFZADScrollerViewWidth      self.bounds.size.width
#define kMoveTimeInterval           2

@interface FZADScrollerView ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollerView;

@property (nonatomic, assign) NSInteger currentImageIndex;

@property (nonatomic, strong) UIImageView *leftImageView;

@property (nonatomic, strong) UIImageView *centerImageView;

@property (nonatomic, strong) UIImageView *rightImageView;

@property (nonatomic, strong) NSTimer *moveTimer;

@end

@implementation FZADScrollerView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addSubview:self.scrollerView];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollerViewTapGestureAction)];
        [self.scrollerView addGestureRecognizer:tapGesture];
        
        self.leftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, kFZADScrollerViewWidth, kFZADScrollerViewHeight)];
        [self.scrollerView addSubview:self.leftImageView];
        
        self.centerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kFZADScrollerViewWidth, 0.0, kFZADScrollerViewWidth, kFZADScrollerViewHeight)];
        [self.scrollerView addSubview:self.centerImageView];
        
        self.rightImageView = [[UIImageView alloc] initWithFrame:CGRectMake(2 * kFZADScrollerViewWidth, 0.0, kFZADScrollerViewWidth, kFZADScrollerViewHeight)];
        [self.scrollerView addSubview:self.rightImageView];
        
        self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0.0, kFZADScrollerViewHeight - 20.0, kFZADScrollerViewWidth, 20)];
        self.pageControl.backgroundColor = [UIColor darkGrayColor];
        [self addSubview:self.pageControl];
        
        self.currentImageIndex = 0;
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame images:(NSArray *)images
{
    self = [self initWithFrame:frame];
    if (self) {
        self.images = [NSArray arrayWithArray:images];
    }
    
    return self;
}

- (UIScrollView *)scrollerView
{
    if (!_scrollerView) {
        _scrollerView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollerView.showsHorizontalScrollIndicator = NO;
        _scrollerView.showsVerticalScrollIndicator = NO;
        _scrollerView.pagingEnabled = YES;
        _scrollerView.delegate = self;
        [_scrollerView setContentSize:CGSizeMake(3 * kFZADScrollerViewWidth, kFZADScrollerViewHeight)];
        [_scrollerView setContentOffset:CGPointMake(kFZADScrollerViewWidth, 0.0)];
    }
    
    return _scrollerView;
}

- (void)setImages:(NSArray *)images
{
    if (images.count == 0) {
        return;
    }
    
    _images = images;
    if (images.count == 1) {
        self.centerImageView.image = [_images lastObject];
        self.scrollerView.scrollEnabled = NO;
    } else if (images.count >= 2) {
        self.leftImageView.image = [_images lastObject];
        self.centerImageView.image = [_images objectAtIndex:0];
        self.rightImageView.image = [_images objectAtIndex:1];
        // image >= 2时 开启轮播
        self.moveTimer = [NSTimer scheduledTimerWithTimeInterval:kMoveTimeInterval target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self.moveTimer forMode:NSDefaultRunLoopMode];
    }
    self.pageControl.numberOfPages = _images.count;
}

- (void)timerAction
{
    [self.scrollerView setContentOffset:CGPointMake(2 * kFZADScrollerViewWidth, 0.0) animated:YES];
    [self performSelector:@selector(scrollViewDidEndDecelerating:) withObject:self.scrollerView afterDelay:0.4f];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.x == 0.0) {
        self.currentImageIndex = (self.currentImageIndex - 1) % self.images.count;
    } else if (scrollView.contentOffset.x == 2 * kFZADScrollerViewWidth) {
        self.currentImageIndex = (self.currentImageIndex + 1) % self.images.count;
    } else {
        return;
    }
    
    self.pageControl.currentPage = self.currentImageIndex;
    self.leftImageView.image = [self.images objectAtIndex:(self.currentImageIndex - 1) % self.images.count];
    self.centerImageView.image = [self.images objectAtIndex:self.currentImageIndex % self.images.count];
    self.rightImageView.image = [self.images objectAtIndex:(self.currentImageIndex + 1) % self.images.count];
    
    [self.scrollerView setContentOffset:CGPointMake(kFZADScrollerViewWidth, 0)];
    
    // 手动滑动时 RunLoop的模式由 NSDefaultRunLoopMode 更改为 UITrackingRunLoopMode
    if ([[NSRunLoop currentRunLoop] currentMode] == UITrackingRunLoopMode) {
        [self.moveTimer setFireDate:[NSDate dateWithTimeIntervalSinceNow:kMoveTimeInterval]];
    }
}

#pragma mark - GestureAction
- (void)scrollerViewTapGestureAction
{
    [self.delegate didSelectImageAtIndexPath:self.currentImageIndex];
}

@end
