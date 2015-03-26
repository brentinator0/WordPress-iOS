#import <Specta/Specta.h>
#define EXP_SHORTHAND
#import <Expecta/Expecta.h>
#import <OCMock/OCMock.h>
#import "LoginViewModel.h"
#import "ReachabilityService.h"
#import "LoginService.h"
#import "WordPressComOAuthClientService.h"
#import "AccountCreationService.h"
#import "BlogSyncService.h"

SpecBegin(LoginViewModel)

__block LoginViewModel *viewModel;
__block id mockViewModelDelegate;
__block id mockReachabilityService;
__block id mockLoginService;
__block id mockLoginServiceDelegate;
__block id mockOAuthService;
__block id mockAccountCreationService;
__block id mockBlogSyncService;

beforeEach(^{
    mockViewModelDelegate = [OCMockObject niceMockForProtocol:@protocol(LoginViewModelDelegate)];
    mockReachabilityService = [OCMockObject niceMockForProtocol:@protocol(ReachabilityService)];
    mockLoginService = [OCMockObject niceMockForProtocol:@protocol(LoginService)];
    mockLoginServiceDelegate = [OCMockObject niceMockForProtocol:@protocol(LoginServiceDelegate)];
    mockOAuthService = [OCMockObject niceMockForProtocol:@protocol(WordPressComOAuthClientService)];
    mockAccountCreationService = [OCMockObject niceMockForProtocol:@protocol(AccountCreationService)];
    mockBlogSyncService = [OCMockObject niceMockForProtocol:@protocol(BlogSyncService)];
    [OCMStub([mockLoginService wordpressComOAuthClientService]) andReturn:mockOAuthService];
    [OCMStub([mockLoginService delegate]) andReturn:mockLoginServiceDelegate];
    
    viewModel = [LoginViewModel new];
    viewModel.loginService = mockLoginService;
    viewModel.reachabilityService = mockReachabilityService;
    viewModel.delegate = mockViewModelDelegate;
    viewModel.accountCreationService = mockAccountCreationService;
    viewModel.blogSyncService = mockBlogSyncService;
});

describe(@"authenticating", ^{
    
    it(@"should call the delegate's showActivityIndicator method when the value changes", ^{
        [[mockViewModelDelegate expect] showActivityIndicator:YES];
        viewModel.authenticating = YES;
        [mockViewModelDelegate verify];
        
        [[mockViewModelDelegate expect] showActivityIndicator:NO];
        viewModel.authenticating = NO;
        [mockViewModelDelegate verify];
    });
    
});

describe(@"shouldDisplayMultifactor", ^{
    
    context(@"when it's true", ^{
        
        it(@"should set the username's alpha to 0.5", ^{
            [[mockViewModelDelegate expect] setUsernameAlpha:0.5];
            viewModel.shouldDisplayMultifactor = YES;
            [mockViewModelDelegate verify];
        });
        
        it(@"should set the password's alpha to 0.5", ^{
            [[mockViewModelDelegate expect] setPasswordAlpha:0.5];
            viewModel.shouldDisplayMultifactor = YES;
            [mockViewModelDelegate verify];
        });
        
        it(@"should set multifactor's alpha to 1.0", ^{
            [[mockViewModelDelegate expect] setMultiFactorAlpha:1.0];
            viewModel.shouldDisplayMultifactor = YES;
            [mockViewModelDelegate verify];
        });
    });
    
    context(@"when it's false", ^{
        
        it(@"it should set the username's alpha to 1.0", ^{
            [[mockViewModelDelegate expect] setUsernameAlpha:1.0];
            viewModel.shouldDisplayMultifactor = NO;
            [mockViewModelDelegate verify];
        });
        
        it(@"should set the password's alpha to 1.0", ^{
            [[mockViewModelDelegate expect] setPasswordAlpha:1.0];
            viewModel.shouldDisplayMultifactor = NO;
            [mockViewModelDelegate verify];
        });
        
        it(@"should set multifactor's alpha to 0.0", ^{
            [[mockViewModelDelegate expect] setMultiFactorAlpha:0.0];
            viewModel.shouldDisplayMultifactor = NO;
            [mockViewModelDelegate verify];
        });
    });
});

describe(@"isUsernameEnabled", ^{
    
    context(@"when it's true", ^{
        it(@"should enable the username text field", ^{
            [[mockViewModelDelegate expect] setUsernameEnabled:YES];
            viewModel.isUsernameEnabled = YES;
            [mockViewModelDelegate verify];
        });
    });
    
    context(@"when it's false", ^{
        it(@"should disable the username text field" , ^{
            [[mockViewModelDelegate expect] setUsernameEnabled:NO];
            viewModel.isUsernameEnabled = NO;
            [mockViewModelDelegate verify];
        });
    });
    
    context(@"dependency on shouldDisplayMultifactor", ^{
        
        it(@"should result in the value being true when shouldDisplayMultifactor is false", ^{
            viewModel.shouldDisplayMultifactor = NO;
            expect(viewModel.isUsernameEnabled).to.beTruthy();
        });
        
        it(@"should result in the value being false when shouldDisplayMultifactor is true", ^{
            viewModel.shouldDisplayMultifactor = YES;
            expect(viewModel.isUsernameEnabled).to.beFalsy();
        });
    });
});

