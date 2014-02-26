//
//  SetCard.m
//  Matchismo7
//
//  Created by Mike Lee on 1/21/14.
//  Copyright (c) 2014 Butter Turtles. All rights reserved.
//

#import "SetCard.h"

@implementation SetCard

static const int MATCH_SCORE = 5;
static const int TYPES = 3;

- (int)match:(NSArray *)otherCards
{
    if (otherCards.count == 2) {
        SetCard *secondCard = [otherCards objectAtIndex:0];
        SetCard *thirdCard = [otherCards objectAtIndex:1];
        
        // check symbol
        if ([self.symbol isEqualToString:secondCard.symbol]) {
            if (![self.symbol isEqualToString:thirdCard.symbol]) return 0;
        } else if ([self.symbol isEqualToString:thirdCard.symbol] || [secondCard.symbol isEqualToString:thirdCard.symbol]) return 0;
        // check number
        if (self.number == secondCard.number) {
            if (self.number != thirdCard.number) return 0;
        } else if (self.number == thirdCard.number || secondCard.number == thirdCard.number) return 0;
        // check shading
        if (self.shading == secondCard.shading) {
            if (self.shading != thirdCard.shading) return 0;
        } else if (self.shading == thirdCard.shading || secondCard.shading == thirdCard.shading) return 0;
        // check color
        if ([self.color isEqualToString:secondCard.color]) {
            if (![self.color isEqualToString:thirdCard.color]) return 0;
        } else if ([self.color isEqualToString:thirdCard.color] || [secondCard.color isEqualToString:thirdCard.color]) return 0;
        
        // did we pass all the checks? if yes, return match score
        return MATCH_SCORE;
        
    } else {
        return 0;
    }
}

//- (NSString *)contents
//{
//    NSString *cardContents = @"";
//    for (NSUInteger i = 0; i < self.number; i++) {
//        cardContents = [cardContents stringByAppendingString:self.symbol];
//    }
//    
//    return cardContents;
//}

+ (NSArray *)validSymbols
{
    return @[@"oval",@"squiggle",@"diamond"];
}

+ (NSArray *)validColors
{
    return @[@"red",@"green",@"blue"];
}

+ (NSUInteger)maxShading
{
    return TYPES;
}

+ (NSUInteger)maxNumber
{
    return TYPES;
}

@end
