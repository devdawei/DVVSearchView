//
//  ViewController.m
//  DVVSearchView
//
//  Created by 大威 on 16/6/20.
//  Copyright © 2016年 devdawei. All rights reserved.
//

#import "ViewController.h"
#import "DVVSearchView.h"

@interface ViewController ()

@property (nonatomic, strong) DVVSearchView *searchView;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _searchView = [DVVSearchView new];
    [_searchView setDidBeginEditingBlock:^(UITextField *textField) {
        NSLog(@"\n");
        NSLog(@"已经开始编辑 text: %@", textField.text);
    }];
    [_searchView setDidEndEditingBlock:^(UITextField *textField) {
        NSLog(@"\n");
        NSLog(@" 已经结束编辑 text: %@", textField.text);
    }];
    [_searchView setTextChangeBlock:^(UITextField *textField) {
        NSLog(@"\n");
        NSLog(@"文本改变 text: %@", textField.text);
    }];
    
    [self.view addSubview:_searchView];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    _searchView.frame = CGRectMake(0, 100, screenWidth, DVVSearchViewHeight);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
