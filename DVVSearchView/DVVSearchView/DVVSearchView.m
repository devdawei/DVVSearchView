//
//  DVVSearchView.m
//  DVVSearchView <https://github.com/devdawei/DVVSearchView.git>
//
//  Created by 大威 on 16/6/20.
//  Copyright © 2016年 devdawei. All rights reserved.
//

#import "DVVSearchView.h"

CGFloat const DVVSearchViewHeight = 44.0;
CGFloat const DVVSearchViewSearchHeight = 32.0;
CGFloat const DVVSearchViewAnimateDuration = 0.3;
CGFloat const DVVSearchViewFontSize = 14.0;
CGFloat const DVVSearchViewCancelButtonWidth = DVVSearchViewFontSize * 2.5;

@interface DVVSearchView ()

/** 背景视图 */
@property (nonatomic, strong) UIImageView *backgroundImageView;

@property (nonatomic, strong) UIButton *cancelButton;

@end

@implementation DVVSearchView

#pragma mark - Init

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.backgroundColor = [UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1];
        
        [self addSubview:self.backgroundImageView];
        [self addSubview:self.textField];
        [self addSubview:self.cancelButton];
    }
    return self;
}

#pragma mark - UI

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (_textField.isEditing)
    {
        [self searchStatusFrame];
    }
    else
    {
        [self normalStatusFrame];
    }
    
//    /* 调试时打开 */
//    _textField.backgroundColor = [UIColor greenColor];
//    _cancelButton.backgroundColor = [UIColor orangeColor];
}

#pragma mark -

- (void)normalStatusFrame
{
    CGFloat viewWidth = self.bounds.size.width;
    CGFloat viewHeight = self.bounds.size.height;
    CGFloat radius = DVVSearchViewSearchHeight / 2.0;
    CGFloat margin = 8;
    // 背景视图
    _backgroundImageView.frame = CGRectMake(margin,
                                            (viewHeight - DVVSearchViewSearchHeight) / 2.0,
                                            viewWidth - margin*2.0,
                                            viewHeight - (viewHeight - DVVSearchViewSearchHeight));
    // 输入框
    _textField.frame = CGRectMake(CGRectGetMinX(_backgroundImageView.frame) + radius,
                                  CGRectGetMinY(_backgroundImageView.frame),
                                  CGRectGetWidth(_backgroundImageView.frame) - radius*2,
                                  CGRectGetHeight(_backgroundImageView.frame));
    // 搜索按钮
    _cancelButton.frame = CGRectMake((viewWidth - DVVSearchViewCancelButtonWidth) / 2.0,
                                     CGRectGetMinY(_backgroundImageView.frame),
                                     DVVSearchViewCancelButtonWidth,
                                     CGRectGetHeight(_backgroundImageView.frame));
}

- (void)searchStatusFrame
{
    CGFloat viewWidth = self.bounds.size.width;
    CGFloat viewHeight = self.bounds.size.height;
    CGFloat radius = DVVSearchViewSearchHeight / 2.0;
    CGFloat margin = 8;
    // 背景视图
    _backgroundImageView.frame = CGRectMake(margin,
                                            (viewHeight - DVVSearchViewSearchHeight) / 2.0,
                                            viewWidth - margin*2 - DVVSearchViewCancelButtonWidth - margin,
                                            viewHeight - (viewHeight - DVVSearchViewSearchHeight));
    // 输入框
    _textField.frame = CGRectMake(CGRectGetMinX(_backgroundImageView.frame) + radius,
                                  CGRectGetMinY(_backgroundImageView.frame),
                                  CGRectGetWidth(_backgroundImageView.frame) - radius,
                                  CGRectGetHeight(_backgroundImageView.frame));
    // 搜索按钮
    _cancelButton.frame = CGRectMake(viewWidth - margin - DVVSearchViewCancelButtonWidth,
                                     CGRectGetMinY(_backgroundImageView.frame),
                                     DVVSearchViewCancelButtonWidth,
                                     CGRectGetHeight(_backgroundImageView.frame));
}

