#import "GHCommit.h"
#import "GHUser.h"
#import "GHRepository.h"
#import "GHRepoComments.h"
#import "iOctocat.h"
#import "NSURL+Extensions.h"
#import "NSDictionary+Extensions.h"


@implementation GHCommit

- (id)initWithRepository:(GHRepository *)repo andCommitID:(NSString *)commitID {
	self = [super init];
	if (self) {
		self.repository = repo;
		self.commitID = commitID;
		self.resourcePath = [NSString stringWithFormat:kRepoCommitFormat, self.repository.owner, self.repository.name, self.commitID];
		self.comments = [[GHRepoComments alloc] initWithRepo:self.repository andCommitID:self.commitID];
	}
	return self;
}

- (void)setValues:(id)dict {
	NSString *authorLogin = [dict safeStringForKeyPath:@"author.login"];
	NSString *committerLogin = [dict safeStringForKeyPath:@"committer.login"];
	NSString *authorDateString = [dict safeStringForKeyPath:@"commit.author.date"];
	NSString *committerDateString = [dict safeStringForKeyPath:@"commit.committer.date"];
	self.author = [[iOctocat sharedInstance] userWithLogin:authorLogin];
	self.committer = [[iOctocat sharedInstance] userWithLogin:committerLogin];
	self.authoredDate = [iOctocat parseDate:authorDateString];
	self.committedDate = [iOctocat parseDate:committerDateString];
	self.message = [dict safeStringForKeyPath:@"commit.message"];
	// Files
	self.added = [NSMutableArray array];
	self.modified = [NSMutableArray array];
	self.removed = [NSMutableArray array];
	NSArray *files = [dict safeArrayForKey:@"files"];
	for (NSDictionary *file in files) {
		NSString *status = [file safeStringForKey:@"status"];
		if ([status isEqualToString:@"removed"]) {
			[self.removed addObject:file];
		} else if ([status isEqualToString:@"added"]) {
			[self.added addObject:file];
		} else {
			[self.modified addObject:file];
		}
	}
}

@end
