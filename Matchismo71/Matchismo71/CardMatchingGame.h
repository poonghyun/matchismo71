//
//  CardMatchingGame.h
//  Matchismo7
//
//  Created by Mike Lee on 1/4/14.
//  Copyright (c) 2014 Butter Turtles. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Deck.h"
#import "Card.h"

@interface CardMatchingGame : NSObject

- (instancetype)initWithCardCount:(NSUInteger)count
                        usingDeck:(Deck *)deck;

- (void)chooseCardAtIndex:(NSUInteger)index;
- (Card *)cardAtIndex:(NSUInteger)index;

@property (nonatomic, readonly) NSInteger score;
@property (strong, nonatomic, readonly) NSString *matchString;
@property (nonatomic) NSUInteger gameType;
@property (nonatomic, strong) NSArray *chosenCards;

@end
