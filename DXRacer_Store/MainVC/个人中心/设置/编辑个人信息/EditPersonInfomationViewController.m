//
//  EditPersonInfomationViewController.m
//  DXRacer_Store
//
//  Created by ilovedxracer on 2018/5/7.
//  Copyright © 2018年 ilovedxracer. All rights reserved.
//

#import "EditPersonInfomationViewController.h"

@interface EditPersonInfomationViewController ()<UITableViewDataSource,UITableViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    UIImageView *userImg;
    NSString *imgUrl;
    NSString *str1;
    NSString *str2;
    NSString *str3;
    NSString *str4;
}
@property(nonatomic,strong)UITableView *tableview;
@property(nonatomic,strong)NSMutableArray *arr;
@end

@implementation EditPersonInfomationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGBACOLOR(237, 236, 242, 1);
    
    self.arr = [@[@"用户名",@"昵称",@"性别",@"出生日期"]mutableCopy];
    
    str1 = [Manager redingwenjianming:@"phone.text"];
    
    [self setUpTableview];
    
}




- (void)getInfomation{
    __weak typeof(self) weakSelf = self;
    [Manager requestPOSTWithURLStr:KURLNSString(@"account") paramDic:nil token:nil finish:^(id responseObject) {
        NSDictionary *diction = [Manager returndictiondata:responseObject];
        //NSLog(@"----%@",diction);
        self->imgUrl = [diction objectForKey:@"iconUrl"];
        self->str2   = [diction objectForKey:@"nickName"];
        self->str3   = [diction objectForKey:@"sex"];
        self->str4   = [diction objectForKey:@"birthday"];
        
        [self->userImg sd_setImageWithURL:[NSURL URLWithString:[diction objectForKey:@"iconUrl"]]placeholderImage:[UIImage imageNamed:@"头像"]];
       
        [weakSelf.tableview reloadData];
    } enError:^(NSError *error) {
        NSLog(@"----%@",error);
    }];
}













- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    PInfoCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (indexPath.row == 0) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"用户名不可修改" message:@"温馨提示" preferredStyle:1];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }];
        [alert addAction:cancel];
        [self presentViewController:alert animated:YES completion:nil];
    }
    else  if (indexPath.row == 1) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"昵称" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        //增加确定按钮；
        [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            UITextField *TextField = alertController.textFields.firstObject;
            [Manager writewenjianming:@"nikname.text" content:TextField.text];
            NSDictionary *dic = @{@"nickName":TextField.text,
                                  };
            [Manager requestPOSTWithURLStr:KURLNSString(@"account/update") paramDic:dic token:nil finish:^(id responseObject) {
                NSDictionary *diction = [Manager returndictiondata:responseObject];
                //NSLog(@"----%@",diction);
                if ([[NSString stringWithFormat:@"%@",[diction objectForKey:@"code"]] isEqualToString:@"200"]){
                    cell.lab.text = TextField.text;
                    self->str2 = TextField.text;
                }
            } enError:^(NSError *error) {
                NSLog(@"%@",error);
            }];
        }]];
        //增加取消按钮；
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.text = cell.lab.text;
        }];
        
        [self presentViewController:alertController animated:true completion:nil];
    }
    else  if (indexPath.row == 2) {
        EasyAlertView *alertV = [EasyAlertView alertViewWithPart:^EasyAlertPart *{
            return [EasyAlertPart shared].setTitle(@"性别").setSubtitle(@"").setAlertType(AlertViewTypeActionSheet) ;
        } config:nil buttonArray:nil callback:^(EasyAlertView *showview, long index) {
            if (index == 0) {
                self->str3 = @"男";
            }
            if (index == 1) {
                self->str3 = @"女";
            }
            NSDictionary *dic = @{@"sex":self->str3,
                                  };
            [Manager requestPOSTWithURLStr:KURLNSString(@"account/update") paramDic:dic token:nil finish:^(id responseObject) {
                NSDictionary *diction = [Manager returndictiondata:responseObject];
                //NSLog(@"----%@",diction);
                if ([[NSString stringWithFormat:@"%@",[diction objectForKey:@"code"]] isEqualToString:@"200"]){
                     cell.lab.text = self->str3;
                }
            } enError:^(NSError *error) {
                NSLog(@"%@",error);
            }];
        }];
        [alertV addAlertItemWithTitleArray:@[@"男",@"女"] callback:nil];
        [alertV addAlertItem:^EasyAlertItem *{
            return [EasyAlertItem itemWithTitle:@"取消" type:AlertItemTypeBlodRed callback:^(EasyAlertView *showview, long index) {
            }];
        }];
        [alertV showAlertView];
    }
    else  if (indexPath.row == 3) {
        CZHWeakSelf(self);
        if (str4 == nil) {
            str4 = @"";
        }
        [CZHDatePickerView sharePickerViewWithCurrentDate:str4 DateBlock:^(NSString *dateString) {
            CZHStrongSelf(self);
            self->str4 = dateString;
            NSDictionary *dic = @{@"birthday":self->str4,
                                  };
            [Manager requestPOSTWithURLStr:KURLNSString(@"account/update") paramDic:dic token:nil finish:^(id responseObject) {
                NSDictionary *diction = [Manager returndictiondata:responseObject];
                //NSLog(@"----%@",diction);
                if ([[NSString stringWithFormat:@"%@",[diction objectForKey:@"code"]] isEqualToString:@"200"]){
                    cell.lab.text = self->str4;
                }
            } enError:^(NSError *error) {
                NSLog(@"%@",error);
            }];
        }];
        
    }
}
















