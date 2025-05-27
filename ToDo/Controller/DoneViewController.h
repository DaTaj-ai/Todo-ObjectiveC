//
//  DoneViewController.h
//  ToDo
//
//  Created by mohamed Tajeldin on 07/05/2025.
//

#import <UIKit/UIKit.h>
#import "Task.h"
#import "Task.h"
#import "DetailsViewController.h"
#import "TaskManger.h"
#import "TaskCell.h"
#import "EnumUtils.h"
NS_ASSUME_NONNULL_BEGIN


@interface DoneViewController : UIViewController <UITableViewDelegate , UITableViewDelegate , UITabBarDelegate , UITableViewDataSource>
@property (strong, nonatomic) NSMutableArray<Task *> *tasks;
@property (strong, nonatomic) NSMutableArray<NSMutableArray *> *priorityTasks ;

@end


NS_ASSUME_NONNULL_END
