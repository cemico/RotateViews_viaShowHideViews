//
//  ViewController.m
//  RotateViews
//
//  Created by Dave Rogers on 6/26/15.
//  Copyright (c) 2015 Cemico Inc. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, strong) IBOutlet UIView *     viewPortrait;
@property (nonatomic, strong) IBOutlet UIView *     viewLandscape;

// note: slightly staggered in vertical placement to emphasize orientation difference
@property (nonatomic, strong) IBOutlet UILabel *    lblPortraitTitle;
@property (nonatomic, strong) IBOutlet UILabel *    lblLandscapeTitle;

@property (nonatomic, assign) UIDeviceOrientation   orientation;

@end

@implementation ViewController

- (void)viewDidLoad
{
    // default handling
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    // default handling
    [super viewWillAppear:animated];

    // be sure to generate orientation changes
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];

    // listen in on changes
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didRotate:) name:@"UIDeviceOrientationDidChangeNotification"  object:nil];

    // default non-typical states
    _orientation = (UIDeviceOrientation)[[UIDevice currentDevice] orientation];
    if (_orientation == UIDeviceOrientationUnknown ||
        _orientation == UIDeviceOrientationFaceUp  ||
        _orientation == UIDeviceOrientationFaceDown )
    {
        _orientation = UIDeviceOrientationPortrait;
    }

    // save "new" orientation
    UIDeviceOrientation newOrientation = _orientation;

    // set "old" / "current" orientation state to the opposite orientation
    if (UIDeviceOrientationIsLandscape(newOrientation))
        _orientation = UIDeviceOrientationPortrait;
    else /* if (UIDeviceOrientationIsPortrait(newOrientation)) */
        _orientation = UIDeviceOrientationLandscapeLeft;

    // set first orientation
    [self syncOrientation:newOrientation];
}

- (void)viewDidDisappear:(BOOL)animated
{
    // default handling
    [super viewDidDisappear:animated];

    // stop generating the orientation changes
    [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];

    // stop listening
    [[NSNotificationCenter defaultCenter] removeObserver:self];

    // reset
    _orientation = UIDeviceOrientationUnknown;
}

-(void)didRotate:(NSNotification *)notification
{
    // notification center callback - get new orientation
    UIDeviceOrientation newOrientation = [[UIDevice currentDevice] orientation];

    // process
    [self syncOrientation:newOrientation];
}

- (void)syncOrientation:(UIDeviceOrientation)newOrientation
{
    // replaced with the prefersStatusBarHidden below
//    [UIApplication sharedApplication].statusBarHidden = YES;

    // skip non-typical states
    if (newOrientation != UIDeviceOrientationUnknown &&
        newOrientation != UIDeviceOrientationFaceUp  &&
        newOrientation != UIDeviceOrientationFaceDown )
    {
        // optimization if not forced
        if (_orientation != newOrientation)
        {
            NSLog(@"Orientation changed");

            // track change
            if (UIDeviceOrientationIsLandscape(newOrientation) && UIDeviceOrientationIsPortrait(_orientation))
            {
                NSLog(@"Landscape");

                // remove old view
                [self clearCurrentView];

                if (newOrientation == UIDeviceOrientationLandscapeLeft)
                    _lblLandscapeTitle.text = @"Landscape Left";
                else
                    _lblLandscapeTitle.text = @"Landscape Right";

                // set new view
//                [self.view insertSubview:_viewLandscape atIndex:0];
                _viewLandscape.hidden = NO;

                // sync any object states
            }
            else if (UIDeviceOrientationIsPortrait(newOrientation) && UIDeviceOrientationIsLandscape(_orientation))
            {
                NSLog(@"Portrait");

                // remove old view
                [self clearCurrentView];

                if (newOrientation == UIDeviceOrientationPortrait)
                    _lblPortraitTitle.text = @"Portrait Up";
                else
                    _lblPortraitTitle.text = @"Portrait Down";

                // set new view
//                [self.view insertSubview:_viewPortrait atIndex:0];
                _viewPortrait.hidden = NO;

                // sync any object states
            }
            
            // save new orientation
            _orientation = newOrientation;
        }
    }
}

- (void) clearCurrentView
{
    // should only ever have one view as sub-view, but, coded for the unexpected (i.e. no "else" clause)
//    if (_viewLandscape.superview)
//        [_viewLandscape removeFromSuperview];
//
//    if (_viewPortrait.superview)
//        [_viewPortrait removeFromSuperview];

    _viewLandscape.hidden = YES;
    _viewPortrait.hidden = YES;
}

// replaced with the supportedInterfaceOrientations below
//- (BOOL)shouldAutorotate
//{
//    return YES;
//}

- (NSUInteger)supportedInterfaceOrientations
{
    // default excludes Portrait Upside Down
    return UIInterfaceOrientationMaskAll;
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

@end
