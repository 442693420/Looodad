//
//  NetworkingObject.h
//  MapTestDemo
//
//  Created by 张浩 on 2016/11/3.
//  Copyright © 2016年 张浩. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#ifdef DEBUG
#define NetworkingLog(s, ... ) NSLog( @"[%@ in line %d] ===============>%@", [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__] )
#else
#define NetworkingLog(s, ... )
#endif

/**
 *  请求数据类型
 */
typedef NS_ENUM(NSUInteger, RequestType) {
    kRequestTypeJSON = 1, //    default
    kRequestTypePlainText  = 2 // text/html
};

/**
 *  响应数据类型
 */
typedef NS_ENUM(NSUInteger, ResponseType) {
    kResponseTypeJSON = 1, //    default
    kResponseTypeXML  = 2,
    kResponseTypeData = 3
};

/**
 *  网络状态
 */
typedef NS_ENUM(NSInteger, NetworkStatus) {
    kNetworkStatusUnknown          = -1,//未知网络
    kNetworkStatusNotReachable     = 0,//网络无连接
    kNetworkStatusReachableViaWWAN = 1,//2，3，4G网络
    kNetworkStatusReachableViaWiFi = 2,//WIFI网络
};

/**
 *	下载
 *
 *	@param bytesRead		已下载
 *	@param totalBytesRead	总
 */
typedef void (^DownloadProgressBlock)(int64_t bytesRead,
int64_t totalBytesRead);
typedef DownloadProgressBlock GetProgressBlock;
typedef DownloadProgressBlock PostProgressBlock;

/**
 *	上传
 *
 *	@param bytesWritten			已
 *	@param totalBytesWritten	总
 */
typedef void (^UploadProgressBlock)(int64_t bytesWritten,
int64_t totalBytesWritten);


@class NSURLSessionTask;
// 使用基类NSURLSessionTask，
typedef NSURLSessionTask URLSessionTask;
typedef void(^ResponseSuccess)(id response);
typedef void(^ResponseFail)(NSError *error);


@interface NetworkingObject : NSObject

/**
 *  开启或关闭接口打印信息
 *
 *  @param isDebug  default NO
 */
+ (void)enableInterfaceDebug:(BOOL)isDebug;


/**
 *	设置基础接口地址
 */
+ (void)updateBaseUrl:(NSString *)baseUrl;
+ (NSString *)baseUrl;

/**
 *	请求超时时间
 *
 *	@param timeout	   default  30
 */
+ (void)setTimeout:(NSTimeInterval)timeout;


#pragma mark - 缓存
/**
 *  开启缓存
 *
 *	@param isCacheGet	   default  YES
 *	@param isCachePost	   default  NO
 */
+ (void)cacheGetRequest:(BOOL)isCacheGet shoulCachePost:(BOOL)isCachePost;

/**
 *	当检查到网络异常时，是否从缓存提取数据。
 *
 *	@param isObtain	   default  NO
 */
+ (void)obtainDataFromLocalWhenNetworkAnomaly:(BOOL)isObtain;


/**
 *	获取缓存总大小/bytes
 */
+ (unsigned long long)totalCacheSize;

/**
 *	清除缓存
 */
+ (void)clearCaches;

#pragma mark - 请求配置
/**
 *  配置全局请求头
 *
 *  @param httpHeaders 参数
 */
+ (void)configCommonHttpHeaders:(NSDictionary *)httpHeaders;

/**
 *  配置请求格式
 *
 *  @param requestType 请求格式，   default  JSON
 *  @param responseType 响应格式，   default  JSON，
 *  @param shouldAutoEncode YES or NO,   default  NO，是否自动encode url
 *  @param shouldCallbackOnCancelRequest 当取消请求时，是否要回调，   default  YES
 */
+ (void)configRequestType:(RequestType)requestType
             responseType:(ResponseType)responseType
      shouldAutoEncodeUrl:(BOOL)shouldAutoEncode
  callbackOnCancelRequest:(BOOL)shouldCallbackOnCancelRequest;

/**
 *	取消某个请求。
 *	@param url		URL，可不包括baseurl
 */
