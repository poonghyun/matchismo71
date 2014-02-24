//
//  Card.h
//  Matchismo7
//
//  Created by Mike Lee on 1/4/14.
//  Copyright (c) 2014 Butter Turtles. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Card : NSObject

@property (strong, nonatomic) NSString *contents;

@property (nonatomic, getter = isChosen) BOOL chosen;
@property (nonatomic, getter = isMatched) BOOL matched;

- (int)match:(NSArray *)otherCards;

@end
