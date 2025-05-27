//
//  TaskManger.h
//  ToDo
//
//  Created by mohamed Tajeldin on 07/05/2025.
//
//
//#import <Foundation/Foundation.h>
//#import "Task.h"
//NS_ASSUME_NONNULL_BEGIN
//
//@interface TaskManager : NSObject
//
//@property (nonatomic, strong) NSMutableArray<NSMutableArray<Task *> *> *priorityTasks;
//
//- (void)loadTasksWithState:(TaskState)filterState;
//- (void)saveTasks;
//- (Task *)taskAtSection:(NSInteger)section row:(NSInteger)row;
//- (void)deleteTaskAtSection:(NSInteger)section row:(NSInteger)row;
//
//@end

// TaskManager.h

#import <Foundation/Foundation.h>
#import "Task.h"

@interface TaskManager : NSObject

@property (nonatomic, strong) NSMutableArray<NSMutableArray<Task *> *> *priorityTasks;
@property (nonatomic, strong) NSMutableArray<Task *> *allTasks;

- (void)loadAllTasks;
- (void)applyFilter:(TaskState)filterState;
- (void)saveAllTasks;
- (Task *)taskAtSection:(NSInteger)section row:(NSInteger)row;
- (void)deleteTaskAtSection:(NSInteger)section row:(NSInteger)row;

@end