describe(@"isPasswordEnabled", ^{
    
    context(@"when it's true", ^{
        
        it(@"should enable the password text field", ^{
            [[mockViewModelDelegate expect] setPasswordEnabled:YES];
            viewModel.isPasswordEnabled = YES;
            [mockViewModelDelegate verify];
        });
    });
    
    context(@"when it's false", ^{
        
        it(@"should disable the password text field" , ^{
            [[mockViewModelDelegate expect] setPasswordEnabled:NO];
            viewModel.isPasswordEnabled = NO;
            [mockViewModelDelegate verify];
        });
    });
    
    context(@"dependency on shouldDisplayMultifactor", ^{
        
        it(@"should result in the value being true when shouldDisplayMultifactor is false", ^{
            viewModel.shouldDisplayMultifactor = NO;
            expect(viewModel.isPasswordEnabled).to.beTruthy();
        });
        
        it(@"should result in the value being false when shouldDisplayMultifactor is true", ^{
            viewModel.shouldDisplayMultifactor = YES;
            expect(viewModel.isPasswordEnabled).to.beFalsy();
        });
    });
});

describe(@"isSiteUrlEnabled", ^{
    
    it(@"when it's true it should enable the site url field", ^{
        [[mockViewModelDelegate expect] setSiteUrlEnabled:YES];
        viewModel.isSiteUrlEnabled = YES;
        [mockViewModelDelegate verify];
    });
    
    it(@"when it's false it should disable the site url field", ^{
        [[mockViewModelDelegate expect] setSiteUrlEnabled:NO];
        viewModel.isSiteUrlEnabled = NO;
        [mockViewModelDelegate verify];
    });
    
    context(@"depdendency on isUserDotCom", ^{
        
        it(@"should result in the value being false when isUserDotCom is true", ^{
            viewModel.userIsDotCom = YES;
            expect(viewModel.isSiteUrlEnabled).to.beFalsy();
        });
        
        it(@"should result in the value being true when isUserDotCom is false", ^{
            viewModel.userIsDotCom = NO;
            expect(viewModel.isSiteUrlEnabled).to.beTruthy();
        });
    });
});

describe(@"isMultifactorEnabled", ^{
    
    it(@"when it's true it should enable the multifactor text field", ^{
        [[mockViewModelDelegate expect] setMultifactorEnabled:YES];
        viewModel.isMultifactorEnabled = YES;
        [mockViewModelDelegate verify];
    });
    
    it(@"when it's false it should disable the multifactor text field", ^{
        [[mockViewModelDelegate expect] setMultifactorEnabled:NO];
        viewModel.isMultifactorEnabled = NO;
        [mockViewModelDelegate verify];
    });
    
    context(@"dependency on shouldDisplayMultifactor", ^{
        
        it(@"should result in the value being true when shouldDisplayMultifactor is true", ^{
            viewModel.shouldDisplayMultifactor = YES;
            expect(viewModel.isMultifactorEnabled).to.beTruthy();
        });
        
        it(@"should result in the value being false when shouldDisplayMultifactor is false", ^{
            viewModel.shouldDisplayMultifactor = NO;
            expect(viewModel.isMultifactorEnabled).to.beFalsy();
        });
    });
});

describe(@"cancellable", ^{
    
    it(@"when it's true it should display the cancel button", ^{
        [[mockViewModelDelegate expect] setCancelButtonHidden:NO];
        viewModel.cancellable = YES;
        [mockViewModelDelegate verify];
    });
    
    it(@"when it's false it should hide the cancel button", ^{
        [[mockViewModelDelegate expect] setCancelButtonHidden:YES];
        viewModel.cancellable = NO;
        [mockViewModelDelegate verify];
    });
});

describe(@"forgot password button's visibility", ^{
    
    context(@"for a .com user", ^{
        
        beforeEach(^{
            viewModel.userIsDotCom = YES;
        });
        
        context(@"who is authenticating", ^{
        
            it(@"should not be visible", ^{
                [[mockViewModelDelegate expect] setForgotPasswordHidden:YES];
                viewModel.authenticating = YES;
                [mockViewModelDelegate verify];
            });
        });
        
        context(@"who isn't authenticating", ^{
            
            it(@"should be visible", ^{
                [[mockViewModelDelegate expect] setForgotPasswordHidden:NO];
                viewModel.authenticating = NO;
                [mockViewModelDelegate verify];
            });
            
            it(@"should not be visibile if multifactor auth controls are visible", ^{
                [[mockViewModelDelegate expect] setForgotPasswordHidden:YES];
                viewModel.isMultifactorEnabled = YES;
                viewModel.authenticating = NO;
                [mockViewModelDelegate verify];
            });
        });
    });
    
    context(@"for a self hosted user", ^{
        
        context(@"who isn't authenticating", ^{
            
            beforeEach(^{
                viewModel.authenticating = NO;
            });
            
            it(@"should not be visible if a url is not present", ^{
                [[mockViewModelDelegate expect] setForgotPasswordHidden:YES];
                viewModel.siteUrl = @"";
                [mockViewModelDelegate verify];
            });
            
            
            it(@"should be visible if a url is present", ^{
                [[mockViewModelDelegate expect] setForgotPasswordHidden:NO];
                viewModel.siteUrl = @"http://www.selfhosted.com";
                [mockViewModelDelegate verify];
            });
            
            it(@"should not be visible if multifactor controls are visible", ^{
                [[mockViewModelDelegate expect] setForgotPasswordHidden:YES];
                viewModel.isMultifactorEnabled = YES;
                [mockViewModelDelegate verify];
            });
        });
        
        context(@"who is authenticating", ^{
            
            beforeEach(^{
                viewModel.authenticating = YES;
            });
            
            it(@"should not be visible if a url is present", ^{
                [[mockViewModelDelegate expect] setForgotPasswordHidden:YES];
                viewModel.siteUrl = @"http://www.selfhosted.com";
                [mockViewModelDelegate verify];
            });
        });
    });
});

