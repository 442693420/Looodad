//
//  LoginViewController.m
//  ShangXingProject
//
//  Created by 张浩 on 2016/11/10.
//  Copyright © 2016年 张浩. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "NTESLoginManager.h"
#import "NTESService.h"
#import "MapViewController.h"
@interface LoginViewController ()<RegisterViewControllerDelegate,UITextFieldDelegate>
@property (nonatomic , strong)UITextField *usernameTextField;
@property (nonatomic , strong)UITextField *passwordTextField;
@property (nonatomic , strong)UIButton *loginBtn;
@property (nonatomic , strong)UIButton *registerBtn;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.title = @"登录";
    [self creatUI];
}
- (void)dealloc{
    NSLog(@"LoginViewController没有内存泄露");
}
- (void)creatUI{
    [self.view addSubview:self.usernameTextField];
    [self.view addSubview:self.passwordTextField];
    [self.view addSubview:self.loginBtn];
    [self.view addSubview:self.registerBtn];
    
    [self.usernameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(40);
        make.right.equalTo(self.view.mas_right).offset(-40);
        make.top.equalTo(self.view.mas_top).offset(100);
        make.height.equalTo(@44);
    }];
    [self.passwordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.usernameTextField);
        make.height.equalTo(@44);
        make.top.equalTo(self.usernameTextField.mas_bottom).offset(20);
    }];
    [self.loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.height.equalTo(@44);
        make.width.equalTo(@100);
        make.top.equalTo(self.passwordTextField.mas_bottom).offset(40);
    }];
    [self.registerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.height.equalTo(@44);
        make.width.equalTo(@100);
        make.top.equalTo(self.loginBtn.mas_bottom).offset(40);
    }];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
}
- (void)doLogin
{
    [self.usernameTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
    
    NSString *username = [self.usernameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];//去掉两端的空格，
    NSString *password = self.passwordTextField.text;
    [SVProgressHUD show];
    
    NSString *loginAccount = username;
    NSString *loginToken   = [password tokenByPassword];
    
    //NIM SDK 只提供消息通道，并不依赖用户业务逻辑，开发者需要为每个APP用户指定一个NIM帐号，NIM只负责验证NIM的帐号即可(在服务器端集成)
    //用户APP的帐号体系和 NIM SDK 并没有直接关系
    //DEMO中使用 username 作为 NIM 的account ，md5(password) 作为 token
    //开发者需要根据自己的实际情况配置自身用户系统和 NIM 用户系统的关系
    
    [[[NIMSDK sharedSDK] loginManager] login:loginAccount
                                       token:loginToken
                                  completion:^(NSError *error) {
                                      [SVProgressHUD dismiss];
                                      if (error == nil)
                                      {
                                          LoginData *sdkData = [[LoginData alloc] init];
                                          sdkData.account   = loginAccount;
                                          sdkData.token     = loginToken;
                                          [[NTESLoginManager sharedManager] setCurrentLoginData:sdkData];
                                          
                                          [[NTESServiceManager sharedManager] start];
                                          MapViewController * mainVC = [[MapViewController alloc] init];                                          UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:mainVC];
                                          [UIApplication sharedApplication].keyWindow.rootViewController = nav;
                                      }
                                      else
                                      {
                                          NSString *toast = [NSString stringWithFormat:@"登录失败 code: %zd",error.code];
                                          [self.view makeToast:toast duration:2.0 position:CSToastPositionCenter];
                                      }
                                  }];
    
    
}

- (IBAction)loginAction:(id)sender {
    [self doLogin];
}
- (IBAction)registerAction:(id)sender{
    RegisterViewController *registerViewController = [[RegisterViewController alloc]init];
    [self.navigationController pushViewController:registerViewController animated:YES];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([string isEqualToString:@"\n"]) {
        [self doLogin];
        return NO;
    }
    return YES;
}

- (void)textFieldDidChange:(NSNotification*)notification{
    if ([self.usernameTextField.text length] && [self.passwordTextField.text length])
    {
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }else{
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if ([self.usernameTextField.text length] && [self.passwordTextField.text length])
    {
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }else{
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }
}

#pragma mark - RegisterViewControllerDelegate
- (void)registDidComplete:(NSString *)account password:(NSString *)password{
    if (account.length) {
        self.usernameTextField.text = account;
        self.passwordTextField.text = password;
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    [self.usernameTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark getter and setter
-(UITextField *)usernameTextField{
    if (_usernameTextField == nil) {
        _usernameTextField = [[UITextField alloc]init];
        _usernameTextField.placeholder = @"请输入账号";
        _usernameTextField.backgroundColor = [UIColor whiteColor];
        _usernameTextField.tintColor = [UIColor grayColor];
        _usernameTextField.delegate = self;
    }
    return _usernameTextField;
}
-(UITextField *)passwordTextField{
    if (_passwordTextField == nil) {
        _passwordTextField = [[UITextField alloc]init];
        _passwordTextField.placeholder = @"请输入密码";
        _passwordTextField.backgroundColor = [UIColor whiteColor];
        _passwordTextField.tintColor = [UIColor grayColor];
        _passwordTextField.delegate = self;
    }
    return _passwordTextField;
}
-(UIButton *)loginBtn{
    if (_loginBtn == nil) {
        _loginBtn = [[UIButton alloc]init];
        [_loginBtn setTitle:@"登录" forState:UIControlStateNormal];
        _loginBtn.backgroundColor = [UIColor blueColor];
        [_loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_loginBtn addTarget:self action:@selector(loginAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loginBtn;
}
-(UIButton *)registerBtn{
    if (_registerBtn == nil) {
        _registerBtn = [[UIButton alloc]init];
        [_registerBtn setTitle:@"注册" forState:UIControlStateNormal];
        _registerBtn.backgroundColor = [UIColor greenColor];
        [_registerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_registerBtn addTarget:self action:@selector(registerAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _registerBtn;
}

@end
