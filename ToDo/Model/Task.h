//
//  Task.h
//  ToDo
//
//  Created by mohamed Tajeldin on 06/05/2025.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, TaskPriority){
    TaskPriorityLow,
    TaskPriorityMedium,
    TaskPriorityHigh
};

typedef NS_ENUM(NSInteger, TaskState){
    TaskDone,
    TaskProgress,
    TaskTodo
};

@interface Task : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *taskDescription;
@property (nonatomic, strong) NSDate *dueDate;
@property (nonatomic, assign) BOOL isReminderActive;
@property (nonatomic, assign) TaskPriority priority;
@property (nonatomic, assign) TaskState taskState ;


- (NSDictionary *)toDictionary;
+ (Task *)fromDictionary:(NSDictionary *)dict;
@end
