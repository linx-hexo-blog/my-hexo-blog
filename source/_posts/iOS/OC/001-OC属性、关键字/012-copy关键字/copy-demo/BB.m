//
//  BB.m
//  copy-test
//
//  Created by 启业云03 on 2024/7/19.
//

#import "BB.h"

@implementation BB

- (void)test1 {
    // NSString
    NSString *originalString = @"Hello, World!";
    NSString *stringCopy = [originalString copy]; // 返回原对象本身
    NSMutableString *mutableStringCopy = [originalString mutableCopy]; // 返回新的 NSMutableString 对象
    NSLog(@"%@ %@", stringCopy, mutableStringCopy);
    
    // NSMutableString
    NSMutableString *originalMutableString = [NSMutableString stringWithString:@"Hello, World!"];
    NSString *stringCopy1 = [originalMutableString copy]; // 返回新的 NSString 对象
    NSMutableString *mutableStringCopy1 = [originalMutableString mutableCopy]; // 返回新的 NSMutableString 对象
    NSLog(@"%@ %@", stringCopy1, mutableStringCopy1);
}


- (void)test2 {
    // NSArray
    NSArray *originalArray = @[@"One", @"Two", @"Three"];
    NSArray *arrayCopy = [originalArray copy]; // 返回原对象本身
    NSMutableArray *mutableArrayCopy = [originalArray mutableCopy]; // 返回新的 NSMutableArray 对象
    
    // NSMutableArray
    NSMutableArray *originalMutableArray = [NSMutableArray arrayWithArray:@[@"One", @"Two", @"Three"]];
    NSArray *arrayCopy = [originalMutableArray copy]; // 返回新的 NSArray 对象
    NSMutableArray *mutableArrayCopy = [originalMutableArray mutableCopy]; // 返回新的 NSMutableArray 对象
    
    NSLog(@"%@ %@", arrayCopy, mutableArrayCopy);
}
@end
