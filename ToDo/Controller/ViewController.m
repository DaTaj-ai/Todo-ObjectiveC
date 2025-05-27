//
//  ViewController.m
//  ToDo
//
//  Created by mohamed Tajeldin on 06/05/2025.
//

#import "ViewController.h"
#import "Task.h"
#import "DetailsViewController.h"
#import "TaskManger.h"
#import "TaskCell.h"
#import "EnumUtils.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITabBar *myTabBar;
@property (strong, nonatomic) TaskManager *taskManager;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (assign, nonatomic) BOOL isFiltering;
@property (strong, nonatomic) NSMutableArray<NSMutableArray<Task *> *> *filteredTasks;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Remove space above first section
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.searchBar.backgroundImage = [UIImage new];
    [self customizeSearchBar];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    // Avoid manually setting top inset if search bar is above the table
    self.tableView.contentInset = UIEdgeInsetsZero;
    self.tableView.scrollIndicatorInsets = UIEdgeInsetsZero;

    // Set up data
    self.taskManager = [[TaskManager alloc] init];
    self.filteredTasks = [NSMutableArray array];
    for (int i = 0; i < 3; i++) {
        [self.filteredTasks addObject:[NSMutableArray array]];
    }

    // Tab bar appearance fix
    if (@available(iOS 13.0, *)) {
        UITabBarAppearance *appearance = [[UITabBarAppearance alloc] init];
        appearance.backgroundColor = UIColor.whiteColor;
        self.myTabBar.standardAppearance = appearance;
        self.myTabBar.scrollEdgeAppearance = appearance;
    } else {
        self.myTabBar.barTintColor = UIColor.whiteColor;
    }
    self.myTabBar.tintColor = [UIColor systemBlueColor]; // active tab color
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self.taskManager loadAllTasks];
    [self.taskManager applyFilter:TaskTodo];
    self.isFiltering = NO;
    [self.tableView reloadData];
}