+ (void)cancelRequestWithURL:(NSString *)url;

/**
 *	取消所有请求
 */
+ (void)cancelAllRequest;


#pragma mark - 请求
/**
 *  GET请求接口，若不指定baseurl，可传完整的url
 *
 *  @param url     接口地址（名）
 *  @param refreshCache 是否刷新缓存。由于请求成功也可能没有数据，对于业务失败，只能通过人为手动判断
 *  @param params  参数，可空
 *  @param success 成功
 *  @param fail    失败
 *
 *  @return 返回的对象中有可取消请求的API
 */
+ (URLSessionTask *)getWithUrl:(NSString *)url
                    refreshCache:(BOOL)refreshCache
                         success:(ResponseSuccess)success
                            fail:(ResponseFail)fail;
// 带params参数
+ (URLSessionTask *)getWithUrl:(NSString *)url
                    refreshCache:(BOOL)refreshCache
                          params:(NSDictionary *)params
                         success:(ResponseSuccess)success
                            fail:(ResponseFail)fail;
// 带进度回调
+ (URLSessionTask *)getWithUrl:(NSString *)url
                    refreshCache:(BOOL)refreshCache
                          params:(NSDictionary *)params
                        progress:(GetProgressBlock)progress
                         success:(ResponseSuccess)success
                            fail:(ResponseFail)fail;

/**
 *  POST请求接口
 *
 *  @param url     地址/名
 *  @param params  参数
 *  @param success 成功
 *  @param fail    失败
 *
 *  @return 返回的对象中有可取消请求的API
 */
+ (URLSessionTask *)postWithUrl:(NSString *)url
                     refreshCache:(BOOL)refreshCache
                           params:(NSDictionary *)params
                          success:(ResponseSuccess)success
                             fail:(ResponseFail)fail;
+ (URLSessionTask *)postWithUrl:(NSString *)url
                     refreshCache:(BOOL)refreshCache
                           params:(NSDictionary *)params
                         progress:(PostProgressBlock)progress
                          success:(ResponseSuccess)success
                             fail:(ResponseFail)fail;


/**
 *	图片上传接口，若不指定baseurl，可传完整的url
 *
 *	@param image			对象
 *	@param url				上传图片的接口路径，如/path/images/
 *	@param filename		给图片起一个名字，   default  当前日期时间,格式为"yyyyMMddHHmmss"，后缀为`jpg`
 *	@param name				与指定的图片相关联的名称，这是由后端写接口的人指定的，如imagefiles
 *	@param mimeType		   default  image/jpeg
 *	@param parameters	参数
 *	@param progress		上传进度
 *	@param success		上传成功回调
 *	@param fail				上传失败回调
 *
 *	@return 返回的对象中有可取消请求的API
 */
+ (URLSessionTask *)uploadWithImage:(UIImage *)image
                                  url:(NSString *)url
                             filename:(NSString *)filename
                                 name:(NSString *)name
                             mimeType:(NSString *)mimeType
                           parameters:(NSDictionary *)parameters
                             progress:(UploadProgressBlock)progress
                              success:(ResponseSuccess)success
                                 fail:(ResponseFail)fail;


/**
 *	上传文件
 *
 *	@param url				上传路径
 *	@param uploadingFile	本地路径
 *	@param progress			进度
 *	@param success		    成功回调
 *	@param fail				失败回调
 *
 *	@return
 */
+ (URLSessionTask *)uploadFileWithUrl:(NSString *)url
                          uploadingFile:(NSString *)uploadingFile
                               progress:(UploadProgressBlock)progress
                                success:(ResponseSuccess)success
                                   fail:(ResponseFail)fail;


/**
 *  下载文件
 *
 *  @param url           下载URL
 *  @param saveToPath    保存路径
 *  @param progressBlock 进度
 *  @param success       成功
 *  @param failure       失败
 */
+ (URLSessionTask *)downloadWithUrl:(NSString *)url
                           saveToPath:(NSString *)saveToPath
                             progress:(DownloadProgressBlock)progressBlock
                              success:(ResponseSuccess)success
                              failure:(ResponseFail)failure;

@end