describe(@"skipToCreateAccountButton visibility", ^{
    
    context(@"when authenticating", ^{
        
        it(@"should not be visible if the user has an account", ^{
            [[mockViewModelDelegate expect] setAccountCreationButtonHidden:YES];
            viewModel.authenticating = YES;
            viewModel.hasDefaultAccount = YES;
            [mockViewModelDelegate verify];
        });
        
        it(@"should not be visible if the user doesn't have an account", ^{
            [[mockViewModelDelegate expect] setAccountCreationButtonHidden:YES];
            viewModel.authenticating = YES;
            viewModel.hasDefaultAccount = NO;
            [mockViewModelDelegate verify];
        });
    });
    
    context(@"when not authenticating", ^{
        
        it(@"should not be visible if the user has an account", ^{
            [[mockViewModelDelegate expect] setAccountCreationButtonHidden:YES];
            viewModel.authenticating = NO;
            viewModel.hasDefaultAccount = YES;
            [mockViewModelDelegate verify];
        });
        
        it(@"should be visible if the user doesn't have an account", ^{
            [[mockViewModelDelegate expect] setAccountCreationButtonHidden:NO];
            viewModel.authenticating = NO;
            viewModel.hasDefaultAccount = NO;
            [mockViewModelDelegate verify];
        });
    });
});

describe(@"signInButtonTitle", ^{
    
    context(@"when multifactor controls are visible", ^{
        
        beforeEach(^{
            viewModel.shouldDisplayMultifactor = YES;
        });
        
        it(@"should be 'Verify'", ^{
            expect(viewModel.signInButtonTitle).to.equal(@"Verify");
        });
        
        it(@"should set the sign in button title to 'Verify'", ^{
            [[mockViewModelDelegate expect] setSignInButtonTitle:@"Verify"];
            
            viewModel.shouldDisplayMultifactor = YES;
            
            [mockViewModelDelegate verify];
        });
        
        it(@"should be 'Verify' even if user is a .com user", ^{
            viewModel.userIsDotCom = YES;
            expect(viewModel.signInButtonTitle).to.equal(@"Verify");
        });
        
        it(@"should set the sign in button title to 'Verify' even if the user is a .com user", ^{
            [[mockViewModelDelegate expect] setSignInButtonTitle:@"Verify"];
            
            viewModel.shouldDisplayMultifactor = YES;
            viewModel.userIsDotCom = YES;
            
            [mockViewModelDelegate verify];
        });
    });
    
    context(@"when multifactor controls aren't visible", ^{
        beforeEach(^{
            viewModel.shouldDisplayMultifactor = NO;
        });
        
        it(@"should be 'Sign In' if user is a .com user", ^{
            viewModel.userIsDotCom = YES;
            expect(viewModel.signInButtonTitle).to.equal(@"Sign In");
        });
        
        it(@"should set the sign in button title to 'Sign In' if user is a .com user", ^{
            [[mockViewModelDelegate expect] setSignInButtonTitle:@"Sign In"];
            
            viewModel.userIsDotCom = YES;
            
            [mockViewModelDelegate verify];
        });
        
        it(@"should be 'Add Site' if user isn't a .com user", ^{
            viewModel.userIsDotCom = NO;
            expect(viewModel.signInButtonTitle).to.equal(@"Add Site");
        });
        
        it(@"should set the sign in button title to 'Add Site' if user isn't a .com user", ^{
            [[mockViewModelDelegate expect] setSignInButtonTitle:@"Add Site"];
            
            viewModel.userIsDotCom = NO;
            
            [mockViewModelDelegate verify];
        });
    });
});

