# FZADScrollerView
支持图片复用，点击事件，自动播放
# 使用方法
    FZADScrollerView *adScrollerView = [[FZADScrollerView alloc] initWithFrame:CGRectMake(0.0, 0.0, [UIScreen mainScreen].bounds.size.width, 150) images:images];
    adScrollerView.delegate = self;
    [self.view addSubview:adScrollerView];
    FZADScrollerViewDelegate
        - (void)didSelectImageAtIndexPath:(NSInteger)indexPath; 
