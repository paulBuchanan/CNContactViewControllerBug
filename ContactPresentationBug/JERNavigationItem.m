//
//  Jericho
//
//  Copyright 2017 Thomson Reuters. All Rights Reserved. Proprietary and 
//  Confidential information of Thomson Reuters. Disclosure, Use or Reproduction 
//  without the written authorization of Thomson Reuters is prohibited.
//

#import "JERNavigationItem.h"
#define isiOS10_2_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 10.2f)

@implementation JERNavigationItem

- (NSArray *)leftBarButtonItems {
    return [super leftBarButtonItems];
}

- (void)setLeftBarButtonItem:(UIBarButtonItem *)leftBarButtonItem {
    [super setLeftBarButtonItem:leftBarButtonItem];
}


- (void)setLeftBarButtonItems:(NSArray<UIBarButtonItem *> *)leftBarButtonItems {
    [super setLeftBarButtonItems:leftBarButtonItems];
}

- (void)setLeftBarButtonItems:(NSArray<UIBarButtonItem *> *)items animated:(BOOL)animated {
    if (!isiOS10_2_OR_LATER && items && items.count == 0) {
        // Ignore call below 10.2 because it removes our done button. Bug fixed in 10.2
    } else {
        [super setLeftBarButtonItems:items animated:animated];
    }
}
@end
