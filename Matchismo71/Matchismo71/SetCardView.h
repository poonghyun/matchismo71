//
//  SetCardView.h
//  Matchismo71
//
//  Created by Mike Lee on 2/24/14.
//  Copyright (c) 2014 Butter Turtles. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardView.h"

@interface SetCardView : CardView

@property (strong, nonatomic) NSString *symbol;
@property (nonatomic) NSUInteger number;
@property (strong, nonatomic) UIColor *color;
@property (nonatomic) double shading;
@property (nonatomic) BOOL selected;

- (void)tap:(UITapGestureRecognizer *)gesture;

@end
