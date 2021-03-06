#import "GHResource.h"
#import "GHUser.h"
#import "GHGist.h"
#import "GHGistComments.h"
#import "iOctocat.h"
#import "NSURL+Extensions.h"
#import "NSString+Extensions.h"
#import "NSDictionary+Extensions.h"


@implementation GHGist

- (id)initWithId:(NSString *)gistId {
	self = [super init];
	if (self) {
		self.gistId = gistId;
		self.resourcePath = [NSString stringWithFormat:kGistFormat, gistId];
		self.comments = [[GHGistComments alloc] initWithGist:self];
	}
	return self;
}

- (NSString *)title {
	return ([self.descriptionText isEmpty] && self.files.count > 0) ? [self.files allKeys][0] : self.descriptionText;
}

- (GHUser *)user {
	return [[iOctocat sharedInstance] userWithLogin:self.userLogin];
}

#pragma mark Loading

- (void)setValues:(id)dict {
	self.gistId = [dict safeStringForKey:@"id"];
	self.files = [dict safeDictForKey:@"files"];
	self.htmlURL = [dict safeURLForKey:@"html_url"];
	self.userLogin = [dict safeStringForKeyPath:@"user.login"];
	self.descriptionText = [dict safeStringForKey:@"description"];
	self.isPrivate = ![dict safeBoolForKey:@"public"];
	self.forksCount = [dict safeArrayForKey:@"forks"].count;
	self.commentsCount = [dict safeIntegerForKey:@"comments"];
	self.createdAtDate = [iOctocat parseDate:[dict safeStringForKey:@"created_at"]];
}

@end
