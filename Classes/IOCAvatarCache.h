#import <Foundation/Foundation.h>


@interface IOCAvatarCache : NSObject

+ (UIImage *)cachedGravatarForIdentifier:(NSString *)string;
+ (void)cacheGravatar:(UIImage *)image forIdentifier:(NSString *)string;
+ (NSString *)gravatarPathForIdentifier:(NSString *)string;
+ (void)clearAvatarCache;

@end