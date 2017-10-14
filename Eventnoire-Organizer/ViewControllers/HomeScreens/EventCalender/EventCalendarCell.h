//
//  EventCalendarCell.h
//  Eventnoire-Organizer
//
//  Created by Abhishek Agarwal on 16/05/17.
//  Copyright © 2017 com.mobiloitte. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EventCalendarCell : UITableViewCell

@property(nonatomic,retain)IBOutlet UILabel *eventTitleLabel;
@property(nonatomic,retain)IBOutlet UILabel *eventDateLabel;
@property(nonatomic,retain)IBOutlet UIImageView *eventImage;

@end
