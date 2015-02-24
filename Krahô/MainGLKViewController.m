//
//  MainGLKViewController.m
//  Krahô
//
//  Created by Victor Moreira Barbosa on 2/12/15.
//  Copyright (c) 2015 VicSoft Sistemas. All rights reserved.
//

#import "MainGLKViewController.h"

@interface MainGLKViewController(){
    float _curRed;
    BOOL _increasing;
    
    GLuint _vertexBuffer;
    GLuint _indexBuffer;
}

@property (strong, nonatomic) EAGLContext *context;
@property (strong, nonatomic) GLKBaseEffect *effect;

@end

@implementation MainGLKViewController

@synthesize effect = _effect;
@synthesize context = _context;

-(void)setupGL{
    [EAGLContext setCurrentContext:self.context];
    
    self.effect = [[GLKBaseEffect alloc] init];
    
    glGenBuffers(1, &_vertexBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer);
    glBufferData(GL_ARRAY_BUFFER, sizeof(Vertices), Vertices, GL_STATIC_DRAW);
    
    glGenBuffers(1, &_indexBuffer);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _indexBuffer);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(Indices), Indices, GL_STATIC_DRAW);
}

-(void) tearDownGL{
    [EAGLContext setCurrentContext:self.context];
    
    self.effect = nil;
    
    glDeleteBuffers(1, &_vertexBuffer);
    glDeleteBuffers(1, &_indexBuffer);
}

-(void) viewDidLoad{
    [super viewDidLoad];
    
    self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    
    if(!self.context){
        NSLog(@"Failed to create ES context");
    }
    
    GLKView *view = (GLKView *) self.view;
    
    view.context = self.context;
    [self setupGL];
}

-(void) viewDidUnload{
    [super viewDidUnload];
    
    [self tearDownGL];
}

-(void) didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    
    if([EAGLContext currentContext] == self.context){
        [EAGLContext setCurrentContext:nil];
    }
    self.context = nil;
}

#pragma mark - GLKViewDelegate

-(void) glkView:(GLKView *)view drawInRect:(CGRect)rect{
    glClearColor(_curRed, 124, 205, 1);
    glClear(GL_COLOR_BUFFER_BIT);
}

#pragma mark - GLKViewControllerDelegate

- (void)update{
    if(_increasing){
        _curRed += 1.0 * self.timeSinceLastUpdate;
    }else{
        _curRed -= 1.0 * self.timeSinceLastUpdate;
    }
    
    if(_curRed >= 24.0){
        _curRed = 24.0;
        _increasing = NO;
    }
    if(_curRed <= 0.0){
        _curRed = 0.0;
        _increasing = YES;
    }
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    NSLog(@"Início...");
    NSLog(@"   ");
    NSLog(@"timeSinceLastUpdate: %f", self.timeSinceLastUpdate);
    NSLog(@"timeSinceLastDraw: %f", self.timeSinceLastDraw);
    NSLog(@"timeSinceFirstResume: %f", self.timeSinceFirstResume);
    NSLog(@"timeSinceLastResume: %f", self.timeSinceLastResume);
    
    self.paused = !self.paused;
    
    NSLog(@"FIM...");
    NSLog(@"   ");
    NSLog(@"timeSinceLastUpdate: %f", self.timeSinceLastUpdate);
    NSLog(@"timeSinceLastDraw: %f", self.timeSinceLastDraw);
    NSLog(@"timeSinceFirstResume: %f", self.timeSinceFirstResume);
    NSLog(@"timeSinceLastResume: %f", self.timeSinceLastResume);
}

typedef struct {
    float Position[3];
    float Color[4];
} Vertex;

const Vertex Vertices[] = {
    {{1, -1, 0}, {1, 0, 0, 1}},
    {{1, 1, 0}, {0, 1, 0, 1}},
    {{-1, 1, 0}, {0, 0, 1, 1}},
    {{-1, -1, 0}, {0, 0, 0, 1}}
};

const GLubyte Indices[] = {
    0, 1, 2,
    2, 3, 0
};

@end
