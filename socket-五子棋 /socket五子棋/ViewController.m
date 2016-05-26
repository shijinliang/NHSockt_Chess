//
//  ViewController.m
//  socket五子棋
//
//  Created by 牛辉 on 16/5/23.
//  Copyright © 2016年 Niu. All rights reserved.
//

#import "ViewController.h"
#import "NHsocketManager.h"
#import "NHConnectApi.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UILabel *label;

@property (nonatomic ,strong)NHsocketManager *manager;

@property (weak, nonatomic) IBOutlet UITextField *ipTF;

@property (weak, nonatomic) IBOutlet UIButton *connectBtn;

@property (weak, nonatomic) IBOutlet UITextField *passWord;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.label.text =  [[NHsocketManager defaultManager] getCurrentIP];
}
- (IBAction)connect:(UIButton *)sender {
    
    if (self.ipTF.text.length&&self.passWord.text.length) {
        [NHConnectApi connectApi:self.ipTF.text passWord:self.passWord.text];
    }
}
- (IBAction)fasong:(id)sender {
    
    [[NHsocketManager defaultManager] writeDataProtocolHeader:2 cId:2 message:@"牛辉就是帅"];
}

@end
