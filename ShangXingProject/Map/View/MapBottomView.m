//
//  MapBottomView.m
//  ShangXingProject
//
//  Created by 张浩 on 2016/11/14.
//  Copyright © 2016年 张浩. All rights reserved.
//

#import "MapBottomView.h"
@interface MapBottomView()<UITextFieldDelegate>
@property (nonatomic , strong)UIButton *upDownBtn;
@property (nonatomic , strong)UIView *contentBackView;
@property (nonatomic , strong)UIView *scrollBackView;

@property (nonatomic , strong)UIView *textFieldBackView;
@property (nonatomic , strong)UIImageView *textFieldLeftImgView;
@property (nonatomic , strong)UITextField *textField;
@property (nonatomic , strong)UIButton *textFieldRightBtn;
@end
@implementation MapBottomView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(instancetype)init{
    self = [super init];
    if (self) {
        [self addSubview:self.contentBackView];
        [self addSubview:self.upDownBtn];
        [self.contentBackView addSubview:self.videoBtn];
        [self.contentBackView addSubview:self.imageBtn];
        [self.contentBackView addSubview:self.textFieldBackView];
        [self.contentBackView addSubview:self.scrollView];
        [self.scrollView addSubview:self.scrollBackView];
        [self.textFieldBackView addSubview:self.textFieldLeftImgView];
        [self.textFieldBackView addSubview:self.textField];
        [self.textFieldBackView addSubview:self.textFieldRightBtn];
        [self.upDownBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(20);
            make.top.equalTo(self.mas_top);
            make.width.height.equalTo(@20);
        }];
        [self.contentBackView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self);
            make.top.equalTo(self.mas_top).offset(10);
        }];
        [self.videoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.upDownBtn.mas_right);
            make.width.equalTo(@50);
            make.height.equalTo(@25);
            make.top.equalTo(self.upDownBtn.mas_bottom).offset(15);
        }];
        [self.imageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.videoBtn.mas_right).offset(20);
            make.width.equalTo(@50);
            make.height.equalTo(@25);
            make.top.equalTo(self.videoBtn.mas_top);
        }];
        [self.textFieldBackView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentBackView.mas_right).offset(-20);
            make.top.equalTo(self.videoBtn.mas_top);
            make.height.equalTo(@30);
            make.width.equalTo(@150);
        }];
        [self.textFieldLeftImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.textFieldBackView.mas_left);
            make.top.bottom.equalTo(self.textFieldBackView);
            make.width.equalTo(@25);
        }];
        [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.textFieldLeftImgView.mas_right);
            make.right.equalTo(self.textFieldRightBtn.mas_left);
            make.top.bottom.equalTo(self.textFieldBackView);
        }];
        [self.textFieldRightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.textFieldBackView.mas_right);
            make.top.bottom.equalTo(self.textFieldBackView);
            make.width.equalTo(@25);
        }];
        [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.contentBackView);
            make.top.equalTo(self.videoBtn.mas_bottom).offset(20);
            make.height.equalTo(@80);
        }];
        [self.scrollBackView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.scrollView);
            make.height.equalTo(self.scrollView);
            //right
        }];
        UIColor *redC = [UIColor redColor];
        UIColor *yellowC = [UIColor yellowColor];
        UIColor *blueC = [UIColor blueColor];
        UIColor *brownC = [UIColor brownColor];

        NSArray *colorArr = [[NSArray alloc]initWithObjects:redC,yellowC,blueC,brownC, nil];
        UIView *lastView;
        for (int i = 0; i < 10; i++) {
            UIImageView *img = [UIImageView new];
            int value = arc4random() % (3+1);
            img.backgroundColor = [colorArr objectAtIndex:value];
            [self.scrollBackView addSubview:img];
            [img mas_makeConstraints:^(MASConstraintMaker *make) {
                if (lastView) {
                        make.top.mas_equalTo(lastView.mas_top);
                        make.left.mas_equalTo(lastView.mas_right).offset(8);
                }else{
                    make.top.left.mas_equalTo(0);
                }
                make.width.mas_equalTo((SCREEN_WIDTH-16)/3);
                make.height.equalTo(@80);
            }];
            lastView = img;
        }
        [self.scrollBackView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(lastView.mas_right);
        }];
    }
    
    self.videoBtn.hidden = YES;
    self.imageBtn.hidden = YES;
    return self;
}
-(IBAction)upDownBtnClick:(id)sender{
    if ([self.delegate respondsToSelector:@selector(mapBottomViewUpDownBtnClick)]) {
        [self.delegate mapBottomViewUpDownBtnClick];
    }
}
-(IBAction)videoBtnClick:(id)sender{
    if ([self.delegate respondsToSelector:@selector(mapBottomViewVideoBtnClick)]) {
        [self.delegate mapBottomViewVideoBtnClick];
    }
}
-(IBAction)imageBtnClick:(id)sender{
    if ([self.delegate respondsToSelector:@selector(mapBottomViewImageBtnClick)]) {
        [self.delegate mapBottomViewImageBtnClick];
    }
}
-(IBAction)textFieldRightBtnAction:(id)sender{
    if ([self.delegate respondsToSelector:@selector(mapBottomViewTextFieldRightBtnClick)]) {
        [self.delegate mapBottomViewTextFieldRightBtnClick];
    }
}
#pragma mark getter and setter
-(UIButton *)upDownBtn{
    if (_upDownBtn == nil) {
        _upDownBtn = [[UIButton alloc]init];
        _upDownBtn.backgroundColor = [UIColor redColor];
        [_upDownBtn addTarget:self action:@selector(upDownBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _upDownBtn;
}
-(UIButton *)videoBtn{
    if (_videoBtn == nil) {
        _videoBtn = [[UIButton alloc]init];
        _videoBtn.backgroundColor = [UIColor whiteColor];
        [_videoBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [_videoBtn setTitle:@"视频" forState:UIControlStateNormal];
        [_videoBtn addTarget:self action:@selector(videoBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _videoBtn;
}
-(UIButton *)imageBtn{
    if (_imageBtn == nil) {
        _imageBtn = [[UIButton alloc]init];
        _imageBtn.backgroundColor = [UIColor whiteColor];
        [_imageBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [_imageBtn setTitle:@"图像" forState:UIControlStateNormal];
        [_imageBtn addTarget:self action:@selector(imageBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _imageBtn;
}
-(UIView *)contentBackView{
    if (_contentBackView == nil) {
        _contentBackView = [[UIView alloc]init];
        _contentBackView.backgroundColor = [UIColor colorWithHexString:@"#D3D3D3" alpha:0.5];
    }
    return _contentBackView;
}
-(UIScrollView *)scrollView{
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc]init];
    }
    return _scrollView;
}
-(UIView *)scrollBackView{
    if (_scrollBackView == nil) {
        _scrollBackView = [[UIView alloc]init];
    }
    return _scrollBackView;
}
-(UIView *)textFieldBackView{
    if (_textFieldBackView == nil) {
        _textFieldBackView = [[UIView alloc]init];
        _textFieldBackView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    }
    return _textFieldBackView;
}
-(UIImageView *)textFieldLeftImgView{
    if (_textFieldLeftImgView == nil) {
        _textFieldLeftImgView = [[UIImageView alloc]init];
        _textFieldLeftImgView.backgroundColor = [UIColor redColor];
    }
    return _textFieldLeftImgView;
}
-(UITextField *)textField{
    if (_textField == nil) {
        _textField = [[UITextField alloc]init];
        [_textField setBackgroundColor:RGB(60, 180, 180, 1)];
        _textField.delegate = self;
        _textField.placeholder = @"输入地点";
        _textField.font = [UIFont systemFontOfSize:14.0f];
        _textField.returnKeyType = UIReturnKeySearch;
        _textField.textColor = [UIColor whiteColor];
//        _textField.layer.cornerRadius = 5.0f;
        [_textField setValue:RGB(255, 255, 255, 0.6) forKeyPath:@"_placeholderLabel.textColor"];
        _textField.returnKeyType = UIReturnKeySearch;
    }
    return _textField;
}
-(UIButton *)textFieldRightBtn{
    if (_textFieldRightBtn == nil) {
        _textFieldRightBtn = [[UIButton alloc]init];
//        [_textFieldRightBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        _textFieldRightBtn.backgroundColor = [UIColor redColor];
        [_textFieldRightBtn addTarget:self action:@selector(textFieldRightBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _textFieldRightBtn;
}
@end