- (void)setUpTableview{
    self.tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.backgroundColor = RGBACOLOR(237, 236, 242, 1);
    [self.tableview registerNib:[UINib nibWithNibName:@"PInfoCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:self.tableview];
    UIView *vv = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
    vv.backgroundColor = RGBACOLOR(237, 236, 242, 1);
    self.tableview.tableFooterView = vv;
    
    UIView *v = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 90)];
    v.backgroundColor = [UIColor whiteColor];
    self.tableview.tableHeaderView = v;
    
    UIView *lin = [[UIView alloc]initWithFrame:CGRectMake(0, 75, SCREEN_WIDTH, 10)];
    lin.backgroundColor = RGBACOLOR(237, 236, 242, 1);
    [v addSubview:lin];
    
    UILabel *labe = [[UILabel alloc]initWithFrame:CGRectMake(10, 25, 70, 30)];
    labe.text = @"头像";
    [v addSubview:labe];
    
    UIImageView *jiantou = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-25, 30, 20, 20)];
    jiantou.image = [UIImage imageNamed:@"箭头2"];
    [v addSubview:jiantou];
    
    userImg = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-85, 10, 60, 60)];
    LRViewBorderRadius(userImg, 30, 0, [UIColor clearColor]);
    userImg.backgroundColor = [UIColor grayColor];
    [v addSubview:userImg];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, SCREEN_WIDTH, 80);
    [btn addTarget:self action:@selector(cilckImg) forControlEvents:UIControlEventTouchUpInside];
    [v addSubview:btn];
    
    [self getInfomation];
}






- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.arr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifierCell = @"cell";
    PInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierCell];
    if (cell == nil) {
        cell = [[PInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifierCell];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.line.backgroundColor = RGBACOLOR(237, 236, 242, 1);
    cell.name.text = self.arr[indexPath.row];
    
    if (indexPath.row == 0) {
        cell.lab.text = [Manager redingwenjianming:@"phone.text"];
    }else if (indexPath.row == 1) {
        cell.lab.text = str2;
    }else if (indexPath.row == 2) {
        cell.lab.text = str3;
    }else if (indexPath.row == 3) {
        cell.lab.text = str4;
    }
    return cell;
}



- (void)cilckImg{
    [self selectedImage];
}


- (void)selectedImage{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"请选择图片获取路径" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *actionA = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self pickerPictureFromAlbum];
    }];
    UIAlertAction *actionB = [UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self pictureFromCamera];
    }];
    UIAlertAction *actionC = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
