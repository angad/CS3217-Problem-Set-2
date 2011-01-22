#import "RatTerm.h"


@implementation RatTerm

@synthesize coeff;
@synthesize expt;

// Checks that the representation invariant holds.
-(void) checkRep{ // 5 points
  // You need to fill in the implementation of this method
  
  if (coeff == nil) {
    [NSException raise:@"ratterm representation error" format:@"coefficient is nil"];
  }
  if ([coeff isEqual:[RatNum initZERO]] && expt != 0) {
    [NSException raise:@"ratterm representation error" format:@"coeff is zero but expt is not"];
  }
}
          
-(id)initWithCoeff:(RatNum*)c Exp:(int)e{
  // REQUIRES: (c, e) is a valid RatTerm
  // EFFECTS: returns a RatTerm with coefficient c and exponent e
 
  RatNum *ZERO = [RatNum initZERO];
  // if coefficient is 0, exponent must also be 0
  // we'd like to keep the coefficient, so we must retain it

  if ([c isEqual:ZERO]) {
    coeff = [ZERO retain];
    expt = 0;
  } else {
    coeff = [c retain];
    expt = e;
  }
  [self checkRep];
  return self;
}

+(id)initZERO { // 5 points
  // EFFECTS: returns a zero ratterm
	RatNum *ZERO = [RatNum initZERO];
	RatTerm *Z = [[[RatTerm alloc]initWithCoeff:ZERO Exp:0]autorelease];

	[Z checkRep];
	
	return Z;
}

+(id)initNaN { // 5 points
  // EFFECTS: returns a nan ratterm
	RatNum *nan = [[[RatNum alloc] initWithNumer:1 Denom:0]autorelease];	
	RatTerm *n = [[[RatTerm alloc] initWithCoeff:nan Exp:1]autorelease];
	
	[n checkRep];
	return n;
}

-(BOOL)isNaN { // 5 points
  // REQUIRES: self != nil
  // EFFECTS: return YES if and only if coeff is NaN
	if([coeff isNaN])
		return YES;
	else
		return NO;
}

-(BOOL)isZero { // 5 points
  // REQUIRES: self != nil
  // EFFECTS: return YES if and only if coeff is zero
	if (coeff.numer == 0 && coeff.denom != 0)
		return YES;
	return NO;
}


// Returns the value of this RatTerm, evaluated at d.
-(double)eval:(double)d { // 5 points
  // REQUIRES: self != nil
  // EFFECTS: return the value of this polynomial when evaluated at
  //            'd'. For example, "3*x^2" evaluated at 2 is 12. if 
  //            [self isNaN] returns YES, return NaN

	if ([self isNaN])
		return NAN;
	
	return (double)[coeff numer]/(double)[coeff denom] * (double)pow(d, expt);
}

-(RatTerm*)negate{ // 5 points
  // REQUIRES: self != nil 
  // EFFECTS: return the negated term, return NaN if the term is NaN

	if ([self isNaN]) 
		return [RatTerm initNaN];
	
	return [[RatTerm alloc]initWithCoeff:[[self coeff]negate] Exp:[self expt]];
}

// Addition operation.
-(RatTerm*)add:(RatTerm*)arg { // 5 points
  // REQUIRES: (arg != null) && (self != nil) && ((self.expt == arg.expt) || (self.isZero() ||
  //            arg.isZero() || self.isNaN() || arg.isNaN())).
  // EFFECTS: returns a RatTerm equals to (self + arg). If either argument is NaN, then returns NaN.
  //            throws NSException if (self.expt != arg.expt) and neither argument is zero or NaN.

	if ([self isNaN] || [arg isNaN]) {
		NSLog(@"isNaN");
		return [RatTerm initNaN];
	}
	else if([self isZero]) return arg;
	else if([arg isZero]) return self;
	else if (self.expt != arg.expt)
	{
		[NSException raise:@"different expenents" format:@"Argument exponents not equal"];
	}
	else
	{		return [[[RatTerm alloc] initWithCoeff:[[self coeff] add:[arg coeff]] Exp:[self expt]] autorelease];
	}
}

// Subtraction operation.
-(RatTerm*)sub:(RatTerm*)arg { // 5 points
  // REQUIRES: (arg != nil) && (self != nil) && ((self.expt == arg.expt) || (self.isZero() ||
  //             arg.isZero() || self.isNaN() || arg.isNaN())).
  // EFFECTS: returns a RatTerm equals to (self - arg). If either argument is NaN, then returns NaN.
  //            throws NSException if (self.expt != arg.expt) and neither argument is zero or NaN.

	return [self add:[arg negate]];
}


// Multiplication operation
-(RatTerm*)mul:(RatTerm*)arg { // 5 points
  // REQUIRES: arg != null, self != nil
  // EFFECTS: return a RatTerm equals to (self*arg). If either argument is NaN, then return NaN

	if(arg!=nil && self!=nil && [self isNaN] && [arg isNaN])
	{
		return [RatTerm initNaN];
	}
	
	RatTerm *mul = [[[RatTerm alloc] initWithCoeff:[[self coeff] mul:[arg coeff]] Exp:[self expt] + [arg expt]]autorelease];
	return mul;
}


