//
//  AA.m
//  copy-test
//
//  Created by 启业云03 on 2024/7/18.
//

#import "AA.h"

@interface AA()

@property (nonatomic, strong) NSString *name;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSMutableString *testStr;

@end

@implementation AA

- (void)string_strong {
    NSMutableString *mStr = [NSMutableString stringWithString:@"张三"];

    self.name = mStr;

    NSLog(@"使用strong第一次得到的名字：%@", self.name);

    [mStr appendString:@"丰"];

    NSLog(@"使用strong第二次得到的名字：%@", self.name);
}

- (void)string_copy {
    
    NSMutableString *mStr = [NSMutableString stringWithString:@"张三"];

    self.title = mStr;

    NSLog(@"使用copy第一次得到的名字：%@", self.title);

    [mStr appendString:@"丰"];

    NSLog(@"使用copy第二次得到的名字：%@", self.title);
}

- (void)mutableString_copy {
    NSMutableString *mStr = [NSMutableString stringWithString:@"张三"];

    self.testStr = mStr;

    NSLog(@"使用copy第一次得到的名字：%@", self.testStr);

    [mStr appendString:@"丰"];

    NSLog(@"使用copy第二次得到的名字：%@", self.testStr);
    
// 崩溃：由于copy复制了一个不可变的NSArray对象，如果对arr进行添加、删除、修改数组内部元素的时候，程序找不到对应的方法而崩溃。
//    [self.testStr appendString:@"123"];
    
//    NSLog(@"使用copy第三次得到的名字：%@", self.testStr);

}

@end
