//
//  MapTopSegmentedView.m
//  ShangXingProject
//
//  Created by 张浩 on 2016/11/15.
//  Copyright © 2016年 张浩. All rights reserved.
//

#import "MapTopSegmentedView.h"
#define HeaderToolBar_Height                30
#define HeaderToolBar_MaxShowTitleNum       4
#define View_Size_Width     self.frame.size.width
#define View_Size_Height    self.frame.size.height

#define Base_TAG    0
@interface MapTopSegmentedView()

@property (nonatomic , strong) UIScrollView *scrollView;
@property (nonatomic , strong) UIView *scrollBackView;
@property (nonatomic ,assign) NSInteger maxShowNum;
@property (nonatomic ,assign) NSInteger titleArrCount;

@end
@implementation MapTopSegmentedView

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */
-(instancetype)initWithFrame:(CGRect)frame TitleArray:(NSArray *)titleArr {
    
    if(self = [super initWithFrame:frame]){
        
        self = [self initWithFrame:frame TitleArray:titleArr MaxShowTitleNum:HeaderToolBar_MaxShowTitleNum];
        self.titleArrCount = titleArr.count;
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame TitleArray:(NSArray *)titleArr MaxShowTitleNum:(NSInteger)maxNum{
    
    if(self = [super initWithFrame:frame]){
        
        if(titleArr.count == 0){
            return nil;
        }
        [self addSubview:self.scrollView];
        [self.scrollView addSubview:self.scrollBackView];
        [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.centerY.equalTo(self.mas_centerY);
            make.height.equalTo(@30);
        }];
        [self.scrollBackView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.scrollView);
            make.height.equalTo(self.scrollView);
            //right
        }];
        self.maxShowNum = HeaderToolBar_MaxShowTitleNum;
        if(HeaderToolBar_MaxShowTitleNum > titleArr.count){
            self.maxShowNum = titleArr.count;
        }
        CGFloat btnWidth = View_Size_Width / self.maxShowNum;
        if (titleArr != nil && titleArr.count > 0) {
            UIView *lastView;
            for (int i = 0; i < titleArr.count; i++) {
                NSString *title = titleArr[i];
                CGFloat titleWidth = [title sizeWithFont:[UIFont systemFontOfSize:14] maxSize:CGSizeMake(btnWidth, View_Size_Height)].width+8;
                CGFloat titleHeight = [title sizeWithFont:[UIFont systemFontOfSize:14] maxSize:CGSizeMake(btnWidth, View_Size_Height)].height+2;
                UIButton  *touchBtn = [[UIButton alloc]init];
                touchBtn.tag = Base_TAG + i;
                [touchBtn addTarget:self action:@selector(touchButton:) forControlEvents:UIControlEventTouchUpInside];
                UILabel *titleLable = [[UILabel alloc] initWithFrame:CGRectMake((btnWidth-titleWidth)/2, (View_Size_Height-titleHeight)/2, titleWidth, titleHeight)];
                titleLable.backgroundColor = [UIColor clearColor];
                titleLable.layer.cornerRadius = titleHeight / 2;
                titleLable.layer.masksToBounds = YES;
                titleLable.text = title;
                titleLable.font = [UIFont systemFontOfSize:14];
                titleLable.textAlignment = NSTextAlignmentCenter;
                [touchBtn addSubview:titleLable];
                
                [self.scrollBackView addSubview:touchBtn];
                [touchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    if (lastView) {
                        make.top.mas_equalTo(lastView.mas_top);
                        make.left.mas_equalTo(lastView.mas_right);
                    }else{
                        make.top.left.mas_equalTo(0);
                    }
                    make.width.mas_equalTo(btnWidth);
                    make.height.equalTo(@30);
                }];
                lastView = touchBtn;
                //默认选择第一个
                if (i == 0) {
                    titleLable.textColor = [UIColor whiteColor];
                    titleLable.backgroundColor = [UIColor orangeColor];
                }
            }
            [self.scrollBackView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(lastView.mas_right);
            }];

            
        }
        
    }
    return self;
}
- (void)touchButton:(UIButton *)sender{
    for (UIView *subView in self.scrollBackView.subviews) {
        if ([subView isKindOfClass:[UIButton class]]) {
            UIButton *subButton = (UIButton *)subView;
            if (subButton.tag == sender.tag) {
                //在这里拿到点击的button
                UILabel *titleLab = subButton.subviews[0];
                titleLab.textColor = [UIColor whiteColor];
                titleLab.backgroundColor = [UIColor orangeColor];
                if (self.delegate) {
                    if ([self.delegate respondsToSelector:@selector(MapTopSegmentedViewDidSelectItemWithIndex:)]) {
                        [self.delegate MapTopSegmentedViewDidSelectItemWithIndex:sender.tag-Base_TAG];
                    }
                }
            }else{
                UILabel *titleLab = subButton.subviews[0];
                titleLab.textColor = [UIColor blackColor];
                titleLab.backgroundColor = [UIColor clearColor];
            }
        }
        
    }
}
#pragma mark getter and setter
-(UIScrollView *)scrollView{
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc]init];
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.clipsToBounds = YES;
        
    }
    return _scrollView;
}
-(UIView *)scrollBackView{
    if (_scrollBackView == nil) {
        _scrollBackView = [[UIView alloc]init];
    }
    return _scrollBackView;
}
@end
