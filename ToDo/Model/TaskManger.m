// TaskManager.m

#import "TaskManger.h"
#import "Task.h"

@implementation TaskManager

- (instancetype)init {
    if (self = [super init]) {
        _priorityTasks = [NSMutableArray array];
        _allTasks = [NSMutableArray array];
        for (int i = 0; i < 3; i++) {
            [_priorityTasks addObject:[NSMutableArray array]];
        }
    }
    return self;
}

- (void)loadAllTasks {
    [self.allTasks removeAllObjects];

    NSArray *saved = [[NSUserDefaults standardUserDefaults] objectForKey:@"savedTasks"];
    for (NSDictionary *dict in saved) {
        Task *task = [Task fromDictionary:dict];
        [self.allTasks addObject:task];
    }
}

- (void)applyFilter:(TaskState)filterState {
    // Clear priority sections
    [self.priorityTasks removeAllObjects];
    for (int i = 0; i < 3; i++) {
        [self.priorityTasks addObject:[NSMutableArray array]];
    }

    for (Task *task in self.allTasks) {
        if (task.taskState == filterState) {
            switch (task.priority) {
                case TaskPriorityLow:
                    [self.priorityTasks[2] addObject:task];
                    break;
                case TaskPriorityMedium:
                    [self.priorityTasks[1] addObject:task];
                    break;
                case TaskPriorityHigh:
                    [self.priorityTasks[0] addObject:task];
                    break;
            }
        }
    }
}

- (void)saveAllTasks {
    NSMutableArray *flatList = [NSMutableArray array];
    for (Task *task in self.allTasks) {
        [flatList addObject:[task toDictionary]];
    }

    [[NSUserDefaults standardUserDefaults] setObject:flatList forKey:@"savedTasks"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (Task *)taskAtSection:(NSInteger)section row:(NSInteger)row {
    return self.priorityTasks[section][row];
}

- (void)deleteTaskAtSection:(NSInteger)section row:(NSInteger)row {
    Task *task = self.priorityTasks[section][row];
    [self.priorityTasks[section] removeObjectAtIndex:row];
    [self.allTasks removeObject:task]; // Also remove from the full list
    [self saveAllTasks];
}

@end
