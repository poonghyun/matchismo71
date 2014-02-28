//
//  CardGameViewController.m
//  Matchismo71
//
//  Created by Mike Lee on 2/20/14.
//  Copyright (c) 2014 Butter Turtles. All rights reserved.
//

#import "CardGameViewController.h"

@interface CardGameViewController ()
@end

@implementation CardGameViewController

- (CardMatchingGame *)game
{
    if (!_game) {
        Deck *deck = [self createDeck];
        _game = [[CardMatchingGame alloc] initWithCardCount:[deck size]
                                                  usingDeck:deck];
    }
    return _game;
}

// abstract
- (Deck *)createDeck
{
    return nil;
}

// gather the cards
- (IBAction)pinch:(UIPinchGestureRecognizer *)sender
{
    
}

@end
