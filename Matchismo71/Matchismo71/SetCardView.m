//
//  SetCardView.m
//  Matchismo71
//
//  Created by Mike Lee on 2/24/14.
//  Copyright (c) 2014 Butter Turtles. All rights reserved.
//

#import "SetCardView.h"

@implementation SetCardView

#pragma mark - Gesture Handling

- (void)tap:(UITapGestureRecognizer *)gesture
{
    self.selected = !self.selected;
}

#pragma mark - Setters

- (void)setSymbol:(NSString *)symbol
{
    _symbol = symbol;
    [self setNeedsDisplay];
}

- (void)setNumber:(NSUInteger)number
{
    _number = number;
    [self setNeedsDisplay];
}

- (void)setColor:(UIColor *)color
{
    _color = color;
    [self setNeedsDisplay];
}

- (void)setShading:(NSDecimal)shading
{
    _shading = shading;
    [self setNeedsDisplay];
}

- (void)setSelected:(BOOL)selected
{
    _selected = selected;
    [self setNeedsDisplay];
}

#pragma mark - Drawing

#define CORNER_FONT_STANDARD_HEIGHT 180.0
#define CORNER_RADIUS 12.0

- (CGFloat)cornerScaleFactor { return self.bounds.size.height / CORNER_FONT_STANDARD_HEIGHT; }
- (CGFloat)cornerRadius { return CORNER_RADIUS * [self cornerScaleFactor]; }

- (void)drawRect:(CGRect)rect
{
    UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:[self cornerRadius]];
    
    [roundedRect addClip];
    
    [[UIColor whiteColor] setFill];
    UIRectFill(self.bounds);
    
    [[UIColor blackColor] setStroke];
    [roundedRect stroke];

    [self drawSymbols];
}

- (void)drawSymbols
{
    // need to set stroke width and fill alpha based on set card
    [self.color setFill];
    [self.color setStroke];

    // make sub-rects for drawing depending on number
    NSMutableArray *symbolContainers = [[NSMutableArray alloc] init];
    if (self.number == 0) {

    } else if (self.number == 1) {

    } else if (self.number == 2) {

    }

    // which symbol? current using bounds instead of sub-rects
    if ([self.symbol isEqualToString:@"oval"]) {
        UIBezierPath *oval = [UIBezierPath bezierPathWithOvalInRect:self.bounds];

        [oval fill];
        [oval stroke];
    } else if ([self.symbol isEqualToString:@"squiggle"]) {
        UIBezierPath *squiggle = [[UIBezierPath alloc] init];
        // need to make arced lines
        [squiggle moveToPoint:CGPointMake(0,0)];
        [squiggle addLineToPoint:CGPointMake(self.bounds.size.width/3, self.bounds.size.height/3)];
        [squiggle addLineToPoint:CGPointMake(self.bounds.size.width/3, self.bounds.size.height)];
        [squiggle addLineToPoint:CGPointMake(self.bounds.size.width, self.bounds.size.height)];
        [squiggle addLineToPoint:CGPointMake(self.bounds.size.width/3 * 2, self.bounds.size.height/3 * 2)];
        [squiggle addLineToPoint:CGPointMake(self.bounds.size.width/3 * 2, 0)];
        [squiggle closePath];

        [squiggle fill];
        [squiggle stroke];
    } else if ([self.symbol isEqualToString:@"diamond"]) {
        UIBezierPath *diamond = [[UIBezierPath alloc] init];
        [diamond moveToPoint:CGPointMake(self.bounds.size.width/2, 0)];
        [diamond addLineToPoint:CGPointMake(0, self.bounds.size.height/2)];
        [diamond addLineToPoint:CGPointMake(self.bounds.size.width/2, self.bounds.size.height)];
        [diamond closePath];

        [diamond fill];
        [diamond stroke];
    }
}

@end
