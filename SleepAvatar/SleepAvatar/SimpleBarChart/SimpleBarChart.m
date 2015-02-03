//
//  SimpleBarChart.m
//  YouLogReading
//
//  Created by Mohammed Islam on 9/18/13.
//  Copyright (c) 2013 KSI Technology, LLC. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the "Software"), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.

#import "SimpleBarChart.h"

@interface SimpleBarChart ()

@end

@implementation SimpleBarChart

@synthesize
delegate	= _delegate,
dataSource	= _dataSource;

- (id)initWithFrame:(CGRect)frame
{
    NSLog(@"3");
    if (!(self = [super initWithFrame:frame]))
        return self;
    NSLog(@"4");
	self.animationDuration	= 1.0;
	self.barWidth			= 20.0;
	self.barAlpha			= 1.0;
    NSLog(@"barW : %f",self.barWidth);
    
	_barPathLayers			= [[NSMutableArray alloc] init];
	_barHeights				= [[NSMutableArray alloc] init];
	
	// Grid
	_gridLayer				= [CALayer layer];
	[self.layer addSublayer:_gridLayer];
    
	_barLayer				= [CALayer layer];
	[self.layer addSublayer:_barLayer];
    NSLog(@"5");
    return self;
}

- (void)reloadData
{
	if (_dataSource)
	{
        NSLog(@"barWidth : %f", self.barWidth);
		// Collect some data
		_numberOfBars = [_dataSource numberOfBarsInBarChart:self];
		[_barHeights removeAllObjects];
		[_barLabels removeAllObjects];
		
		for (NSInteger i = 0; i < _numberOfBars; i++)
		{
			[_barHeights addObject:[NSNumber numberWithFloat:[_dataSource barChart:self valueForBarAtIndex:i]]];
		}
		
		_maxHeight		= [_barHeights valueForKeyPath:@"@max.self"];
		_minHeight		= [_barHeights valueForKeyPath:@"@min.self"];
		
		// Round up to the next increment value
        _topValue		= _maxHeight.integerValue;
        
		_gridLayer.frame		= CGRectMake(0,
											 0,
											 self.bounds.size.width,
											 self.bounds.size.height);
		_barLayer.frame			= _gridLayer.frame;
        
        
		@autoreleasepool {
			[self setupBars];
			[self animateBarAtIndex:0];
		}
        
	}
}


#pragma mark Bars

- (void)setupBars
{
	// Clear all bars for each drawing
	for (CAShapeLayer *layer in _barPathLayers)
	{
		if (layer != nil)
		{
			[layer removeFromSuperlayer];
		}
	}
	[_barPathLayers removeAllObjects];
    
	CGFloat barHeightRatio	= _barLayer.bounds.size.height / (CGFloat)_topValue;
	CGFloat	xPos			= _barLayer.bounds.size.width / (_numberOfBars + 1);
	for (NSInteger i = 0; i < _numberOfBars; i++)
	{
        xPos = (self.barWidth*i)+(self.barWidth/2);
        NSLog(@"xPos : %f",xPos);
		CGPoint bottom					= CGPointMake(xPos, _barLayer.bounds.origin.y);
		CGPoint top						= CGPointMake(xPos, ((NSNumber *)[_barHeights objectAtIndex:i]).floatValue * barHeightRatio);
        //		xPos							+= _barLayer.bounds.size.width / (_numberOfBars + 1);
        
		UIBezierPath *path				= [UIBezierPath bezierPath];
		[path moveToPoint:bottom];
		[path addLineToPoint:top];
        
		UIColor *barColor				= [UIColor darkGrayColor];
		if (_dataSource && [_dataSource respondsToSelector:@selector(barChart:colorForBarAtIndex:)])
			barColor = [_dataSource barChart:self colorForBarAtIndex:i];
        
		CAShapeLayer *barPathLayer		= [CAShapeLayer layer];
		barPathLayer.frame				= _barLayer.bounds;
		barPathLayer.bounds				= _barLayer.bounds;
		barPathLayer.geometryFlipped	= YES;
		barPathLayer.path				= path.CGPath;
		barPathLayer.strokeColor		= [barColor colorWithAlphaComponent:self.self.barAlpha].CGColor;
		barPathLayer.fillColor			= nil;
		barPathLayer.lineWidth			= self.barWidth;
		barPathLayer.lineJoin			= kCALineJoinBevel;
		barPathLayer.hidden				= YES;
        
		[_barLayer addSublayer:barPathLayer];
		[_barPathLayers addObject:barPathLayer];
        
	}
}

- (void)animateBarAtIndex:(NSInteger)index
{
	if (index >= _barPathLayers.count)
	{
		return;
	}
    
	__block NSInteger i				= index + 1;
	__weak SimpleBarChart *weakSelf = self;
	[CATransaction begin];
	[CATransaction setAnimationDuration:(self.animationDuration / (CGFloat)_barPathLayers.count)];
	[CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
	[CATransaction setCompletionBlock:^{
		[weakSelf animateBarAtIndex:i];
	}];
    
	CAShapeLayer *barPathLayer		= [_barPathLayers objectAtIndex:index];
	barPathLayer.hidden				= NO;
	[self drawBar:barPathLayer];
    
	[CATransaction commit];
}

- (void)drawBar:(CAShapeLayer *)barPathLayer
{
	if (self.animationDuration == 0.0)
		return;
	
	[barPathLayer removeAllAnimations];
    
	CABasicAnimation *pathAnimation	= [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
	pathAnimation.fromValue			= [NSNumber numberWithFloat:0.0f];
	pathAnimation.toValue			= [NSNumber numberWithFloat:1.0f];
	[barPathLayer addAnimation:pathAnimation forKey:@"strokeEnd"];
}


@end
