//
//  SetCardGameViewController.m
//  Matchismo71
//
//  Created by Mike Lee on 2/24/14.
//  Copyright (c) 2014 Butter Turtles. All rights reserved.
//

#import "SetCardGameViewController.h"
#import "SetCardView.h"
#import "SetCardDeck.h"
#import "SetCard.h"

@interface SetCardGameViewController ()
@property (strong, nonatomic) IBOutletCollection(SetCardView) NSArray *setCardViews;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (strong, nonatomic) NSMutableArray *gestureRecognizers;
@end

@implementation SetCardGameViewController

- (CardMatchingGame *)game
{
    CardMatchingGame *game = [super game];
    game.gameType = 1; // 3 card match
    return game;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
    [self initializeCards];
}

- (void)initializeCards
{
    for (SetCardView *cardView in self.setCardViews) {
        [UIView transitionWithView:cardView
                          duration:0.8
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:^{SetCard *card = (SetCard *)[self.game cardAtIndex:[self.setCardViews indexOfObject:cardView]];
                            if ([card.color isEqualToString:@"red"]) {
                                cardView.color = [UIColor redColor];
                            } else if ([card.color isEqualToString:@"green"]) {
                                cardView.color = [UIColor greenColor];
                            } else if ([card.color isEqualToString:@"blue"]) {
                                cardView.color = [UIColor blueColor];
                            }
                            cardView.number = card.number;
                            cardView.shading = card.shading;
                            cardView.symbol = card.symbol;
                            cardView.selected = NO;
                            cardView.matched = NO;
                            
                            UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
                            [cardView addGestureRecognizer:gesture];
                            [self.gestureRecognizers addObject:gesture];}
                        completion:nil];

    }
}

- (IBAction)tap:(UISwipeGestureRecognizer *)sender
{
    int chosenButtonIndex = [self.gestureRecognizers indexOfObject:sender];
    [self.game chooseCardAtIndex:chosenButtonIndex];
    SetCardView *cardView = (SetCardView *)self.setCardViews[chosenButtonIndex];
    // do animation and make the card selected (yellow stroke)
    [UIView animateWithDuration:0.3 animations:^{
        cardView.selected = !cardView.selected;
    }];
    for (int i = 0; i < [self.setCardViews count]; i++) {
        // reuse ok?
        cardView = (SetCardView *)self.setCardViews[i];
        if (![self.game cardAtIndex:i].isChosen) {
            cardView.selected = NO;
        }
        if ([self.game cardAtIndex:i].isMatched) {
            [UIView animateWithDuration:1.0
                                  delay:0.0
                                options:UIViewAnimationOptionCurveLinear
                             animations:^{ cardView.alpha = 0.0; }
                             completion:^(BOOL ended){ if (ended) [cardView removeFromSuperview]; }];
        }
    }
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
}

- (NSMutableArray *)gestureRecognizers
{
    if (!_gestureRecognizers) _gestureRecognizers = [[NSMutableArray alloc] init];
    return _gestureRecognizers;
}

- (Deck *)createDeck
{
    return [[SetCardDeck alloc] init];
}

- (IBAction)redeal {
    self.game = nil;
    self.gestureRecognizers = nil;
    [self initializeCards];
}

@end