describe(@"signInButton", ^{
    
    context(@"for a .com user", ^{
        
        before(^{
            viewModel.userIsDotCom = YES;
        });
        
        
        context(@"when multifactor authentication controls are not visible", ^{
            before(^{
                viewModel.shouldDisplayMultifactor = NO;
            });
            
            it(@"should be disabled if username and password are blank", ^{
                [[mockViewModelDelegate expect] setSignInButtonEnabled:NO];
                
                viewModel.username = @"";
                viewModel.password = @"";
                
                [mockViewModelDelegate verify];
            });
            
            it(@"should be disabled if password is blank", ^{
                [[mockViewModelDelegate expect] setSignInButtonEnabled:NO];
                
                viewModel.username = @"username";
                viewModel.password = @"";
                
                [mockViewModelDelegate verify];
            });
            
            it(@"should be enabled if username and password are filled", ^{
                [[mockViewModelDelegate expect] setSignInButtonEnabled:YES];
                
                viewModel.username = @"username";
                viewModel.password = @"password";
                
                [mockViewModelDelegate verify];
            });
        });
        
        context(@"when multifactor authentication controls are visible", ^{
            before(^{
                viewModel.shouldDisplayMultifactor = YES;
                viewModel.username = @"username";
                viewModel.password = @"password";
            });
            
            it(@"should not be enabled if the multifactor code isn't entered", ^{
                [[mockViewModelDelegate expect] setSignInButtonEnabled:NO];
                
                viewModel.multifactorCode = @"";
                
                [mockViewModelDelegate verify];
            });
            
            it(@"should be enabled if the multifactor code is entered", ^{
                [[mockViewModelDelegate expect] setSignInButtonEnabled:YES];
                
                viewModel.multifactorCode = @"123456";
                
                [mockViewModelDelegate verify];
            });
        });
    });
    
    context(@"for a self hosted user", ^{
        
        before(^{
            viewModel.userIsDotCom = NO;
        });
        
        context(@"when multifactor authentication controls are not visible", ^{
            
            before(^{
                viewModel.shouldDisplayMultifactor = NO;
            });
            
            it(@"should be disabled if username, password and siteUrl are blank", ^{
                [[mockViewModelDelegate expect] setSignInButtonEnabled:NO];
                
                viewModel.username = @"";
                viewModel.password = @"";
                viewModel.siteUrl = @"";
                
                [mockViewModelDelegate verify];
            });
            
            it(@"should be disabled if password and siteUrl are blank", ^{
                [[mockViewModelDelegate expect] setSignInButtonEnabled:NO];
                
                viewModel.username = @"username";
                viewModel.password = @"";
                viewModel.siteUrl = @"";
                
                [mockViewModelDelegate verify];
            });
            
            it(@"should be disabled if siteUrl is blank", ^{
                [[mockViewModelDelegate expect] setSignInButtonEnabled:NO];
                
                viewModel.username = @"username";
                viewModel.password = @"password";
                viewModel.siteUrl = @"";
                
                [mockViewModelDelegate verify];
            });
            
            it(@"should be enabled if username, password and siteUrl are filled", ^{
                [[mockViewModelDelegate expect] setSignInButtonEnabled:YES];
                
                viewModel.username = @"username";
                viewModel.password = @"password";
                viewModel.siteUrl = @"http://www.selfhosted.com";
                
                [mockViewModelDelegate verify];
            });
        });
        
        context(@"when multifactor authentication controls are visible", ^{
            before(^{
                viewModel.shouldDisplayMultifactor = YES;
                viewModel.username = @"username";
                viewModel.password = @"password";
                viewModel.siteUrl = @"http://www.selfhosted.com";
            });
            
            it(@"should not be enabled if the multifactor code isn't entered", ^{
                [[mockViewModelDelegate expect] setSignInButtonEnabled:NO];
                
                viewModel.multifactorCode = @"";
                
                [mockViewModelDelegate verify];
            });
            
            it(@"should be enabled if the multifactor code is entered", ^{
                [[mockViewModelDelegate expect] setSignInButtonEnabled:YES];
                
                viewModel.multifactorCode = @"123456";
                
                [mockViewModelDelegate verify];
            });
        });
    });
});

describe(@"toggleSignInButtonTitle", ^{
    
    it(@"should set the title to 'Add Self-Hosted Site' for a .com user", ^{
        [[mockViewModelDelegate expect] setToggleSignInButtonTitle:@"Add Self-Hosted Site"];
        
        viewModel.userIsDotCom = YES;
       
        [mockViewModelDelegate verify];
    });
    
    it(@"should set the title to 'Sign in to WordPress.com' for a self hosted user", ^{
        [[mockViewModelDelegate expect] setToggleSignInButtonTitle:@"Sign in to WordPress.com"];
        
        viewModel.userIsDotCom = NO;
       
        [mockViewModelDelegate verify];
    });
});

describe(@"toggleSignInButton visibility", ^{
    
    it(@"should be hidden if onlyDotComAllowed is true", ^{
        [[mockViewModelDelegate expect] setToggleSignInButtonHidden:YES];
        
        viewModel.onlyDotComAllowed = YES;
        
        [mockViewModelDelegate verify];
    });
    
    it(@"should be hidden if hasDefaultAccount is true", ^{
        [[mockViewModelDelegate expect] setToggleSignInButtonHidden:YES];
        
        viewModel.hasDefaultAccount = YES;
        
        [mockViewModelDelegate verify];
    });
    
    it(@"should be hidden during authentication", ^{
        [[mockViewModelDelegate expect] setToggleSignInButtonHidden:YES];
        
        viewModel.authenticating = YES;;
        
        [mockViewModelDelegate verify];
    });
    
    it(@"should be visible if onlyDotComAllowed, hasDefaultAccount, and authenticating are all false", ^{
        [[mockViewModelDelegate expect] setToggleSignInButtonHidden:NO];
        
        viewModel.onlyDotComAllowed = NO;
        viewModel.hasDefaultAccount = NO;
        viewModel.authenticating = NO;
        
        [mockViewModelDelegate verify];
    });
});

