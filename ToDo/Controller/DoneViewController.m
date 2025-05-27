//
//  DoneViewController.m
//  ToDo
//
//  Created by mohamed Tajeldin on 07/05/2025.
//

#import "DoneViewController.h"

@interface DoneViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITabBar *myTabBar;
@property (strong, nonatomic) TaskManager *taskManager;

@end

@implementation DoneViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.taskManager = [[TaskManager alloc] init];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.taskManager loadAllTasks];
    [self.taskManager applyFilter:TaskDone]; 
    [self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0: return @"High";
        case 1: return @"Medium";
        case 2: return @"Low";
        default: return @"";
    }
}
- (IBAction)sort:(id)sender {
    for (NSMutableArray<Task *> *priorityArray in self.taskManager.priorityTasks) {
        [priorityArray sortUsingComparator:^NSComparisonResult(Task *task1, Task *task2) {
            return [task1.name compare:task2.name options:NSCaseInsensitiveSearch];
        }];
    }

    [self.tableView reloadData];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 50)];

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(16, -8, tableView.frame.size.width - 32, 30)];
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
    return self.taskManager.priorityTasks[section].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TaskCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TaskCell" forIndexPath:indexPath];

    Task *task = [self.taskManager taskAtSection:indexPath.section row:indexPath.row];

    cell.titleLabel.text = task.name;
    
    cell.priorityImageView.image = [UIImage imageNamed:@"done1"];
           
    

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Task *task = [self.taskManager taskAtSection:indexPath.section row:indexPath.row];
    
    DetailsViewController *detailsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"details"];
    detailsVC.editingMode = TaskEditingModeCantEdit ;
    
    detailsVC.globalTask = task;
 //   detailsVC.editingMode = TaskEditingModeCanEdit ;
    [_taskManager deleteTaskAtSection:indexPath.section row:indexPath.row];
    [self.navigationController pushViewController:detailsVC animated:YES];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
                                  forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.taskManager deleteTaskAtSection:indexPath.section row:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70.0;
}
- (IBAction)navigateToDetails:(id)sender {
        printf("YES \n");
        DetailsViewController *detailsView = [self.storyboard instantiateViewControllerWithIdentifier:@"details"];
    detailsView.editingMode = TaskEditingModeNew ;
    [self.navigationController pushViewController:detailsView animated:YES];
}



@end