#pragma mark 搜索框无文本输入，并且取消搜索状态时
- (void)normalStatus
{
    _textField.placeholder = @"";
    
    [_cancelButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [_cancelButton setTitleColor:[UIColor grayColor] forState:UIControlStateSelected];
    
    [_cancelButton setTitle:@"搜索" forState:UIControlStateNormal];
    
    [UIView animateWithDuration:DVVSearchViewAnimateDuration animations:^{
        
        [self normalStatusFrame];
        
    } completion:^(BOOL finished) {
        
        _cancelButton.userInteractionEnabled = NO;
        
    }];
}

#pragma mark 正在搜索状态时
- (void)searchStatus
{
    [_cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_cancelButton setTitleColor:[UIColor grayColor] forState:UIControlStateSelected];
    
    [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    
    [UIView animateWithDuration:DVVSearchViewAnimateDuration animations:^{
        
        [self searchStatusFrame];
        
    } completion:^(BOOL finished) {
        
        if (_placeholderText.length)
        {
            _textField.placeholder = _placeholderText;
        }
        else
        {
            _textField.placeholder = @"请输入搜索内容";
        }
        _cancelButton.userInteractionEnabled = YES;
        
    }];
}

#pragma mark - Action
#pragma mark 取消按钮事件
- (void)cancelButtonAction:(UIButton *)sender
{
    if (_textField.text.length)
    {
        if (_textChangeBlock)
        {
            _textField.text = @"";
            _textChangeBlock(_textField);
        }
    }
    _textField.text = @"";
    
    [_textField resignFirstResponder];
    
    [self normalStatus];
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    // 回调
    if (_didBeginEditingBlock)
    {
        _didBeginEditingBlock(textField);
    }
    
    [self searchStatus];
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (_didEndEditingBlock)
    {
        _didEndEditingBlock(textField);
    }
    // 如果textField内容不为空时则取消按钮不回到中心，还可以响应用户点击
    if (textField.text.length)
    {
        return ;
    }
    [self normalStatus];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)textChange:(UITextField *)textField
{
    if (_textChangeBlock)
    {
        _textChangeBlock(textField);
    }
}

#pragma mark - Setter getter

- (CGFloat)defaultHeight
{
    return DVVSearchViewHeight;
}

#pragma mark - Lazy load

- (UIImageView *)backgroundImageView
{
    if (!_backgroundImageView)
    {
        _backgroundImageView = [UIImageView new];
        _backgroundImageView.backgroundColor = [UIColor whiteColor];
        // 设置背景视图为圆角
        [_backgroundImageView.layer setMasksToBounds:YES];
        [_backgroundImageView.layer setCornerRadius:DVVSearchViewSearchHeight/2.0];
    }
    return _backgroundImageView;
}

- (UITextField *)textField
{
    if (!_textField)
    {
        _textField = [UITextField new];
        _textField.delegate = self;
        _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _textField.keyboardType = UIKeyboardTypeDefault;
        _textField.returnKeyType = UIReturnKeySearch;
        _textField.font = [UIFont systemFontOfSize:DVVSearchViewFontSize];
        [_textField setValue:[UIFont systemFontOfSize:DVVSearchViewFontSize] forKeyPath:@"_placeholderLabel.font"];
        _textField.tintColor = [UIColor colorWithRed:32/255.0 green:97/255.0 blue:175/255.0 alpha:1];
        
        [_textField addTarget:self action:@selector(textChange:) forControlEvents:UIControlEventEditingChanged];
    }
    return _textField;
}

- (UIButton *)cancelButton
{
    if (!_cancelButton)
    {
        _cancelButton = [UIButton new];
        _cancelButton.titleLabel.font = [UIFont systemFontOfSize:DVVSearchViewFontSize];
        [_cancelButton setTitle:@"搜索" forState:UIControlStateNormal];
        [_cancelButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [_cancelButton setTitleColor:[UIColor grayColor] forState:UIControlStateSelected];
        
        _cancelButton.userInteractionEnabled = NO;
        
        [_cancelButton addTarget:self action:@selector(cancelButtonAction:) forControlEvents:UIControlEventTouchDown];
    }
    return _cancelButton;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
