//
//  CardMatchingGame.m
//  Matchismo7
//
//  Created by Mike Lee on 1/4/14.
//  Copyright (c) 2014 Butter Turtles. All rights reserved.
//

#import "CardMatchingGame.h"

@interface CardMatchingGame()
@property (nonatomic, readwrite) NSInteger score;
@property (nonatomic, strong) NSMutableArray *cards; // of Card
@property (strong, nonatomic, readwrite) NSString *matchString;
@end

@implementation CardMatchingGame

- (NSMutableArray *)cards
{
    if (!_cards) _cards = [[NSMutableArray alloc] init];
    return _cards;
}

- (NSArray *)chosenCards{
    if (!_chosenCards) _chosenCards = [[NSMutableArray alloc] init];
    return _chosenCards;
}

- (instancetype)initWithCardCount:(NSUInteger)count
                        usingDeck:(Deck *)deck
{
    self = [super init];
    
    if (self) {
        for (int i = 0; i < count; i++) {
            Card *card = [deck drawRandomCard];
            if (card) {
                [self.cards addObject:card];
            } else {
                self = nil;
                break;
            }
        }
    }
    
    self.matchString = @""; // need to initialize string at beginning of game
    
    return self;
}

- (Card *)cardAtIndex:(NSUInteger)index
{
    return (index<[self.cards count]) ? self.cards[index] : nil;
}

static const int MISMATCH_PENALTY = 2;
static const int MATCH_BONUS = 4;
static const int COST_TO_CHOOSE = 1;

- (void)chooseCardAtIndex:(NSUInteger)index
{
    Card *card = [self cardAtIndex:index];
    
    if (!card.isMatched) {
        if (card.isChosen) {
            card.chosen = NO;
        } else {
            if (self.gameType == 1) { // 3-card
                self.chosenCards = nil;
                self.matchString = @"Flipped card.";
                
                for (Card *otherCard in self.cards) {
                    if (otherCard.isChosen && !otherCard.isMatched) {
                        self.chosenCards = [self.chosenCards arrayByAddingObject:otherCard];
                    }
                }
                
                if ([self.chosenCards count] == 2) {
                    int matchScore = [card match:self.chosenCards];
                    if (matchScore) {
                        self.score += matchScore * MATCH_BONUS;
                        card.matched = YES;
                        for (Card *matchedCard in self.chosenCards) {
                            matchedCard.matched = YES;
                        }
                        self.matchString = @"card, card, and card form a set!";
                    } else {
                        self.score -= MISMATCH_PENALTY;
                        for (Card *matchedCard in self.chosenCards) {
                            matchedCard.chosen = NO;
                        }
                        self.matchString = @"card, card, and card don't form a set.";
                    }
                } else if ([self.chosenCards count] == 1) {
                    self.matchString = @"Flipped card and card.";
                }
                
                self.chosenCards = [self.chosenCards arrayByAddingObject:card];
            } else if (self.gameType == 0) { // 2-card
                self.matchString = [NSString stringWithFormat:@"Flipped a %@.", card.contents];
                
                for (Card *otherCard in self.cards) {
                    if (otherCard.isChosen && !otherCard.isMatched) {
                        int matchScore = [card match:@[otherCard]];
                        if (matchScore) {
                            self.score += matchScore * MATCH_BONUS;
                            otherCard.matched = YES;
                            card.matched = YES;
                            self.matchString = [NSString stringWithFormat:@"%@ and %@ match!", card.contents, otherCard.contents];
                        } else {
                            self.score -= MISMATCH_PENALTY;
                            otherCard.chosen = NO;
                            self.matchString = [NSString stringWithFormat:@"%@ and %@ don't match.", card.contents, otherCard.contents];
                        }
                        break;
                    }
                }
            }
            self.score -= COST_TO_CHOOSE;
            card.chosen = YES;
        }
    }
}

@end
