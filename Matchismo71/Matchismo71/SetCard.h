//
//  SetCard.h
//  Matchismo7
//
//  Created by Mike Lee on 1/21/14.
//  Copyright (c) 2014 Butter Turtles. All rights reserved.
//

#import "Card.h"

@interface SetCard : Card

@property (strong, nonatomic) NSString *symbol;
@property (nonatomic) NSUInteger number;
@property (strong, nonatomic) NSString *color;
@property (nonatomic) NSUInteger shading;

+ (NSArray *)validSymbols;
+ (NSArray *)validColors;
+ (NSUInteger)maxShading;
+ (NSUInteger)maxNumber;

@end
