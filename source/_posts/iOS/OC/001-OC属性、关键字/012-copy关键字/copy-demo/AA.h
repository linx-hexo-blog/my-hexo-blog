//
//  AA.h
//  copy-test
//
//  Created by 启业云03 on 2024/7/18.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AA : NSObject

- (void)string_strong;

- (void)string_copy;

- (void)mutableString_copy;

@end

NS_ASSUME_NONNULL_END
