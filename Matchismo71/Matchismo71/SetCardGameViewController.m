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
#import "Grid.h"

@interface SetCardGameViewController () <UIDynamicAnimatorDelegate>
@property (strong, nonatomic) NSMutableArray *setCardViews;
@property (weak, nonatomic) IBOutlet UIView *cardSpace;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *errorLabel;
@property (strong, nonatomic) NSMutableArray *gestureRecognizers;
@property (nonatomic) NSUInteger cardCount; // number of cards on the board
@property (nonatomic) NSUInteger cardCountFromLastRound; // number of carryover cards
@property (nonatomic) NSUInteger unmatchedCardCount; // number of unmatched cards left in the game
@property (strong, nonatomic) Grid *grid;
@property (strong, nonatomic) UIDynamicAnimator *animator;
@property (nonatomic) BOOL cardsGathered;
@end

@implementation SetCardGameViewController

#pragma mark - Lazy instantiation

- (CardMatchingGame *)game
{
    CardMatchingGame *game = [super game];
    game.gameType = 1; // 3 card match
    return game;
}

- (NSMutableArray *)setCardViews
{
    if (!_setCardViews) _setCardViews = [[NSMutableArray alloc] init];
    return _setCardViews;
}

- (NSMutableArray *)gestureRecognizers
{
    if (!_gestureRecognizers) _gestureRecognizers = [[NSMutableArray alloc] init];
    return _gestureRecognizers;
}

- (Grid *)grid
{
    if (!_grid) _grid = [[Grid alloc] init];
    return _grid;
}

- (UIDynamicAnimator *)animator
{
    if (!_animator) {
        _animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.cardSpace];
        _animator.delegate = self;
    }
    return _animator;
}

#pragma mark - View initialization

#define STARTING_CARDS 12
#define TOTAL_CARDS 81
#define CELL_ASPECT_RATIO 1.5

- (void)viewDidLoad
{
	[super viewDidLoad];
    [self initializeCards];
}

- (void)viewDidLayoutSubviews
{
    [self placeCardsInGrid];
}

- (void)initializeCards
{
    // initialize all cards
    // set all cards
    // place cards in cardspace (reusable)
    
    self.cardCount = STARTING_CARDS;
    self.cardCountFromLastRound = 0;
    self.unmatchedCardCount = TOTAL_CARDS;
    self.cardsGathered = NO;
    
    for (int i = 0; i < TOTAL_CARDS; i++) {
        SetCardView *cardView = [[SetCardView alloc] init];
        [self.setCardViews addObject:cardView];
    }
    
    [self.view addGestureRecognizer:[[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinch:)]];
    
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
        cardView.shading = card.shading;
        cardView.symbol = card.symbol;
        cardView.selected = NO;
        cardView.matched = NO;
        
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        [cardView addGestureRecognizer:gesture];
        [self.gestureRecognizers addObject:gesture];
    }
    
//    NSLog(@"%@", ((SetCardView *)self.setCardViews[20]).symbol);
    
    [self placeCardsInGrid];
}