describe(@"signInButtonAction", ^{
    
    context(@"the checking of the user's internet connection", ^{
        
        it(@"should not show an error message about the internet connection if it's down", ^{
            [OCMStub([mockReachabilityService isInternetReachable]) andReturnValue:@(YES)];
            [[mockReachabilityService reject] showAlertNoInternetConnection];
            
            [viewModel signInButtonAction];
            
            [mockReachabilityService verify];
        });
        
        it(@"should show an error message about the internet connection if it's down", ^{
            [OCMStub([mockReachabilityService isInternetReachable]) andReturnValue:@(NO)];
            [[mockReachabilityService expect] showAlertNoInternetConnection];
            
            [viewModel signInButtonAction];
            
            [mockReachabilityService verify];
        });
    });
    
    context(@"user field validation", ^{
        
        beforeEach(^{
            [OCMStub([mockReachabilityService isInternetReachable]) andReturnValue:@(YES)];
            
            viewModel.username = @"username";
            viewModel.password = @"password";
            viewModel.siteUrl = @"http://www.selfhosted.com";
        });
        
        sharedExamplesFor(@"username and password validation", ^(NSDictionary *data) {
            
            it(@"should display an error message if the username and password are blank", ^{
                viewModel.username = @"";
                viewModel.password = @"";
                [[mockViewModelDelegate expect] displayErrorMessageForInvalidOrMissingFields];
                
                [viewModel signInButtonAction];
                
                [mockViewModelDelegate verify];
            });
            
            it(@"should display an error message if the username is blank", ^{
                viewModel.username = @"";
                [[mockViewModelDelegate expect] displayErrorMessageForInvalidOrMissingFields];
                
                [viewModel signInButtonAction];
                
                [mockViewModelDelegate verify];
            });
            
            it(@"should display an error message if the password is blank", ^{
                viewModel.password = @"";
                [[mockViewModelDelegate expect] displayErrorMessageForInvalidOrMissingFields];
                
                [viewModel signInButtonAction];
                
                [mockViewModelDelegate verify];
            });
            
            it(@"should not display an error message if the fields are filled", ^{
                [[mockViewModelDelegate reject] displayErrorMessageForInvalidOrMissingFields];
                
                [viewModel signInButtonAction];
                
                [mockViewModelDelegate verify];
            });
        });
        
        context(@"for a .com user", ^{
            
            beforeEach(^{
                viewModel.userIsDotCom = YES;
            });
            
            itShouldBehaveLike(@"username and password validation", @{});
        });
        
        context(@"for a self hosted user", ^{
            beforeEach(^{
                viewModel.userIsDotCom = NO;
            });
            
            itShouldBehaveLike(@"username and password validation", @{});
            
            it(@"should display an error if the username, password and siteUrl are blank", ^{
                viewModel.username = @"";
                viewModel.password = @"";
                viewModel.siteUrl = @"";
                [[mockViewModelDelegate expect] displayErrorMessageForInvalidOrMissingFields];
                
                [viewModel signInButtonAction];
                
                [mockViewModelDelegate verify];
            });
            
            it(@"should not display an error if the fields are filled", ^{
                [[mockViewModelDelegate reject] displayErrorMessageForInvalidOrMissingFields];
                
                [viewModel signInButtonAction];
                
                [mockViewModelDelegate verify];
            });
        });
    });
    
    context(@"verification of non reserved username", ^{
        
        beforeEach(^{
            [OCMStub([mockReachabilityService isInternetReachable]) andReturnValue:@(YES)];
            
            viewModel.username = @"username";
            viewModel.password = @"password";
            viewModel.siteUrl = @"http://www.selfhosted.com";
        });
       
        NSArray *reservedNames = @[@"admin", @"administrator", @"root"];
        for (NSString *reservedName in reservedNames) {
            context(@"for a .com user", ^{
                
                beforeEach(^{
                    viewModel.userIsDotCom = YES;
                    viewModel.username = reservedName;
                });
                
                NSString *testName = [NSString stringWithFormat:@"should display the error message if the username is '%@'", reservedName];
                it(testName, ^{
                    [[mockViewModelDelegate expect] displayReservedNameErrorMessage];
                    
                    [viewModel signInButtonAction];
                    
                    [mockViewModelDelegate verify];
                });
                
                testName = [NSString stringWithFormat:@"should bring focus to siteUrlText if the username is '%@'", reservedName];
                it(testName, ^{
                    [[mockViewModelDelegate expect] setFocusToSiteUrlText];
                    
                    [viewModel signInButtonAction];
                    
                    [mockViewModelDelegate verify];
                });
                
                testName = [NSString stringWithFormat:@"should adjust passwordText's return key type to UIReturnKeyNext"];
                it(testName, ^{
                    [mockViewModelDelegate setPasswordTextReturnKeyType:UIReturnKeyNext];
                    
                    [viewModel signInButtonAction];
                    
                    [mockViewModelDelegate verify];
                });
                
                testName = [NSString stringWithFormat:@"should reload the interface"];
                it(testName, ^{
                    [[mockViewModelDelegate expect] reloadInterfaceWithAnimation:YES];
                    
                    [viewModel signInButtonAction];
                    
                    [mockViewModelDelegate verify];
                });
                
            });
            
            context(@"for a self hosted user", ^{
                
                beforeEach(^{
                    viewModel.userIsDotCom = NO;
                    viewModel.username = reservedName;
                });
                
                NSString *testName = [NSString stringWithFormat:@"should not display the error message if the username is '%@'", reservedName];
                it(testName, ^{
                    viewModel.username = reservedName;
                    [[mockViewModelDelegate reject] displayReservedNameErrorMessage];
                    
                    [viewModel signInButtonAction];
                    
                    [mockViewModelDelegate verify];
                });
            });
        }
    });
    
    context(@"when all fields are valid", ^{
        beforeEach(^{
            [OCMStub([mockReachabilityService isInternetReachable]) andReturnValue:@(YES)];
            
            viewModel.username = @"username";
            viewModel.password = @"password";
            viewModel.siteUrl = @"http://www.selfhosted.com";
        });
        
        context(@"for a .com user", ^{
            
            beforeEach(^{
                viewModel.userIsDotCom = YES;
            });
            
            it(@"should login", ^{
                [[mockLoginService expect] signInWithLoginFields:OCMOCK_ANY];
                
                [viewModel signInButtonAction];
                
                [mockLoginService verify];
            });
        });
        
        context(@"for a self hosted user", ^{
            beforeEach(^{
                viewModel.userIsDotCom = NO;
            });
            
            it(@"should login", ^{
                [[mockLoginService expect] signInWithLoginFields:OCMOCK_ANY];
                
                [viewModel signInButtonAction];
                
                [mockLoginService verify];
            });
        });
    });
});

