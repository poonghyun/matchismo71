//
//  CardGameViewController.h
//  Matchismo71
//
//  Created by Mike Lee on 2/20/14.
//  Copyright (c) 2014 Butter Turtles. All rights reserved.
//
//  Abstract view controller superclass
//

#import <UIKit/UIKit.h>
#import "CardMatchingGame.h"
#import "Deck.h"

@interface CardGameViewController : UIViewController

@property (strong, nonatomic) CardMatchingGame *game;

- (Deck *)createDeck; // abstract

- (IBAction)pinch:(UIPinchGestureRecognizer *)sender;

@end
