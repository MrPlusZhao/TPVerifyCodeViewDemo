//
//  TPVerifyCodeView.h
//  VerifyCode
//
//  Created by ztp on 2022/10/13.
//  Copyright © 2022 chen. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TPVerifyCodeView : UIView

/**
 清除输入密码
 */
- (void)clearCode;
/**
 总数量
 */
@property (nonatomic, assign) CGFloat codeCount;//默认 4
/**
  单个框的宽度
 */
@property (nonatomic, assign) CGFloat singleWidth;//默认 60

@property (nonatomic,copy) void (^codeInputCompeletBlock) (NSString *codeString);


@end