describe(@"LoginServiceDelegate methods", ^{
    
    context(@"displayLoginMessage", ^{
        
        it(@"should be passed on to the LoginViewModelDelegate", ^{
            [[mockViewModelDelegate expect] displayLoginMessage:@"Test"];
            
            [viewModel displayLoginMessage:@"Test"];
            
            [mockViewModelDelegate verify];
        });
    });
    
    context(@"needsMultifactorCode", ^{
        
        it(@"should result in the multifactor field being displayed", ^{
            OCMExpect([viewModel displayMultifactorTextField]);
            
            [viewModel needsMultifactorCode];
            
            OCMVerify([viewModel displayMultifactorTextField]);
        });
        
        it(@"should dismiss the login message", ^{
            [[mockViewModelDelegate expect] dismissLoginMessage];
            
            [viewModel needsMultifactorCode];
            
            [mockViewModelDelegate verify];
        });
    });
    
    context(@"displayRemoteError:", ^{
        
        it(@"should be passed on to the LoginViewModelDelegate", ^{
            [[mockViewModelDelegate expect] displayRemoteError:OCMOCK_ANY];
            
            [viewModel displayRemoteError:nil];
            
            [mockViewModelDelegate verify];
        });
        
        it(@"should dismiss the login message", ^{
            [[mockViewModelDelegate expect] dismissLoginMessage];
            
            [viewModel displayRemoteError:nil];
            
            [mockViewModelDelegate verify];
        });
    });
    
    context(@"showJetpackAuthentication", ^{
        
        it(@"should be passed on to the LoginViewModelDelegate", ^{
            [[mockViewModelDelegate expect] showJetpackAuthentication];
            
            [viewModel showJetpackAuthentication];
            
            [mockViewModelDelegate verify];
        });
    });
    
    context(@"finishedLoginWithUsername:authToken:shouldDisplayMultifactor:", ^{
        
        __block NSString *username;
        __block NSString *authToken;
        __block BOOL shouldDisplayMultifactor;
        
        beforeEach(^{
            username = @"username";
            authToken = @"authtoken";
            shouldDisplayMultifactor = NO;
        });
        
        it(@"should dismiss the login message", ^{
            [[mockViewModelDelegate expect] dismissLoginMessage];
            
            [viewModel finishedLoginWithUsername:username authToken:authToken shouldDisplayMultifactor:shouldDisplayMultifactor];
            
            [mockViewModelDelegate verify];
        });
        
        it(@"should display a message about getting account information", ^{
            [[mockViewModelDelegate expect] displayLoginMessage:NSLocalizedString(@"Getting account information", nil)];
            
            [viewModel finishedLoginWithUsername:username authToken:authToken shouldDisplayMultifactor:shouldDisplayMultifactor];
            
            [mockViewModelDelegate verify];
        });
        
        it(@"should create a WPAccount for a .com site", ^{
            [[mockAccountCreationService expect] createOrUpdateWordPressComAccountWithUsername:username authToken:authToken];
            
            [viewModel finishedLoginWithUsername:username authToken:authToken shouldDisplayMultifactor:shouldDisplayMultifactor];
            
            [mockViewModelDelegate verify];
        });
        
        context(@"the syncing of the newly added blogs", ^{
            
            it(@"should occur", ^{
                [[mockBlogSyncService expect] syncBlogsForAccount:OCMOCK_ANY success:OCMOCK_ANY failure:OCMOCK_ANY];
                
                [viewModel finishedLoginWithUsername:username authToken:authToken shouldDisplayMultifactor:shouldDisplayMultifactor];
                
                [mockViewModelDelegate verify];
            });
            
            context(@"when successful", ^{
                
                beforeEach(^{
                    // Retrieve success block and execute it when appropriate
                    [OCMStub([mockBlogSyncService syncBlogsForAccount:OCMOCK_ANY success:OCMOCK_ANY failure:OCMOCK_ANY]) andDo:^(NSInvocation *invocation) {
                        void (^ __unsafe_unretained successStub)(void);
                        [invocation getArgument:&successStub atIndex:3];
                        
                        successStub();
                    }];
                });
                
                it(@"should dismiss the login message", ^{
                    [[mockViewModelDelegate expect] dismissLoginMessage];
                    
                    [viewModel finishedLoginWithUsername:username authToken:authToken shouldDisplayMultifactor:shouldDisplayMultifactor];
                    
                    [mockViewModelDelegate verify];
                });
                
                it(@"should indicate dismiss the login view", ^{
                    [[mockViewModelDelegate expect] dismissLoginView];
                    
                    [viewModel finishedLoginWithUsername:username authToken:authToken shouldDisplayMultifactor:shouldDisplayMultifactor];
                    
                    [mockViewModelDelegate verify];
                });
                
                it(@"should update the email and default blog for the newly created account", ^{
                    [[mockAccountCreationService expect] updateEmailAndDefaultBlogForWordPressComAccount:OCMOCK_ANY];
                    
                    [viewModel finishedLoginWithUsername:username authToken:authToken shouldDisplayMultifactor:shouldDisplayMultifactor];
                    
                    [mockAccountCreationService verify];
                });
            });
            
            context(@"when not successful", ^{
                
                __block NSError *error;
                
                beforeEach(^{
                    // Retrieve failure block and execute it when appropriate
                    [OCMStub([mockBlogSyncService syncBlogsForAccount:OCMOCK_ANY success:OCMOCK_ANY failure:OCMOCK_ANY]) andDo:^(NSInvocation *invocation) {
                        void (^ __unsafe_unretained failureStub)(NSError *);
                        [invocation getArgument:&failureStub atIndex:4];
                        
                        error = [NSError errorWithDomain:@"org.wordpress" code:-1 userInfo:@{ NSLocalizedDescriptionKey : @"You have failed me yet again starscream" }];
                        failureStub(error);
                    }];
                });
                
                it(@"should dismiss the login message", ^{
                    [[mockViewModelDelegate expect] dismissLoginMessage];
                    
                    [viewModel finishedLoginWithUsername:username authToken:authToken shouldDisplayMultifactor:shouldDisplayMultifactor];
                    
                    [mockViewModelDelegate verify];
                });
                
                it(@"should display the error", ^{
                    [[mockViewModelDelegate expect] displayRemoteError:error];
                    
                    [viewModel finishedLoginWithUsername:username authToken:authToken shouldDisplayMultifactor:shouldDisplayMultifactor];
                    
                    [mockViewModelDelegate verify];
                });
            });
        });
    });

    context(@"finishedLoginWithUsername:password:xmlrpc:options:", ^{
        
        __block NSString *username;
        __block NSString *password;
        __block NSString *xmlrpc;
        __block NSDictionary *options;
        
        beforeEach(^{
            username = @"username";
            password = @"password";
            xmlrpc = @"www.wordpress.com/xmlrpc.php";
            options = @{};
        });
        
        it(@"should dismiss the login message", ^{
            [[mockViewModelDelegate expect] dismissLoginMessage];
            
            [viewModel finishedLoginWithUsername:username password:password xmlrpc:xmlrpc options:options];
            
            [mockViewModelDelegate verify];
        });
        
        it(@"should create a WPAccount for a self hosted site", ^{
            [[mockAccountCreationService expect] createOrUpdateSelfHostedAccountWithXmlrpc:xmlrpc username:username andPassword:password];
            
            [viewModel finishedLoginWithUsername:username password:password xmlrpc:xmlrpc options:options];
            
            [mockAccountCreationService verify];
        });
        
        it(@"should sync the newly added site", ^{
            [[mockBlogSyncService expect] syncBlogForAccount:OCMOCK_ANY username:username password:password xmlrpc:xmlrpc options:options needsJetpack:OCMOCK_ANY finishedSync:OCMOCK_ANY];
            
            [viewModel finishedLoginWithUsername:username password:password xmlrpc:xmlrpc options:options];
            
            [mockBlogSyncService verify];
        });
        
        it(@"should show jetpack authentication when the blog syncing service tells it to", ^{
            [[mockViewModelDelegate expect] showJetpackAuthentication];
            
            // Retrieve jetpack block and execute it when appropriate
            [OCMStub([mockBlogSyncService syncBlogForAccount:OCMOCK_ANY username:username password:password xmlrpc:xmlrpc options:options needsJetpack:OCMOCK_ANY finishedSync:OCMOCK_ANY]) andDo:^(NSInvocation *invocation) {
                void (^ __unsafe_unretained jetpackStub)(void);
                [invocation getArgument:&jetpackStub atIndex:7];
                
                jetpackStub();
            }];
            
            [viewModel finishedLoginWithUsername:username password:password xmlrpc:xmlrpc options:options];
            
            [mockViewModelDelegate verify];
        });
        
        it(@"should dismiss the login view", ^{
            [[mockViewModelDelegate expect] dismissLoginView];
            
            // Retrieve finishedSync block and execute it when appropriate
            [OCMStub([mockBlogSyncService syncBlogForAccount:OCMOCK_ANY username:username password:password xmlrpc:xmlrpc options:options needsJetpack:OCMOCK_ANY finishedSync:OCMOCK_ANY]) andDo:^(NSInvocation *invocation) {
                void (^ __unsafe_unretained finishedSyncStub)(void);
                [invocation getArgument:&finishedSyncStub atIndex:8];
                
                finishedSyncStub();
            }];
            
            [viewModel finishedLoginWithUsername:username password:password xmlrpc:xmlrpc options:options];
            
            [mockViewModelDelegate verify];
        });
    });
    
});

