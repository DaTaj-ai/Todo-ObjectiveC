//
//  ViewController.h
//  ToDo
//
//  Created by mohamed Tajeldin on 06/05/2025.
//

#import <UIKit/UIKit.h>
#import "Task.h"
@interface ViewController : UIViewController <UITableViewDelegate , UITableViewDelegate , UITabBarDelegate , UITableViewDataSource>
@property (strong, nonatomic) NSMutableArray<Task *> *tasks;
@property (strong, nonatomic) NSMutableArray<NSMutableArray *> *priorityTasks ; 

@end

