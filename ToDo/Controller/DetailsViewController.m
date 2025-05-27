//
//  DetailsViewController.m
//  ToDo
//
//  Created by mohamed Tajeldin on 06/05/2025.
//



#import "DetailsViewController.h"
#import "Task.h"
#import "EnumUtils.h"

@interface DetailsViewController ()
@property (weak, nonatomic) IBOutlet UISegmentedControl *priority;
@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UITextView *mydiscription;
@property (weak, nonatomic) IBOutlet UIDatePicker *date;
@property (weak, nonatomic) IBOutlet UISwitch *reminder;
@property (weak, nonatomic) IBOutlet UISegmentedControl *stateSegmentui;
@property (weak, nonatomic) IBOutlet UILabel *state;


@end


@implementation DetailsViewController
- (IBAction)didPriorityChanged:(id)sender {
    UISegmentedControl *segmentedControl = (UISegmentedControl *)sender;

    switch (segmentedControl.selectedSegmentIndex) {
        case 0:
            NSLog(@"Selected index is 0");
            break;
        case 1:
            NSLog(@"Selected index is 1");
            break;
        default:
            NSLog(@"Other index selected");
            break;
    }
    
}
- (void)removeOriginalTaskIfExists {
    if (!_globalTask) return;

    NSArray *savedArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"savedTasks"];
    NSMutableArray *taskDictionaries = [NSMutableArray arrayWithArray:savedArray ?: @[]];
    
    for (int i = 0; i < taskDictionaries.count; i++) {
        NSDictionary *dict = taskDictionaries[i];
        if ([dict[@"name"] isEqualToString:_globalTask.name] &&
            [dict[@"taskDescription"] isEqualToString:_globalTask.taskDescription]) {
            [taskDictionaries removeObjectAtIndex:i];
            break;
        }
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:taskDictionaries forKey:@"savedTasks"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.mydiscription.layer.borderWidth = 1.0;
    self.mydiscription.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.mydiscription.layer.cornerRadius = 5.0;


    UIBarButtonItem *customBack = [[UIBarButtonItem alloc] initWithTitle:@"Back"
                                                                    style:UIBarButtonItemStylePlain
                                                                   target:self
                                                                   action:@selector(handleBackButton)];
    self.navigationItem.leftBarButtonItem = customBack;
}

- (void)handleBackButton {
    //UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Save Changes?"
      //                                                             message:@"Do you want to save the changes to this task?"
        //                                                    preferredStyle:UIAlertControllerStyleAlert];

//    UIAlertAction *save = [UIAlertAction actionWithTitle:@"Save" style:UIAlertActionStyleDefault
//                                                 handler:^(UIAlertAction * _Nonnull action) {
//        //[self saveTask];
//        [self.navigationController popViewControllerAnimated:YES];
//    }];
    
//    UIAlertAction *discard = [UIAlertAction actionWithTitle:@"Discard" style:UIAlertActionStyleCancel
//                                                    handler:^(UIAlertAction * _Nonnull action) {
//        [self.navigationController popViewControllerAnimated:YES];
//    }];
//
//    [alert addAction:save];
//    [alert addAction:discard];
//
//    [self presentViewController:alert animated:YES completion:nil];
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    NSLog(@"Current editing mode: %ld", (long)_editingMode);
    if(_editingMode == TaskEditingModeCantEdit){
        [self.stateSegmentui setEnabled:NO forSegmentAtIndex:0];
        [self.stateSegmentui setEnabled:NO forSegmentAtIndex:1];
//        [self.stateSegmentui setEnabled:NO forSegmentAtIndex:2];
        printf("cant Edit ");
        _name.enabled = NO;
        _priority.enabled = NO;
        _date.enabled = NO ;
        _reminder.enabled = NO ;
        _mydiscription.editable = NO;
    }
    else if(_editingMode == TaskEditingModeCanEdit){
        printf("can Edit ");
    }
    else if(_editingMode == 3){
        [self.stateSegmentui setEnabled:NO forSegmentAtIndex:0];
    }
    
    
    if(_globalTask != nil ){
        _name.text = [_globalTask name] ;
        _mydiscription.text = [_globalTask taskDescription];
        _date.date = [_globalTask dueDate];
        switch ([_globalTask priority]) {
            case TaskPriorityLow:
                _priority.selectedSegmentIndex = 0;
                break;
            case TaskPriorityMedium:
                _priority.selectedSegmentIndex = 1;
                break;
            case TaskPriorityHigh:
                printf("High ");
                _priority.selectedSegmentIndex = 2;
                break;
            default:
                printf("No Priority");
                break;
        }
        switch ([_globalTask taskState]) {
            case TaskTodo:
                _stateSegmentui.selectedSegmentIndex = 0 ;
                break;
            case TaskDone:
                _stateSegmentui.selectedSegmentIndex = 2 ;
                break;
            case TaskProgress:
                _stateSegmentui.selectedSegmentIndex = 1 ;
                break;
            default:
                _stateSegmentui.selectedSegmentIndex = 0 ;
                break;
        }
    }
    else {
        _stateSegmentui.hidden = YES;
        _state.hidden = YES ;
    }
}