describe(@"toggleSignInFormAction", ^{
    
    it(@"should flag shoulDisplayMultifactorToFalse", ^{
        viewModel.shouldDisplayMultifactor = YES;
        
        [viewModel toggleSignInFormAction];
        
        expect(viewModel.shouldDisplayMultifactor).to.equal(NO);
    });
    
    it(@"should toggle userIsDotCom", ^{
        viewModel.userIsDotCom = YES;
        
        [viewModel toggleSignInFormAction];
        expect(viewModel.userIsDotCom).to.equal(NO);
        
        [viewModel toggleSignInFormAction];
        expect(viewModel.userIsDotCom).to.equal(YES);
    });
    
    it(@"should set the returnKeyType of passwordText to UIReturnKeyDone when the user is a self hosted user", ^{
        viewModel.userIsDotCom = NO;
        [[mockViewModelDelegate expect] setPasswordTextReturnKeyType:UIReturnKeyDone];
        
        [viewModel toggleSignInFormAction];
        
        [mockViewModelDelegate verify];
    });
    
    it(@"should set the returnKeyType of passwordText to UIReturnKeyNext when the user is a .com user", ^{
        viewModel.userIsDotCom = YES;
        [[mockViewModelDelegate expect] setPasswordTextReturnKeyType:UIReturnKeyNext];
        
        [viewModel toggleSignInFormAction];
        
        [mockViewModelDelegate verify];
    });
    
    it(@"should tell the view to reload it's interface", ^{
        [[mockViewModelDelegate expect] reloadInterfaceWithAnimation:YES];
        
        [viewModel toggleSignInFormAction];
        
        [mockViewModelDelegate verify];
    });
    
});

