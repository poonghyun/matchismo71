//
//  SetCardDeck.m
//  Matchismo7
//
//  Created by Mike Lee on 1/21/14.
//  Copyright (c) 2014 Butter Turtles. All rights reserved.
//

#import "SetCardDeck.h"
#import "SetCard.h"

@implementation SetCardDeck

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        for (NSString *symbol in [SetCard validSymbols]) {
            for (NSString *color in [SetCard validColors]) {
                for (NSUInteger number = 0; number < [SetCard maxNumber]; number++) {
                    for (NSUInteger shading = 0; shading < [SetCard maxShading]; shading++) {
                        SetCard *card = [[SetCard alloc] init];
                        card.symbol = symbol;
                        card.color = color;
                        card.number = number;
                        card.shading = shading;
                        [self addCard:card];
                    }
                }
            }
        }
    }
    
    return self;
}

@end
