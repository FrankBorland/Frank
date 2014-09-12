//
//  UIButtonViewController.h
//  Controls
//
//  Created by bernhardr
//

#import <UIKit/UIKit.h>


@interface UIButtonViewController : UIViewController {

}

- (IBAction) buttonPressed:(UIButton *)sender;

@property (nonatomic,retain) IBOutlet UILabel *reportLabel;


@end
