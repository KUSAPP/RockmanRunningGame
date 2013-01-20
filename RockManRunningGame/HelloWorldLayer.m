//
//  HelloWorldLayer.m
//  RockManRunningGame
//
//  Created by Chanon Khamronyutha on 1/20/13.
//  Copyright Chanon Khamronyutha 2013. All rights reserved.
//


// Import the interfaces
#import "HelloWorldLayer.h"

// Needed to obtain the Navigation Controller
#import "AppDelegate.h"

#pragma mark - HelloWorldLayer

// HelloWorldLayer implementation
@implementation HelloWorldLayer

@synthesize rockman = _rockman;
@synthesize runAction = _runAction;
@synthesize jumpAction = _jumpAction;
@synthesize dashAction = _dashAction;
@synthesize attackAction = _attackAction;

// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	HelloWorldLayer *layer = [HelloWorldLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super's" return value
	if( (self=[super init]) ) {
        isJumping = NO;
        yVel = 0;
        
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"rockman.plist"];
        CCSpriteBatchNode *spriteSheet = [CCSpriteBatchNode batchNodeWithFile:@"rockman.png"];
        
        [self addChild:spriteSheet];
        
        //add running frames
        NSMutableArray *runningFrames = [NSMutableArray array];
        for (int i = 1; i <= 15; i++) {
            [runningFrames addObject:
             [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:
              [NSString stringWithFormat:@"run%02d.png",i]]];
        }
        
        //add jumping frames
        NSMutableArray *jumpingFrames = [NSMutableArray array];
        for (int i = 1 ; i <= 11; i++) {
            [jumpingFrames addObject:
             [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:
              [NSString stringWithFormat:@"jump%02d.png",i]]];
        }
        
        //add dashing frames
        NSMutableArray *dashingFrames = [NSMutableArray array];
        for (int i = 1 ; i <= 3; i++) {
            [dashingFrames addObject:
             [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:
              [NSString stringWithFormat:@"dash%02d.png",i]]];
        }
        
        //add attacking frames
        NSMutableArray *attackingFrames = [NSMutableArray array];
        for (int i = 1 ; i <= 15; i++) {
            [attackingFrames addObject:
             [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:
              [NSString stringWithFormat:@"attack%02d.png",i]]];
        }
    
        CCAnimation *runAnim = [CCAnimation animationWithFrames:runningFrames delay:0.05f];
        CCAnimation *jumpAnim = [CCAnimation animationWithFrames:
                                 jumpingFrames delay:0.05f];
        CCAnimation *dashAnim = [CCAnimation animationWithFrames:dashingFrames delay:0.05f];
        CCAnimation *attackAnim = [CCAnimation animationWithFrames:attackingFrames delay:0.05f];
        
        
        
        self.rockman = [CCSprite spriteWithSpriteFrameName:@"stand.png"];
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        _rockman.position = ccp(winSize.width /2 , winSize.height/2);
        self.runAction = [CCRepeatForever actionWithAction:
                          [CCAnimate actionWithAnimation:runAnim restoreOriginalFrame:NO]];
        self.jumpAction = [CCSequence actions: [CCRepeat actionWithAction:
                           [CCAnimate actionWithAnimation:jumpAnim restoreOriginalFrame:NO] times:1],
                           [CCCallFuncN actionWithTarget:self selector:@selector(jumpEnded)],nil];
        self.dashAction = [CCSequence actions:[CCAnimate actionWithAnimation:dashAnim restoreOriginalFrame:NO],[CCCallFuncN actionWithTarget:self selector:@selector(dashEnded)],nil];
        self.attackAction = [CCSequence actions:[CCAnimate actionWithAnimation:attackAnim restoreOriginalFrame:NO],[CCCallFuncN actionWithTarget:self selector:@selector(attackEnded)],nil];
        
        
        
        
        [_rockman runAction:_runAction];
        [spriteSheet addChild:_rockman];
        
        [self setupGestureRecognizers];
        self.isTouchEnabled = YES;
        [self schedule:@selector(update:)];
	}
	return self;
}


-(void) setupGestureRecognizers
{
    UISwipeGestureRecognizer *swipeUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeUp)];
    [swipeUp setDirection:UISwipeGestureRecognizerDirectionUp];
    [swipeUp setNumberOfTouchesRequired:1];
    
    
    
    UISwipeGestureRecognizer *swipeDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeDown)];
    [swipeDown setDirection:UISwipeGestureRecognizerDirectionDown];
    [swipeDown setNumberOfTouchesRequired:1];

    [[[[CCDirector sharedDirector] openGLView] window] setUserInteractionEnabled:YES];
    [[[CCDirector sharedDirector] openGLView] setUserInteractionEnabled:YES];
    [[[CCDirector sharedDirector] openGLView] addGestureRecognizer:swipeUp];
    [[[CCDirector sharedDirector] openGLView] addGestureRecognizer:swipeDown];
}

-(void) swipeUp {
    NSLog(@"swipeUp");
    if(isJumping || isDashing || isAttacking) {
        return;
    }
    yVel = 3;
    [_rockman stopAllActions];
    [_rockman runAction:_jumpAction];
    isJumping = YES;
}

-(void) swipeDown {
    NSLog(@"swipeDown");
    if(isJumping || isDashing || isAttacking) {
        return;
    }
    [_rockman stopAllActions];
    [_rockman runAction:_dashAction];
    isDashing = YES;
}


-(void) update:(ccTime)dt {
    if (_rockman.position.y > [[CCDirector sharedDirector] winSize].height/2 && isJumping) {
        yVel -= 0.2;
    }
    else if (yVel!=3) {
        yVel = 0;
    }
    _rockman.position = ccp(_rockman.position.x, _rockman.position.y + yVel);
}


-(void) registerWithTouchDispatcher
{
    [[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0
                                              swallowsTouches:YES];
}

-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    return YES;
}

-(void) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
    NSLog(@"attack");
    if(isJumping || isDashing || isAttacking) {
        return;
    }
    [_rockman stopAllActions];
    [_rockman runAction:_attackAction];
    isAttacking = YES;
    return;
}

-(void) dashEnded {
    [_rockman stopAction:_dashAction];
    [_rockman runAction:_runAction];
    isDashing = NO;
}

-(void) jumpEnded {
    [_rockman stopAction:_jumpAction];
    [_rockman runAction:_runAction];
    isJumping = NO;
}

-(void) attackEnded {
    [_rockman stopAction:_attackAction];
    [_rockman runAction:_runAction];
    isAttacking = NO;
}
// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	[_rockman release];
    [_runAction release];
    [_jumpAction release];
    [_dashAction release];
    [_attackAction release];
	// don't forget to call "super dealloc"
	[super dealloc];
}

#pragma mark GameKit delegate

-(void) achievementViewControllerDidFinish:(GKAchievementViewController *)viewController
{
	AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
	[[app navController] dismissModalViewControllerAnimated:YES];
}

-(void) leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController
{
	AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
	[[app navController] dismissModalViewControllerAnimated:YES];
}
@end
