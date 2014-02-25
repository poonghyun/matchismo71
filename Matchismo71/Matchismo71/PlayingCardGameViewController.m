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

@interface PlayingCardGameViewController ()
@property (strong, nonatomic) IBOutletCollection(PlayingCardView) NSArray *playingCardViews;
@end

@implementation PlayingCardGameViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    for (PlayingCardView *card in self.playingCardViews) {
        // initialize card view with corresponding card in game
        card.rank = 5;
        card.suit = @"♠";
        card.faceUp = NO;

        // add swipes
        [card addGestureRecognizer:[[UISwipeGestureRecognizer alloc] initWithTarget:card action:@selector(swipe:)]];
    }
}

//- (IBAction)swipe:(PlayingCardView *)sender
//{
//    int chosenButtonIndex = [self.playingCardViews indexOfObject:sender];
//    [self.game chooseCardAtIndex:chosenButtonIndex];
//    NSLog(@"%d", self.game.score);
//}

- (Deck *)createDeck
{
    return [[PlayingCardDeck alloc] init];
}

@end
