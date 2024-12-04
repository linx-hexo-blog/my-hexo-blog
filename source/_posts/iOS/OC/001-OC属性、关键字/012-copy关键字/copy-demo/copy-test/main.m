//
//  main.m
//  copy-test
//
//  Created by 启业云03 on 2024/7/18.
//

#import <Foundation/Foundation.h>
#import "AA.h"
#import "BB.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        NSLog(@"Hello, World!");
        
        AA *a = [[AA alloc] init];
//        [a string_strong];
//        [a string_copy];
        
//        [a mutableString_copy];
        
        
        BB *b = [[BB alloc] init];
        [b test1];
        [b test2];
    }
    return 0;
}
