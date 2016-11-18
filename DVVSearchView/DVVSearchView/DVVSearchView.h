//
//  DVVSearchView.h
//  DVVSearchView <https://github.com/devdawei/DVVSearchView.git>
//
//  Created by 大威 on 16/6/20.
//  Copyright © 2016年 devdawei. All rights reserved.
//

#import <UIKit/UIKit.h>

extern CGFloat const DVVSearchViewHeight;
extern CGFloat const DVVSearchViewSearchHeight;
extern CGFloat const DVVSearchViewFontSize;

typedef void(^DVVSearchViewTextFieldBlock)(UITextField *textField);

@interface DVVSearchView : UIView <UITextFieldDelegate>

/** 输入框 */
@property (nonatomic, strong) UITextField *textField;
/** 默认高度 */
@property (nonatomic, readonly, assign) CGFloat defaultHeight;


@property (nonatomic, copy) DVVSearchViewTextFieldBlock didBeginEditingBlock;
@property (nonatomic, copy) DVVSearchViewTextFieldBlock didEndEditingBlock;
@property (nonatomic, copy) DVVSearchViewTextFieldBlock textChangeBlock;

/**
 *  textField开始编辑
 *
 *  @param handle DVVSearchViewUITextFieldDelegateBlock
 */
- (void)setDidBeginEditingBlock:(DVVSearchViewTextFieldBlock)didBeginEditingBlock;
/**
 *  textField结束编辑
 *
 *  @param handle DVVSearchViewUITextFieldDelegateBlock
 */
- (void)setDidEndEditingBlock:(DVVSearchViewTextFieldBlock)didEndEditingBlock;
/**
 *  textField文本改变
 *
 *  @param handle DVVSearchViewUITextFieldDelegateBlock
 */
- (void)setTextChangeBlock:(DVVSearchViewTextFieldBlock)textChangeBlock;


/** 提示语 */
@property (nonatomic,copy) NSString *placeholderText;

@end

