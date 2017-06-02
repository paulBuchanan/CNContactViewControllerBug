//
//  Jericho
//
//  Copyright 2017 Thomson Reuters. All Rights Reserved. Proprietary and
//  Confidential information of Thomson Reuters. Disclosure, Use or Reproduction
//  without the written authorization of Thomson Reuters is prohibited.
//

#import "JERContactViewController.h"
#import "JERNavigationItem.h"

@interface JERContactViewController ()
@property UINavigationItem *navItem;

@end

@implementation JERContactViewController

//- (void)viewDidLoad {
//    [super viewDidLoad];
//}
//
//- (void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
//    //self.navigationController.navigationBar.backgroundColor = [UIColor whiteColor];
//}
//
//- (void)viewDidDisappear:(BOOL)animated {
//    [super viewDidDisappear:animated];
//}
//
//- (BOOL)prefersStatusBarHidden {
//    return YES;
//}
//
//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
//}

- (UINavigationItem *)navigationItem {
    if (!self.navItem) {
        self.navItem = [[JERNavigationItem alloc] initWithTitle:self.title];
    }
    return self.navItem;
}



@end
