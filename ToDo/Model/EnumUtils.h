//
//  EnumUtils.h
//  ToDo
//
//  Created by mohamed Tajeldin on 07/05/2025.
//

#ifndef EnumUtils_h
#define EnumUtils_h

@interface EnumUtils : NSObject

typedef NS_ENUM(NSInteger, TaskEditingMode) {
    TaskEditingModeNew  ,
    TaskEditingModeCanEdit,
    TaskEditingModeCantEdit
};

@end
#endif /* EnumUtils_h */
