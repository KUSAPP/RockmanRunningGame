//
//  HelloWorldLayer.h
//  RockManRunningGame
//
//  Created by Chanon Khamronyutha on 1/20/13.
//  Copyright Chanon Khamronyutha 2013. All rights reserved.
//


#import <GameKit/GameKit.h>

// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"

// HelloWorldLayer
@interface HelloWorldLayer : CCLayer <GKAchievementViewControllerDelegate, GKLeaderboardViewControllerDelegate>
{
    CCSprite *_rockman;
    CCAction *_runAction;
    CCAction *_jumpAction;
    CCAction *_dashAction;
    CCAction *_attackAction;
    BOOL isJumping;
    BOOL isDashing;
    BOOL isAttacking;
    float   yVel;
}

@property (nonatomic,retain) CCSprite *rockman;
@property (nonatomic,retain) CCAction *runAction;
@property (nonatomic,retain) CCAction *jumpAction;
@property (nonatomic,retain) CCAction *dashAction;
@property (nonatomic,retain) CCAction *attackAction;

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;

@end
