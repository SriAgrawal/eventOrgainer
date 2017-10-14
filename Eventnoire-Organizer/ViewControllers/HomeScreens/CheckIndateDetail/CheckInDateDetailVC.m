//
//  CheckInDateDetailVC.m
//  Eventnoire-Organizer
//
//  Created by Aiman Akhtar on 11/04/17.
//  Copyright © 2017 com.mobiloitte. All rights reserved.
//

#import "CheckInDateDetailTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "CheckInDateDetailVC.h"
#import "CheckInDetailModal.h"
#import "QRCodeScannerVC.h"
#import "SettingVC.h"

static NSString *cellIdentifier = @"CheckInDateDetailTableViewCell";

@interface CheckInDateDetailVC ()<UITableViewDataSource,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *checkInDateDetailTableView;

@property (weak, nonatomic) IBOutlet UIImageView *scanImageView;

@end

@implementation CheckInDateDetailVC

#pragma mark - UIViewController LifeCycle & Memory Management

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initialSetup];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Helper MEthods

- (void)initialSetup {
    
    //dynamic row height
    self.checkInDateDetailTableView.estimatedRowHeight = 400;
    self.checkInDateDetailTableView.alwaysBounceVertical = NO;
    
    [self.scanImageView sd_setImageWithURL:[NSURL URLWithString:self.checkInDetail.codeScannerImageURL]];
}

#pragma mark - UITableView Delegate & Datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CheckInDateDetailTableViewCell *cell = (CheckInDateDetailTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    switch (indexPath.row) {
        case 0: {
            cell.titleLabel.text = @"Booking ID";
            cell.dataLabel.text = self.checkInDetail.bookID;
        }
            break;
        case 1: {
            cell.titleLabel.text = @"Registration Date";
            cell.dataLabel.text = self.checkInDetail.registrationDateString;
        }
            break;
        case 2: {
            cell.titleLabel.text = @"Total USD";
            cell.dataLabel.text = [NSString stringWithFormat:@"%@%@",self.checkInDetail.amountCurrency,self.checkInDetail.totalAmountInUSD];
        }
            break;
        case 3: {
            cell.titleLabel.text = @"Event Date & Time";
            cell.dataLabel.text = self.checkInDetail.eventStartDateString;
        }
            break;
        case 4: {
            cell.titleLabel.text = @"Event Registration Quantity";
            cell.dataLabel.text = self.checkInDetail.registrationQuantity;
        }
            break;
        default:
            break;
    }

    return cell;
}

#pragma mark - UIButton Action Methods

- (IBAction)backButtonAction:(id)sender {
    [self.view endEditing:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)barCodeScannerButtonAction:(id)sender {
    [self.view endEditing:YES];
    
    QRCodeScannerVC *codeScannerVC = [self.storyboard instantiateViewControllerWithIdentifier:@"QRCodeScannerVC"];
    [self.navigationController pushViewController:codeScannerVC animated:YES];

}


@end
