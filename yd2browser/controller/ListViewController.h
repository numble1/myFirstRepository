//
//  RingListViewController.h
//  yd2ringtone
//
//  Created by yunfenghan Ling on 3/3/17.
//  Copyright © 2017 lingyfh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GeneralViewController.h"

@interface ListViewController : GeneralViewController <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
