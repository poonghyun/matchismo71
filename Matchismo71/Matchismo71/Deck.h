//
//  Deck.h
//  Matchismo7
//
//  Created by Mike Lee on 1/4/14.
//  Copyright (c) 2014 Butter Turtles. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"

@interface Deck : NSObject

- (void)addCard:(Card *)card atTop:(BOOL)atTop;
- (void)addCard:(Card *)card;

- (Card *)drawRandomCard;

@end
