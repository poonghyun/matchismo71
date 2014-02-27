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
#import "PlayingCard.h"

@interface PlayingCardGameViewController ()
@property (strong, nonatomic) IBOutletCollection(PlayingCardView) NSArray *playingCardViews;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (strong, nonatomic) NSMutableArray *gestureRecognizers;
@end

@implementation PlayingCardGameViewController

- (NSMutableArray *)gestureRecognizers
{
    if (!_gestureRecognizers) _gestureRecognizers = [[NSMutableArray alloc] init];
    return _gestureRecognizers;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    for (PlayingCardView *cardView in self.playingCardViews) {
        // initialize card view with corresponding card in game
        PlayingCard *card = (PlayingCard *)[self.game cardAtIndex:[self.playingCardViews indexOfObject:cardView]];
        cardView.rank = card.rank;
        cardView.suit = card.suit;
        cardView.faceUp = NO;

        // add swipes
        UISwipeGestureRecognizer *gesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipe:)];
        [cardView addGestureRecognizer:gesture];
        [self.gestureRecognizers addObject:gesture];
    }
}

- (IBAction)swipe:(UISwipeGestureRecognizer *)sender
{
    int chosenButtonIndex = [self.gestureRecognizers indexOfObject:sender];
    [self.game chooseCardAtIndex:chosenButtonIndex];
    PlayingCardView *cardView = (PlayingCardView *)self.playingCardViews[chosenButtonIndex];
    [UIView transitionWithView:cardView
                      duration:0.3
                       options:UIViewAnimationOptionTransitionFlipFromLeft
                    animations:^{
                        cardView.faceUp = !cardView.faceUp;
                    }
                    completion:nil];
    // for each card, if it is matched in game set the corresponding view to matched
    // also check for unmatched cards
    for (int i = 0; i < [self.playingCardViews count]; i++) {
        // reuse ok?
        cardView = (PlayingCardView *)self.playingCardViews[i];
        if ([self.game cardAtIndex:i].matched) {
            cardView.matched = YES;
        }
        if (![self.game cardAtIndex:i].isChosen) {
            cardView.faceUp = NO;
        }
    }
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
}

- (Deck *)createDeck
{
    return [[PlayingCardDeck alloc] init];
}

@end
