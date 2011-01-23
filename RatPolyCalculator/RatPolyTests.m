//
//  RatPolyTests.m
//  RatPolyCalculator
//
//  Created by LittleApple on 1/11/11.
//  Copyright 2011 National University of Singapore. All rights reserved.
//

#import "RatPolyTests.h"

@implementation RatPolyTests
RatNum* num(int i) {
	return [[[RatNum alloc] initWithInteger:i] autorelease];
}

RatNum* num2(int i, int j) {
	return [[[RatNum alloc] initWithNumer:i Denom:j] autorelease];
}

RatTerm* term(int coeff, int expt) {
	return [[[RatTerm alloc] initWithCoeff:num(coeff) Exp:expt] autorelease];
}

RatTerm* term3(int numer, int denom, int expt) {
	return [[[RatTerm alloc] initWithCoeff:num2(numer, denom) Exp:expt] autorelease];
}

RatPoly* polyFromTerm(RatTerm *term) {
	return [[[RatPoly alloc] initWithTerm:term] autorelease];
}

-(void)setUp{
    nanNum = [[RatNum initNaN] retain];
    nanTerm = [[RatTerm alloc] initWithCoeff:nanNum Exp:3];
	nanPoly = [[RatPoly alloc] initWithTerm:nanTerm];
	
	zeroNum = [[RatNum initZERO] retain];
	zeroTerm = [[RatTerm alloc] initWithCoeff:zeroNum Exp:0];
	zeroPoly = [[RatPoly alloc] init];
}

-(void)tearDown{
	[nanNum release];
	[nanTerm release];
	[nanPoly release];
	
	[zeroNum release];
	[zeroTerm release];
	[zeroPoly release];
}

-(void)testisNaN{
	STAssertTrue([nanPoly isNaN], @"", @"");
	STAssertTrue([polyFromTerm(term3(1, 0, 1)) isNaN], @"", @"");
}

-(void)testGetTerm{
	NSArray *arr = [NSArray arrayWithObjects:term(4,3), term(5,2), nil];
	RatPoly *rp = [[RatPoly alloc] initWithTerms:arr];
	
	STAssertEqualObjects([rp getTerm:3], term(4,3), @"", @"");
	[rp release];
}

-(void)testNegate{
	
	RatPoly *rp1 = [[RatPoly alloc] initWithTerms:[NSArray arrayWithObjects:term(13, 3), term(3, 2), nil]];
	RatPoly *rp2 = [[RatPoly alloc] initWithTerms:[NSArray arrayWithObjects:term(-13, 3), term(-3, 2), nil]];
	STAssertEqualObjects([rp1 negate], rp2, @"", @"");
	[rp1 release];
	[rp2 release];	
}

-(void)testAdd{
	RatPoly *rp = polyFromTerm(term(3, 2)); 
	STAssertEqualObjects([rp add:rp], polyFromTerm(term(6, 2)), @"", @"");	
}

-(void)testSub{
	RatPoly *rp = polyFromTerm(term(4,3));
	RatPoly *rp2 = polyFromTerm(term(2,3));
	STAssertEqualObjects([rp sub: rp2], polyFromTerm(term(2,3)), @"", @"");
}

-(void)testMul{
	RatPoly *rp1 = polyFromTerm(term(4,3));
	RatPoly *rp2 = polyFromTerm(term(3,2));
	STAssertEqualObjects([rp1 mul:rp2], polyFromTerm(term(12, 5)), @"", @"");
}

-(void)testDiv{
	RatPoly *rp1 = polyFromTerm(term(10,3));
	RatPoly *rp2 = polyFromTerm(term(5,2));
	STAssertEqualObjects([rp1 div:rp2], polyFromTerm(term(2,1)), @"", @"");
}

-(void)testEval{
	RatPoly *p = [[RatPoly alloc] initWithTerms:[NSArray arrayWithObjects:term(20,3), term(10,2), nil]];
	STAssertEqualsWithAccuracy([p eval:10], 21000.0, 0.000001, @"", @"");
}

@end