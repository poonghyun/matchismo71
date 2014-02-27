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
	for (SetCardView *cardView in self.setCardViews) {
        SetCard *card = (SetCard *)[self.game cardAtIndex:[self.setCardViews indexOfObject:cardView]];
        if ([card.color isEqualToString:@"red"]) {
            cardView.color = [UIColor redColor];
        } else if ([card.color isEqualToString:@"green"]) {
            cardView.color = [UIColor greenColor];
        } else if ([card.color isEqualToString:@"blue"]) {
            cardView.color = [UIColor blueColor];
        }
        cardView.number = card.number;
        cardView.shading = card.shading * 0.5;
        cardView.symbol = card.symbol;
    
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        [cardView addGestureRecognizer:gesture];
        [self.gestureRecognizers addObject:gesture];
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

@end