//    [actionA setValue:RGBACOLOR(32.0, 157.0, 149.0, 1.0) forKey:@"titleTextColor"];
//    [actionB setValue:RGBACOLOR(32.0, 157.0, 149.0, 1.0) forKey:@"titleTextColor"];
//    [actionC setValue:RGBACOLOR(32.0, 157.0, 149.0, 1.0) forKey:@"titleTextColor"];
    [alert addAction:actionA];
    [alert addAction:actionB];
    [alert addAction:actionC];
    [self presentViewController:alert animated:YES completion:nil];
    
    
}
//从手机相册选取图片功能
- (void)pickerPictureFromAlbum {
    //1.创建图片选择器对象
    UIImagePickerController *imagepicker = [[UIImagePickerController alloc]init];
    imagepicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagepicker.allowsEditing = YES;
    imagepicker.delegate = self;
    [self presentViewController:imagepicker animated:YES completion:nil];
}
//拍照--照相机是否可用
- (void)pictureFromCamera {
    //照相机是否可用
    BOOL isCamera = [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront];
    if (!isCamera) {
        //提示框
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"摄像头不可用" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
        return;//如果不存在摄像头，直接返回即可，不需要做调用相机拍照的操作；
    }
    //创建图片选择器对象
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
    //设置图片选择器选择图片途径
    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;//从照相机拍照选取
    //设置拍照时下方工具栏显示样式
    imagePicker.allowsEditing = YES;
    //设置代理对象
    imagePicker.delegate = self;
    //最后模态退出照相机即可
    [self presentViewController:imagePicker animated:YES completion:nil];
    
}
#pragma mark - UIImagePickerControllerDelegate
//当得到选中的图片或视频时触发的方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *imagesave = [info objectForKey:UIImagePickerControllerEditedImage];
    
    UIImageOrientation imageOrientation = imagesave.imageOrientation;
    if(imageOrientation!=UIImageOrientationUp)
    {
        // 原始图片可以根据照相时的角度来显示，但UIImage无法判定，于是出现获取的图片会向左转９０度的现象。
        // 以下为调整图片角度的部分
        UIGraphicsBeginImageContext(imagesave.size);
        [imagesave drawInRect:CGRectMake(0, 0, imagesave.size.width, imagesave.size.height)];
        imagesave = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        // 调整图片角度完毕
    }
    //userImg.image = imagesave;
    [self dismissViewControllerAnimated:YES completion:nil];
    
    [self imgurl:imagesave];
}
- (void)imgurl:(UIImage *)img{
    //__weak typeof(self) weakSelf = self;
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/json;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:[Manager redingwenjianming:@"token.text"] forHTTPHeaderField:@"token"];
    [manager.requestSerializer setValue:[Manager redingwenjianming:@"userid.text"] forHTTPHeaderField:@"loginUserId"];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html",@"image/jpeg",@"text/plain", nil];
    CGSize size = img.size;
    size.height = size.height/5;
    size.width  = size.width/5;
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [manager POST:KURLNSString(@"upload/upload?path=account") parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSData * data   =  UIImagePNGRepresentation(scaledImage);
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *str = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString stringWithFormat:@"%@.png", str];
        [formData appendPartWithFileData:data name:@"file" fileName:fileName mimeType:@"image/png"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *diction = [Manager returndictiondata:responseObject];
        //NSLog(@"%@",diction);
        if ([[NSString stringWithFormat:@"%@",[diction objectForKey:@"code"]] isEqualToString:@"200"]) {
            self->imgUrl = NSString([diction objectForKey:@"msg"]);
            [Manager writewenjianming:@"img.text" content:NSString([diction objectForKey:@"msg"])];
            
            
            NSDictionary *dic = @{@"iconUrl":self->imgUrl,
                                  };
            [Manager requestPOSTWithURLStr:KURLNSString(@"account/update") paramDic:dic token:nil finish:^(id responseObject) {
                NSDictionary *dictions = [Manager returndictiondata:responseObject];
                if ([[NSString stringWithFormat:@"%@",[dictions objectForKey:@"code"]] isEqualToString:@"200"]){
                     [self->userImg sd_setImageWithURL:[NSURL URLWithString:self->imgUrl]placeholderImage:[UIImage imageNamed:@"头像"]];
                }
                //NSLog(@"----%@",diction);
            } enError:^(NSError *error) {
                NSLog(@"%@",error);
            }];
            
            
        }else{
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"-----%@",error);
    }];
}















- (NSMutableArray *)arr{
    if (_arr == nil) {
        self.arr = [NSMutableArray arrayWithCapacity:1];
    }
    return _arr;
}
@end
