//
//  Task.m
//  ToDo
//
//  Created by mohamed Tajeldin on 06/05/2025.
//

#import "Task.h"

@implementation Task


- (NSDictionary *)toDictionary {
    return @{
        @"name": self.name ?: @"",
        @"description": self.taskDescription ?: @"",
        @"dueDate": self.dueDate ?: [NSDate date],
        @"priority": @(self.priority),
        @"taskState": @(self.taskState)
    };
}

+ (Task *)fromDictionary:(NSDictionary *)dict {
    Task *task = [[Task alloc] init];
    task.name = dict[@"name"];
    task.taskDescription = dict[@"description"];
    task.dueDate = dict[@"dueDate"];
    task.priority = [dict[@"priority"] integerValue];
    task.taskState = [dict[@"taskState"] integerValue];
    return task;
}

@end