-(void)appendTaskToUserDefaults:(Task *)newTask {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSArray *savedArray = [defaults objectForKey:@"savedTasks"];
    
    NSMutableArray *taskDictionaries = [NSMutableArray arrayWithArray:savedArray ?: @[]];
    
    for(int i = 0 ; i < savedArray.count ; i++ ){
        printf("saves task");
    }
    
    [taskDictionaries addObject:[newTask toDictionary]];
    [defaults setObject:taskDictionaries forKey:@"savedTasks"];
    [defaults synchronize];
    
}


- (void)saveTask {
    [self removeOriginalTaskIfExists];

    Task *task = [[Task alloc] init];
    task.name = _name.text;
    task.taskDescription = _mydiscription.text;
    task.dueDate = _date.date;
    
    NSInteger selectedIndex = self.priority.selectedSegmentIndex;
    switch (selectedIndex) {
        case 2:
            task.priority = TaskPriorityHigh;
            break;
        case 1:
            task.priority = TaskPriorityMedium;
            break;
        case 0:
            task.priority = TaskPriorityLow;
            break;
        default:
            task.priority = TaskPriorityHigh;
            break;
    }
    
    if(_editingMode == TaskEditingModeNew){
        task.taskState = TaskTodo ;
    }
    else{
        NSInteger selectedIndex = self.stateSegmentui.selectedSegmentIndex;
        switch (selectedIndex) {
            case 1:
                task.taskState = TaskProgress;
                break;
            case 2:
                task.taskState = TaskDone;
                break;
            default:
                task.taskState = TaskTodo;
                break;
        }
    }
    
    [self appendTaskToUserDefaults:task];
}


//-(void) saveTask{
//    Task *task = [[Task alloc] init];
//    task.name = _name.text;
//    task.taskDescription = _discription.text;
//    task.dueDate = _date.date;
//
//
//    NSLog(@"%@ we are here in saving the task ",_discription.text);
//    NSLog(@"%@ we are here in saving the task " , task.taskDescription);
//
//    NSInteger selectedIndex = self.priority.selectedSegmentIndex;
//    switch (selectedIndex) {
//        case 0:
//            task.priority = TaskPriorityHigh;
//            break;
//        case 1:
//            task.priority = TaskPriorityMedium;
//            break;
//        case 2:
//            task.priority = TaskPriorityLow;
//            break;
//        default:
//            task.priority = TaskPriorityHigh;
//            break;
//    }
//
//    [self appendTaskToUserDefaults:task];
//}

- (IBAction)saveTaskButton:(id)sender {
    [self saveTask];
        
    [ self
        showAlert
    ];
    
}



-(void) showAlert {
    
    if(_editingMode == TaskEditingModeCanEdit){
        UIAlertController *alert =
        [UIAlertController alertControllerWithTitle:@"Task Updated Successfully"
                                            message:@" your task updated Successfully"
                                     preferredStyle:UIAlertControllerStyleAlert];
        
        
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK"
                                                     style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController popViewControllerAnimated:YES];
        }];
        [alert addAction:ok];
        
        [self presentViewController:alert animated:YES completion:nil];
 
    }
    else{
        UIAlertController *alert =
        [UIAlertController alertControllerWithTitle:@"Task added Successfully"
                                                                           message:@" you task added Successfully"
                                                                    preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK"
                                                     style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController popViewControllerAnimated:YES];
        }];
        [alert addAction:ok];
        
        [self presentViewController:alert animated:YES completion:nil];
 
        
    }
    
        
    
}


@end

