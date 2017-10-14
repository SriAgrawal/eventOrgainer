//
//  HomeVC.m
//  Eventnoire-Organizer
//
//  Created by Aiman Akhtar on 10/04/17.
//  Copyright © 2017 com.mobiloitte. All rights reserved.
//

#import "AppDelegate.h"
#import "HomeVC.h"
#import "Macro.h"

@interface HomeVC ()<UITabBarControllerDelegate>

@property (strong, nonatomic) IBOutlet UITabBar *homeTabBar;


@end

@implementation HomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.delegate = self;
    
    self.homeTabBar.barTintColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];
    
    [[UITabBar appearance] setTintColor:[UIColor blackColor]];
    
    //text tint color
    [[UITabBarItem appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName : [UIColor darkGrayColor] } forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName : [UIColor blackColor] } forState:UIControlStateSelected];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    
//    if (tabBarController.selectedIndex == 1) {
//        if ([APPDELEGATE tabIndex] == 0)
//            [tabBarController setSelectedIndex:0];
//        else if ([APPDELEGATE tabIndex] == 2)
//            [tabBarController setSelectedIndex:2];
//        else if ([APPDELEGATE tabIndex] == 3)
//           [tabBarController setSelectedIndex:3];
//    }
}
@end