#pragma mark - TableView Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.isFiltering ? 1 : 3;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0: return @"High";
        case 1: return @"Medium";
        case 2: return @"Low";
        default: return @"";
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 50)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(16, 8, tableView.frame.size.width - 32, 30)];
    label.textColor = [UIColor systemBlueColor];
    label.font = [UIFont boldSystemFontOfSize:20];
    label.textAlignment = NSTextAlignmentLeft;
    
    switch (section) {
        case 0: label.text = @"High Priority"; break;
        case 1: label.text = @"Medium Priority"; break;
        case 2: label.text = @"Low Priority"; break;
        default: label.text = @"";
    }
    
    [headerView addSubview:label];
    return headerView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.isFiltering) {
        return self.filteredTasks[0].count;
    } else {
        return self.taskManager.priorityTasks[section].count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"myTaskCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        
        UIView *containerView = [[UIView alloc] initWithFrame:CGRectInset(cell.contentView.bounds, 12, 8)];
        containerView.tag = 100;
        containerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        containerView.layer.cornerRadius = 16;
        containerView.layer.shadowColor = UIColor.blackColor.CGColor;
        containerView.layer.shadowOffset = CGSizeMake(0, 2);
        containerView.layer.shadowOpacity = 0.1;
        containerView.layer.shadowRadius = 6;
        containerView.layer.masksToBounds = NO;
        [cell.contentView addSubview:containerView];

        UIImageView *priorityImageView = [[UIImageView alloc] initWithFrame:CGRectMake(16, 16, 24, 24)];
        priorityImageView.tag = 300;
        priorityImageView.contentMode = UIViewContentModeScaleAspectFit;
        [containerView addSubview:priorityImageView];

        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(52, 14, containerView.frame.size.width - 68, 26)];
        titleLabel.tag = 200;
        titleLabel.font = [UIFont systemFontOfSize:17 weight:UIFontWeightSemibold];
        [containerView addSubview:titleLabel];

        UILabel *subtitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(52, 42, containerView.frame.size.width - 68, 20)];
        subtitleLabel.tag = 201;
        subtitleLabel.font = [UIFont systemFontOfSize:14];
        subtitleLabel.textColor = [UIColor grayColor];
        [containerView addSubview:subtitleLabel];
    }

    UIView *containerView = [cell.contentView viewWithTag:100];
    UIImageView *priorityImageView = [containerView viewWithTag:300];
    UILabel *titleLabel = [containerView viewWithTag:200];
    UILabel *subtitleLabel = [containerView viewWithTag:201];

    Task *task = self.isFiltering ? self.filteredTasks[0][indexPath.row] : [self.taskManager taskAtSection:indexPath.section row:indexPath.row];
    
    titleLabel.text = task.name;
    subtitleLabel.text = @"Due: Tomorrow";

    switch (task.priority) {
        case TaskPriorityHigh:
            priorityImageView.image = [UIImage imageNamed:@"high_priority"];
            containerView.backgroundColor = [UIColor colorWithRed:1.0 green:0.85 blue:0.85 alpha:1.0];
            break;
        case TaskPriorityMedium:
            priorityImageView.image = [UIImage imageNamed:@"medium_priority"];
            containerView.backgroundColor = [UIColor colorWithRed:0.9 green:0.95 blue:1.0 alpha:1.0];
            break;
        case TaskPriorityLow:
            priorityImageView.image = [UIImage imageNamed:@"low_priority"];
            containerView.backgroundColor = [UIColor colorWithRed:0.9 green:1.0 blue:0.9 alpha:1.0];
            break;
    }

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - Search

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    self.isFiltering = searchText.length > 0;

    for (NSMutableArray *array in self.filteredTasks) {
        [array removeAllObjects];
    }

    if (self.isFiltering) {
        NSArray *savedTasks = [[NSUserDefaults standardUserDefaults] objectForKey:@"savedTasks"];
        for (NSDictionary *dict in savedTasks) {
            Task *task = [Task fromDictionary:dict];
            if ([task.name.lowercaseString containsString:searchText.lowercaseString]) {
                [self.filteredTasks[0] addObject:task];
            }
        }
    }

    [self.tableView reloadData];
}

- (void)customizeSearchBar {
    UISearchBar *searchBar = self.searchBar;
    searchBar.searchBarStyle = UISearchBarStyleMinimal;
    searchBar.placeholder = @"Search tasks...";

    UITextField *textField = [searchBar valueForKey:@"searchField"];
    if (textField) {
        textField.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1.0];
        textField.layer.cornerRadius = 10;
        textField.clipsToBounds = YES;
        textField.textColor = [UIColor darkGrayColor];
        textField.font = [UIFont systemFontOfSize:16];
    }
}

#pragma mark - Navigation

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Task *task = [self.taskManager taskAtSection:indexPath.section row:indexPath.row];
    
    DetailsViewController *detailsView = [self.storyboard instantiateViewControllerWithIdentifier:@"details"];
    detailsView.editingMode = TaskEditingModeCanEdit;
    detailsView.globalTask = task;
    [self.taskManager deleteTaskAtSection:indexPath.section row:indexPath.row];
   
    [self.navigationController pushViewController:detailsView animated:YES];

    }


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Show the delete confirmation alert
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Delete Task"
                                                                                 message:@"Are you sure you want to delete this task?"
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        
        // Add "Delete" action
        UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"Delete" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
            // Delete the task
            [self.taskManager deleteTaskAtSection:indexPath.section row:indexPath.row];
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }];
        
        // Add "Cancel" action
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            // Just dismiss the alert
        }];
        
        // Add actions to the alert controller
        [alertController addAction:deleteAction];
        [alertController addAction:cancelAction];
        
        // Present the alert
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 85;
}

-(IBAction)navigateToDetails:(id)sender {
    DetailsViewController *detailsView = [self.storyboard instantiateViewControllerWithIdentifier:@"details"];
    detailsView.editingMode = TaskEditingModeNew;
    [self.navigationController pushViewController:detailsView animated:YES];
}

@end
