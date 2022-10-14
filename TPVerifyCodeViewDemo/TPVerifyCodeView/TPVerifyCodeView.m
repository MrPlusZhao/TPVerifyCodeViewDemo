//
//  TPVerifyCodeView.m
//  VerifyCode
//
//  Created by ztp on 2022/10/13.
//  Copyright © 2022 chen. All rights reserved.
//

#import "TPVerifyCodeView.h"
#import <Masonry/Masonry.h>

NSString * const TP_TextFieldDidDeleteBackwardNotification = @"TP_TextFieldDidDeleteBackwardNotification";

@interface  VerifyCodeTextField : UITextField

@end

@implementation VerifyCodeTextField

- (void)deleteBackward{
    [[NSNotificationCenter defaultCenter] postNotificationName:TP_TextFieldDidDeleteBackwardNotification object:nil];
}

@end

@interface TPVerifyCodeView ()

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) VerifyCodeTextField *textField;
@property (nonatomic, strong) NSMutableArray <UILabel *>*labelArray;
@property (nonatomic, copy)   NSString *codeString;

@end

@implementation TPVerifyCodeView

- (instancetype)init
{
    self = [super init];
    if (self) {
        _codeCount = 4;
        _singleWidth = 60;
        self.labelArray = [NSMutableArray array];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteBackward) name:TP_TextFieldDidDeleteBackwardNotification object:nil];
        [self initUI];
    }
    return self;
}
- (void)setCodeCount:(CGFloat)codeCount{
    _codeCount = codeCount;
    [self reSetUI];
}
- (void)setSingleWidth:(CGFloat)singleWidth{
    _singleWidth = singleWidth;
    [self reSetUI];
}
- (void)reSetUI{
    if (self.labelArray.count > 0){
        for (UILabel *label in self.labelArray) {
            [label removeFromSuperview];
        }
        [self.labelArray removeAllObjects];
    }
    for (int i = 0; i < _codeCount; i ++) {
        UILabel *label = [[UILabel alloc] init];
        label.textColor = UIColor.grayColor;
        label.font = [UIFont boldSystemFontOfSize:12];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"●";
        [_bgView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self);
            make.left.equalTo(self.mas_left).offset(i * _singleWidth);
            make.width.mas_equalTo(@(_singleWidth));
            make.height.equalTo(@(_singleWidth));
            if(i == _codeCount){
                make.right.equalTo(self.mas_right);
            }
        }];
        label.tag = i;
        [self.labelArray addObject:label];
    }
}
- (void)initUI{
    _bgView = [[UIView alloc] init];
    _bgView.backgroundColor = [UIColor clearColor];
    [self addSubview:_bgView];
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    for (int i = 0; i < _codeCount; i ++) {
        UILabel *label = [[UILabel alloc] init];
        label.textColor = UIColor.grayColor;
        label.font = [UIFont boldSystemFontOfSize:12];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"●";
        [_bgView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self);
            make.left.equalTo(self.mas_left).offset(i * _singleWidth);
            make.width.mas_equalTo(@(_singleWidth));
            make.height.equalTo(@(_singleWidth));
            if(i == _codeCount){
                make.right.equalTo(self.mas_right);
            }
        }];
        label.tag = i;
        [self.labelArray addObject:label];
    }

    _textField = [[VerifyCodeTextField alloc] init];
    _textField.borderStyle = UITextBorderStyleNone;
    [self addSubview:_textField];
    
    [_textField becomeFirstResponder];
    _textField.keyboardType = UIKeyboardTypeNumberPad;
    [_textField addTarget:self action:@selector(textDidChanged:) forControlEvents:(UIControlEventEditingChanged)];
}

- (void)textDidChanged:(UITextField *)textField {
    
    if (textField.text.length >= _codeCount) {
        for (int i = 0; i < self.labelArray.count; i ++) {
            UILabel *label = self.labelArray[i];
            label.text = [textField.text substringFromIndex:i + 1];
            label.textColor = UIColor.whiteColor;
            label.font = [UIFont boldSystemFontOfSize:24];
        }
        if (textField.text.length == _codeCount) {
            _codeString = textField.text;
        }else {
            _codeString = [textField.text substringToIndex:4];
        }
        
    }else {
        for (int i = 0; i < self.labelArray.count; i ++) {
            UILabel *label = self.labelArray[i];
            if ([label.text isEqualToString:@"●"]) {
                label.text = textField.text;
                label.textColor = UIColor.grayColor;
                label.font = [UIFont boldSystemFontOfSize:24];
                break;
            }
        }
    }
    if (_codeString.length < _codeCount) {
        if (_codeString == nil) {
            _codeString = textField.text;
        }else {
            _codeString = [_codeString stringByAppendingString:textField.text];
        }
    }
    textField.text = nil;
    if (_codeString.length == _codeCount && _codeString != nil) {
        if (_codeInputCompeletBlock) {
            _codeInputCompeletBlock (_codeString);
        }
    }
}

- (void)deleteBackward {
    
    for (int i = (int)self.labelArray.count - 1; i >= 0; i --) {
        UILabel *label = self.labelArray[i];
        if (![label.text isEqualToString:@"●"]) {
            label.text = @"●";
            label.textColor = UIColor.grayColor;
            label.font = [UIFont boldSystemFontOfSize:12];
            if (_codeString != nil) {
                _codeString = [_codeString substringToIndex:i];
                if (i == 0) {
                    _codeString = nil;
                }
            }
            break;
        }
    }
    NSLog(@"%@",_codeString);
}

- (void)clearCode {
    for (UILabel *label in self.labelArray) {
        label.text = @"●";
        label.textColor = UIColor.grayColor;
        label.font = [UIFont boldSystemFontOfSize:12];
    }
    _codeString = nil;
    _textField.text = nil;
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (![_textField isFirstResponder]){
        [_textField becomeFirstResponder];
    }
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
