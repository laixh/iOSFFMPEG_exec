//
//  ViewController.m
//  FFmpeg命令行
//
//  Created by qinmin on 2017/3/27.
//  Copyright © 2017年 qinmin. All rights reserved.
//

#import "ViewController.h"

#define DocumentDir [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]
#define BundlePath(res) [[NSBundle mainBundle] pathForResource:res ofType:nil]
#define DocumentPath(res) [DocumentDir stringByAppendingPathComponent:res]

extern int ffmpeg_exec(int argc, char * argv[]);

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - Events
- (IBAction)sliceBtnClick:(UIButton *)sender
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        char *movie = (char *)[BundlePath(@"1.mp4") UTF8String];
        char *outPic = (char *)[DocumentPath(@"%05d.jpg") UTF8String];
        char* a[] = {
            "ffmpeg",
            "-i",
            movie,
            "-r",
            "10",
            outPic
        };
        ffmpeg_exec(sizeof(a)/sizeof(*a), a);
    });
}

- (IBAction)composeBtnClick:(UIButton *)sender
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        char *outPic = (char *)[DocumentPath(@"%05d.jpg") UTF8String];
        char *movie = (char *)[DocumentPath(@"1.mp4") UTF8String];
        char* a[] = {
            "ffmpeg",
            "-i",
            outPic,
            "-vcodec",
            "mpeg4",
            movie
        };
        ffmpeg_exec(sizeof(a)/sizeof(*a), a);
    });
}

- (IBAction)transBtnClick:(UIButton *)sender
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        char *outPic = (char *)[DocumentPath(@"transcodeout.mp4") UTF8String];
        char *movie = (char *)[BundlePath(@"1.mp4") UTF8String];
        char* a[] = {
            "ffmpeg",
            "-i",
            movie,
            "-vcodec",
            "libx264",
            "-acodec",
            "aac",
            "-y",
            outPic
        };
        ffmpeg_exec(sizeof(a)/sizeof(*a), a);
    });
}

- (IBAction)logoBtnClick:(UIButton *)sender
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        char *outPic = (char *)[DocumentPath(@"logo.mp4") UTF8String];
        char *movie = (char *)[BundlePath(@"1.mp4") UTF8String];
        char logo[1024];
        // 左上
        sprintf(logo, "movie=%s [logo]; [in][logo] overlay=30:10 [out]", [BundlePath(@"ff.jpg") UTF8String]);
        
        // 左下
        //sprintf(logo, "movie=%s [logo]; [in][logo] overlay=30:main_h-overlay_h-10 [out]", [BundlePath(@"ff.jpg") UTF8String]);
        
        // 右下
        //sprintf(logo, "movie=%s [logo]; [in][logo] overlay=main_w-overlay_w-10:main_h-overlay_h-10 [out]", [BundlePath(@"ff.jpg") UTF8String]);
        
        // 右上
        //sprintf(logo, "movie=%s [logo]; [in][logo] overlay=main_w-overlay_w-10:10 [out]", [BundlePath(@"ff.jpg") UTF8String]);
        
        char* a[] = {
            "ffmpeg",
            "-i",
            movie,
            "-vf",
            logo,
            outPic
        };
        ffmpeg_exec(sizeof(a)/sizeof(*a), a);
    });
}

- (IBAction)filterBtnClick:(id)sender
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        char *outPic = (char *)[DocumentPath(@"filter.mp4") UTF8String];
        char *movie = (char *)[BundlePath(@"1.mp4") UTF8String];
        // 画格子
        //char *filter = "drawgrid=w=iw/3:h=ih/3:t=2:c=white@0.5";
        
        // 画矩形
         char *filter = "drawbox=x=10:y=20:w=200:h=60:color=red@0.5";
        
        // 裁剪
        //char *filter = "crop=in_w/2:in_h/2:(in_w-out_w)/2+((in_w-out_w)/2)*sin(n/10):(in_h-out_h)/2 +((in_h-out_h)/2)*sin(n/7)";
        
        char* a[] = {
            "ffmpeg",
            "-i",
            movie,
            "-vf",
            filter,
            outPic
        };
        ffmpeg_exec(sizeof(a)/sizeof(*a), a);
    });
}


@end