describe(@"displayMultifactorTextField", ^{
    
    it(@"should set shouldDisplayMultifactor to true", ^{
        viewModel.shouldDisplayMultifactor = NO;
        
        [viewModel displayMultifactorTextField];
        
        expect(viewModel.shouldDisplayMultifactor).to.equal(YES);
    });
    
    it(@"should reload the interface", ^{
        [[mockViewModelDelegate expect] reloadInterfaceWithAnimation:YES];
        
        [viewModel displayMultifactorTextField];
        
        [mockViewModelDelegate verify];
    });
    
    it(@"should set the focus to the multifactor text field", ^{
        [[mockViewModelDelegate expect] setFocusToMultifactorText];
        
        [viewModel displayMultifactorTextField];
        
        [mockViewModelDelegate verify];
    });
});

describe(@"sendVerificationCodeButton visibility", ^{
    
    context(@"when authenticating", ^{
        
        it(@"should not be visible if the multifactor controls enabled", ^{
            [[mockViewModelDelegate expect] setSendVerificationCodeButtonHidden:YES];
            viewModel.authenticating = YES;
            viewModel.shouldDisplayMultifactor = YES;
            [mockViewModelDelegate verify];
        });
        
        it(@"should not be visible if the multifactor controls aren't enabled", ^{
            [[mockViewModelDelegate expect] setSendVerificationCodeButtonHidden:YES];
            viewModel.authenticating = YES;
            viewModel.shouldDisplayMultifactor = NO;
            [mockViewModelDelegate verify];
        });
    });
    
    context(@"when not authenticating", ^{
        
        it(@"should be visible if multifactor controls are enabled", ^{
            [[mockViewModelDelegate expect] setSendVerificationCodeButtonHidden:NO];
            viewModel.authenticating = NO;
            viewModel.shouldDisplayMultifactor = YES;
            [mockViewModelDelegate verify];
        });
        
        it(@"should not be visible if multifactor controls aren't enabled", ^{
            [[mockViewModelDelegate expect] setSendVerificationCodeButtonHidden:YES];
            viewModel.authenticating = NO;
            viewModel.shouldDisplayMultifactor = NO;
            [mockViewModelDelegate verify];
        });
    });
    
});

SpecEnd