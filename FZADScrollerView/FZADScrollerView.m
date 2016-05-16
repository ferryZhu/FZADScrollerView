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
#define kMoveTimeInterval           3

@interface FZADScrollerView ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollerView;

@property (nonatomic, assign) NSInteger currentImage;

@property (nonatomic, strong) UIImageView *leftImageView;

@property (nonatomic, strong) UIImageView *centerImageView;

@property (nonatomic, strong) UIImageView *rightImageView;

@property (nonatomic, strong) NSTimer *moveTimer;

@property (nonatomic, assign) BOOL isAutoMove;

@end

@implementation FZADScrollerView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.scrollerView = [[UIScrollView alloc] initWithFrame:self.bounds];
        self.scrollerView.showsHorizontalScrollIndicator = NO;
        self.scrollerView.showsVerticalScrollIndicator = NO;
        self.scrollerView.pagingEnabled = YES;
        self.scrollerView.delegate = self;
        [self.scrollerView setContentSize:CGSizeMake(3 * kFZADScrollerViewWidth, kFZADScrollerViewHeight)];
        [self.scrollerView setContentOffset:CGPointMake(kFZADScrollerViewWidth, 0.0)];
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
        
        self.currentImage = 0;
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
    }
    self.pageControl.numberOfPages = _images.count;
}

- (void)timerAction
{
    [self.scrollerView setContentOffset:CGPointMake(2 * kFZADScrollerViewWidth, 0.0) animated:YES];
    self.isAutoMove = YES;
    [self performSelector:@selector(scrollViewDidEndDecelerating:) withObject:self.scrollerView afterDelay:0.4f];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.x == 0.0) {
        self.currentImage = (self.currentImage - 1) % self.images.count;
    } else if (scrollView.contentOffset.x == 2 * kFZADScrollerViewWidth) {
        self.currentImage = (self.currentImage + 1) % self.images.count;
    } else {
        return;
    }
    
    self.pageControl.currentPage = self.currentImage;
    self.leftImageView.image = [self.images objectAtIndex:(self.currentImage - 1) % self.images.count];
    self.centerImageView.image = [self.images objectAtIndex:self.currentImage % self.images.count];
    self.rightImageView.image = [self.images objectAtIndex:(self.currentImage + 1) % self.images.count];
    
    [self.scrollerView setContentOffset:CGPointMake(kFZADScrollerViewWidth, 0)];
    
    if (!self.isAutoMove) {
        // 手动滑动，计时器重新计算时间
        [self.moveTimer setFireDate:[NSDate dateWithTimeIntervalSinceNow:kMoveTimeInterval]];
    }
    self.isAutoMove = NO;
}

#pragma mark - GestureAction
- (void)scrollerViewTapGestureAction
{
    [self.delegate didSelectImageAtIndexPath:self.currentImage];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