// Division operation
-(RatTerm*)div:(RatTerm*)arg { // 5 points
  // REQUIRES: arg != null, self != nil
  // EFFECTS: return a RatTerm equals to (self/arg). If either argument is NaN, then return NaN
	if(arg!=nil && self!=nil && [self isNaN] && [arg isNaN])
	{
		return [RatTerm initNaN];
	}
	
	RatTerm *div = [[[RatTerm alloc] initWithCoeff:[[self coeff] div:[arg coeff]] Exp:[self expt] - [arg expt]]autorelease];
	return div;
}


// Returns a string representation of this RatTerm.
-(NSString*)stringValue { // 5 points
  //  REQUIRES: self != nil
  // EFFECTS: return A String representation of the expression represented by this.
  //           There is no whitespace in the returned string.
  //           If the term is itself zero, the returned string will just be "0".
  //           If this.isNaN(), then the returned string will be just "NaN"
  //		    
  //          The string for a non-zero, non-NaN RatTerm is in the form "C*x^E" where C
  //          is a valid string representation of a RatNum (see {@link ps1.RatNum}'s
  //          toString method) and E is an integer. UNLESS: (1) the exponent E is zero,
  //          in which case T takes the form "C" (2) the exponent E is one, in which
  //          case T takes the form "C*x" (3) the coefficient C is one, in which case T
  //          takes the form "x^E" or "x" (if E is one) or "1" (if E is zero).
  // 
  //          Valid example outputs include "3/2*x^2", "-1/2", "0", and "NaN".
	
	if (self == nil) {
		return nil;
	}
	if ([self isNaN]) {
		return @"NaN";
	}
	
	if ([self expt] == 0) {
		return [[self coeff] stringValue];
	}
	
	if ([[[self coeff]stringValue] isEqual:@"1"]) {
		if ([self expt]==1) {
			return [NSString stringWithFormat:@"x"];
		}
		else return [NSString stringWithFormat:@"x^%d", [self expt]];
	}
	if ([[[self coeff]stringValue] isEqual:@"-1"]) {
		if ([self expt]==1) {
			return [NSString stringWithFormat:@"-x"];
		}
		else return [NSString stringWithFormat:@"-x^%d", [self expt]];
	}
	if ([self expt]==1) {
		return [NSString stringWithFormat:@"%@*x", [[self coeff]stringValue]];
	}
	
	return 	[NSString stringWithFormat:@"%@*x^%d", [[self coeff]stringValue], [self expt]];
}

// Build a new RatTerm, given a descriptive string.
+(RatTerm*)valueOf:(NSString*)str { // 5 points
  // REQUIRES: that self != nil and "str" is an instance of
  //             NSString with no spaces that expresses
  //             RatTerm in the form defined in the stringValue method.
  //             Valid inputs include "0", "x", "-5/3*x^3", and "NaN"
  // EFFECTS: returns a RatTerm t such that [t stringValue] = str

	RatNum *c = [RatNum alloc];
	if (self==nil)
		return nil;
	if([str isEqual:@"NaN"])
		return [RatTerm initNaN];
	if ([str isEqual:@"0"])
		return [RatTerm initZERO];
	if ([str isEqual:@"x"])
		return [[RatTerm alloc] initWithCoeff: [[RatNum alloc] initWithInteger:1] Exp:1];
	if ([str isEqual:@"-x"])
		return [[RatTerm alloc] initWithCoeff: [[RatNum alloc] initWithInteger:-1] Exp:1];
	
	
	else {
		NSArray *tokens =[str componentsSeparatedByString:@"*"];
		if ([tokens count] == 1)
		{
			if ([[tokens objectAtIndex:0]rangeOfString:@"^"].location!=NSNotFound) {
				
				NSArray *tokens2 = [[tokens objectAtIndex:0] componentsSeparatedByString:@"^"];
				if ([[tokens2 objectAtIndex:0] rangeOfString:@"-"].location != NSNotFound) {
					return [[RatTerm alloc] initWithCoeff: [[RatNum alloc] initWithInteger:-1] Exp: [[tokens2 objectAtIndex:1]intValue] ];
				}
				else return [[RatTerm alloc] initWithCoeff: [[RatNum alloc]initWithInteger:1] Exp: [[tokens2 objectAtIndex:1]intValue]];
			}			
			return [[[RatTerm alloc] initWithCoeff:[RatNum valueOf:[tokens objectAtIndex:0]] Exp: 0] autorelease];
		}
		else
		{
			c = [RatNum valueOf:([tokens objectAtIndex:0])];
			NSArray *tokens2 = [[tokens objectAtIndex:1] componentsSeparatedByString:@"^"];
			if ([tokens2 count]==1) {
				return [[[RatTerm alloc] initWithCoeff:[RatNum valueOf:[tokens objectAtIndex:0]] Exp: 1] autorelease]; 
			}
			else {
				int e = [[tokens2 objectAtIndex:1]intValue];
				return [[RatTerm alloc] initWithCoeff:c Exp:e];
			}
		}
	}
}

//  Equality test,
-(BOOL)isEqual:(id)obj { // 5 points
  // REQUIRES: self != nil
  // EFFECTS: returns YES if "obj" is an instance of RatTerm, which represents
  //            the same RatTerm as self.
	
	if ([self isNaN] && [obj isNaN]) {
		return YES;
	}
	
	if(self==nil)
	{
		return nil;
	}
	
	if([[self coeff] isEqual: [obj coeff]] && [self expt] == [obj expt])
		return YES;
	else return NO;
}

// Deallocates this RatTerm object.
-(void)dealloc{
	[coeff release];
	[super dealloc];
}

@end
