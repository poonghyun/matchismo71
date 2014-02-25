//
//  PlayingCardGameViewController.m
//  Matchismo71
//
//  Created by Mike Lee on 2/24/14.
//  Copyright (c) 2014 Butter Turtles. All rights reserved.
//

#import "PlayingCardGameViewController.h"
#import "PlayingCardView.h"
#import "PlayingCardDeck.h"

@implementation PlayingCardGameViewController

- (Deck *)createDeck
{
    return [[PlayingCardDeck alloc] init];
}

//- (IBAction)swipe:(UISwipeGestureRecognizer *)sender
//{
//    int chosenButtonIndex = [self.cardViews indexOfObject:sender];
//    [self.game chooseCardAtIndex:chosenButtonIndex];
//    
//}

@end
