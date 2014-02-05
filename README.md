al7::controls Library
==========

Welcome, dear GitHuber! Thanks for checking out this repo. I originally wrote this library a few years back, when I was starting to write iOS applications. It includes a variety of utilities and some custom controls. 

The sample project included here is a launchpad that lets you navigate through examples of the custom controls, and see them in action. I decided to publish it here, as some of you my find it useful. 
* * *
Here is a quick sample of some stuff you will find here:

### Utilities
The library includes some neat utility classes and categories that save a ton of time, especially when you code your UI. To use the utilities, simply import the *ALUtilities.h* header file. 

Here are some of the most common uses:

#### Color Utilities:
     // Get an RGB value color:
     UIColor *myColor = [UIColor rgbColorWithRed:0 green:51 blue:153 alpha:1.0];

#### Layout Utilites:
     UIView *testView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 50.0, 50.0)];
     // Move view:
     [testView moveToPosition:CGPointMake(50.0, 50.0)];
     
     // Move with animation:
     [testView moveToPosition:CGPointMake(50.0, 50.0) animated:YES duration:3.0];
     
     // Calculate a view's maximum bounds:
     CGRect maximumBounds = [testView getMaximumBounds];

     // Aligning and distributing views;
     [ALLayoutUtilities spaceSubviewsEvenlyIn:testView withDistance:5.0];
     [ALLayoutUtilities alignSubviewsLeftIn:testView];
     [ALLayoutUtilities alignSubviewsCenterIn:testView];

     // Animation:
     [ALLayoutUtilities bounceView:testView];
#### String Utilities:
     // Get special characters: ©, ¨, ª, ¹: 
     [NSString registeredMark];
     [NSString trademark];
     [NSString copyright];
     [NSString pi];

#### Image utilities:
     // Draw gradient rectangle image:
     UIImage *gradientImage = [ALImageUtilities getGradientRectangleImageWithSize:CGSizeMake(50.0, 50.0) startColor:[UIColor whiteColor] endColor:[UIColor blackColor]];

To find out more, feel free to check the header files and provided sample code. 

Have fun!