- (void)placeCardsInGrid
{
    // set grid properties
    self.grid.cellAspectRatio = CELL_ASPECT_RATIO;
    self.grid.size = self.cardSpace.frame.size;
    self.grid.minimumNumberOfCells = self.cardCount;
    self.grid.maxCellWidth = self.cardSpace.frame.size.width/3;
    
    // calculate buffer space between cards
    float freespaceX = fmodf(self.cardSpace.frame.size.width, self.grid.cellSize.width);
    float freespaceY = fmodf(self.cardSpace.frame.size.height, self.grid.cellSize.height);
    float bufferX = freespaceX / (self.grid.columnCount - 1);
    float bufferY = freespaceY / (self.grid.rowCount -1);
    
    int cardsPlaced = 0;
    int cardViewIndex = 0;
    // place cards in grid
    for (int row = 0; row < self.grid.rowCount; row++) {
        for (int col = 0; col < self.grid.columnCount; col++)
        {
            if (cardsPlaced < self.cardCount) {
                // get next unmatched cardview
                SetCardView *cardView = self.setCardViews[cardViewIndex];
                while (cardView.matched) {
                    cardViewIndex++;
                    cardView = self.setCardViews[cardViewIndex];
                }
                // set size
                cardView.frame = [self.grid frameOfCellAtRow:row inColumn:col];
                
                // place in cell
                cardView.center = CGPointMake(0, self.view.frame.size.height);
                CGPoint gridCenter = [self.grid centerOfCellAtRow:row inColumn:col];
                CGPoint newCenter = CGPointMake(gridCenter.x + bufferX * col, gridCenter.y + bufferY * row);
                if (cardsPlaced >= self.cardCountFromLastRound) {
                    [UIView animateWithDuration:0.5 delay:0.1 * (cardsPlaced - self.cardCountFromLastRound) options:UIViewAnimationOptionCurveLinear animations:^{
                        cardView.center = newCenter;
                    } completion:^(BOOL ended){}];
                } else {
                    cardView.center = newCenter;
                }

                // add to the board
                [self.cardSpace addSubview:cardView];
            
                cardViewIndex++;
                cardsPlaced++;
            }
        }
    }
    
    [self.animator removeAllBehaviors];
    for (SetCardView *cardView in self.cardSpace.subviews) {
        [self.animator addBehavior:[[UIAttachmentBehavior alloc] initWithItem:cardView attachedToAnchor:self.cardSpace.center]];
    }
}

#pragma mark - Gestures

- (void)tap:(UITapGestureRecognizer *)sender
{
    if (self.cardsGathered) {
        [self placeCardsInGrid];
        self.cardsGathered = NO;
    } else {
        //    NSLog(@"tapped");
        int chosenButtonIndex = [self.gestureRecognizers indexOfObject:sender];
        [self.game chooseCardAtIndex:chosenButtonIndex];
        SetCardView *cardView = (SetCardView *)self.setCardViews[chosenButtonIndex];
        cardView.selected = !cardView.selected;
        BOOL foundMatch = NO;
        for (SetCardView *card in self.cardSpace.subviews) {
            // if not chosen make it unchosen
            // if matched remove from superview and redraw grid
            int cardIndex = [self.setCardViews indexOfObject:card];
            if (![self.game cardAtIndex:cardIndex].isChosen) {
                card.selected = NO;
            }
            if ([self.game cardAtIndex:cardIndex].isMatched) {
                self.cardCount -= 1;
                self.unmatchedCardCount -= 1;
                foundMatch = YES;
                card.matched = YES;
                [card removeFromSuperview];
            }
        }
        if (foundMatch) [self placeCardsInGrid];
        self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
    }
}

- (void)pinch:(UIPinchGestureRecognizer *)sender
{
    self.cardsGathered = YES;
    if ((sender.state == UIGestureRecognizerStateChanged) ||
        (sender.state == UIGestureRecognizerStateEnded)) {
        for (UIAttachmentBehavior *attachment in self.animator.behaviors) {
            attachment.length *= sender.scale;
        }
        sender.scale = 1.0;
    }
}

#pragma mark - Dynamic animation

- (void)dynamicAnimatorDidPause:(UIDynamicAnimator *)animator {}

- (void)dynamicAnimatorWillResume:(UIDynamicAnimator *)animator {}

#pragma mark - Miscellaneous

- (Deck *)createDeck
{
    return [[SetCardDeck alloc] init];
}

#pragma mark - Redeal and add card buttons

- (IBAction)moreCards:(UIButton *)sender {
    if (self.cardCount < self.unmatchedCardCount) {
        self.cardCount += 3;
        self.cardCountFromLastRound = self.cardCount - 3;
        [self placeCardsInGrid];
    } else {
        self.errorLabel.text = @"No more cards!";
    }
}

- (IBAction)redeal {
    self.game = nil;
    self.gestureRecognizers = nil;
    self.grid = nil;
    self.setCardViews = nil;
    self.scoreLabel.text = @"Score: 0";
    self.errorLabel.text = @"";
    for (SetCardView *subview in self.cardSpace.subviews) {
        [UIView transitionWithView:subview duration:0.7 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
            subview.alpha = 0.0;
        }completion:^(BOOL ended) {
            [subview removeFromSuperview];
        }];
    }
    [self initializeCards];
}

@end
