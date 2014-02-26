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
@property (strong, nonatomic) NSMutableArray *gestureRecognizers;
@end

@implementation SetCardGameViewController

- (void)viewDidLoad
{
	[super viewDidLoad];
	// test with a single set card/ outlet
}

- (IBAction)tap:(UISwipeGestureRecognizer *)sender
{
    int chosenButtonIndex = [self.gestureRecognizers indexOfObject:sender];
    [self.game chooseCardAtIndex:chosenButtonIndex];
    SetCardView *cardView = (SetCardView *)self.setCardViews[chosenButtonIndex];
    // do animation and make the card selected (yellow stroke)
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
