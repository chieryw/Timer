//
//  ViewController.m
//  TestTimer
//
//  Created by chiery on 14/11/12.
//  Copyright (c) 2014年 None. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

// 这里得创建一个全局的timer,防止内存泄露
@property (nonatomic, strong) dispatch_source_t timer;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)firstWayCreateTimer:(id)sender
{
    // 老的方式创建timer
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1
                                     target:self
                                   selector:@selector(printHello)
                                   userInfo:nil
                                    repeats:YES];
    [[NSRunLoop alloc] addTimer:timer forMode:NSRunLoopCommonModes];
}

- (IBAction)secondWayCreateTimer:(id)sender
{
    NSThread *thread = [[NSThread alloc] initWithTarget:self selector:@selector(createTimer) object:nil];
    [thread start];
}

- (IBAction)thirdWayCreateTimer:(id)sender
{
    // 在主线程上创建一个timer
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
    dispatch_source_set_timer(_timer, DISPATCH_TIME_NOW, 0.1 * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(_timer, ^{
        NSLog(@"hello");
    });
    dispatch_resume(_timer);
}

- (void)printHello
{
    NSLog(@"hello");
}

- (void)createTimer
{
    // 自己创建的线程不在主程序的autoReleasepool,需要创建的这个线程的autoReleasepool
    @autoreleasepool {
        //在当前Run Loop中添加timer，模式是默认的NSDefaultRunLoopMode
        
        [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(timer_callback)userInfo:nil repeats:YES];
        
        //开始执行新线程的Run Loop
        
        [[NSRunLoop currentRunLoop] run];
    }
}

- (void)timer_callback
{
    NSLog(@"timer:%@",[NSThread currentThread]);
}

@end
