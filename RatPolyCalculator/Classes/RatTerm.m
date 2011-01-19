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
	coeff = [ZERO retain];
	expt = 0;
	
	[self checkRep];
	
	return self;
}

+(id)initNaN { // 5 points
  // EFFECTS: returns a nan ratterm
	RatNum *nan = [[RatNum alloc] initWithNumer:1 Denom:0];
	[nan autorelease];
	coeff = nan;
	expt = 1;
}

-(BOOL)isNaN { // 5 points
  // REQUIRES: self != nil
  // EFFECTS: return YES if and only if coeff is NaN
	if (coeff.denom == 0) {
		return NO;
	}
	else {
		return YES;
	}
}

-(BOOL)isZero { // 5 points
  // REQUIRES: self != nil
  // EFFECTS: return YES if and only if coeff is zero
	if (coeff.numer == 0 && coeff.denom != 0) {
		return YES;
	}
	return NO;
}


// Returns the value of this RatTerm, evaluated at d.
-(double)eval:(double)d { // 5 points
  // REQUIRES: self != nil
  // EFFECTS: return the value of this polynomial when evaluated at
  //            'd'. For example, "3*x^2" evaluated at 2 is 12. if 
  //            [self isNaN] returns YES, return NaN

	if ([self isNaN]) {
		return [RatTerm initNaN];
	}
	
	RatNum *r = [[RatNum alloc] initWithNumer:pow(d, expt) Denom:1.0];
	[r autorelease];
	return [coeff mul:r];
}

-(RatTerm*)negate{ // 5 points
  // REQUIRES: self != nil 
  // EFFECTS: return the negated term, return NaN if the term is NaN

	if (self isNaN) {
		return [RatTerm initNaN];
	}
	RatNum *coeff_negate = [[RatNum alloc] initWithNumer:((-1)*coeff.numer) Denom:coeff.denom];
	[coeff_negate autorelease];
	RatTerm *negated = [[RatTerm alloc] initWithCoeff:coeff_negate Exp:expt];
	return negated;
}



// Addition operation.
-(RatTerm*)add:(RatTerm*)arg { // 5 points
  // REQUIRES: (arg != null) && (self != nil) && ((self.expt == arg.expt) || (self.isZero() ||
  //            arg.isZero() || self.isNaN() || arg.isNaN())).
  // EFFECTS: returns a RatTerm equals to (self + arg). If either argument is NaN, then returns NaN.
  //            throws NSException if (self.expt != arg.expt) and neither argument is zero or NaN.

	if (arg==nil && self == nil && ((self.expt != arg.expt) && !self.isZero() && !arg.isZero() && [self isNaN()] && [arg isNaN()]))
	{
		return [RatTerm initNaN];
	}
	
	RatNum *coeff_added = [RatNum alloc autorelease]; 
	coeff_added = [[self coeff] add: [arg coeff]];
	RatTerm *add = [[RatTerm alloc] initWithCoeff:coeff_added Exp:[self expt]];
	return add;
}


// Subtraction operation.
-(RatTerm*)sub:(RatTerm*)arg { // 5 points
  // REQUIRES: (arg != nil) && (self != nil) && ((self.expt == arg.expt) || (self.isZero() ||
  //             arg.isZero() || self.isNaN() || arg.isNaN())).
  // EFFECTS: returns a RatTerm equals to (self - arg). If either argument is NaN, then returns NaN.
  //            throws NSException if (self.expt != arg.expt) and neither argument is zero or NaN.

	if (arg==nil && self == nil && ((self.expt != arg.expt) && !self.isZero() && !arg.isZero() && [self isNaN()] && [arg isNaN()]))
	{
		return [RatTerm initNaN];
	}
	
	RatNum *coeff_subtracted = [RatNum alloc autorelease];
	coeff_subtracted = [[self coeff] sub:[arg coeff]];
	RatTerm *sub = [[RatTerm alloc] initWithCoeff:coeff_subtracted Exp: expt];
	return sub;
}


// Multiplication operation
-(RatTerm*)mul:(RatTerm*)arg { // 5 points
  // REQUIRES: arg != null, self != nil
  // EFFECTS: return a RatTerm equals to (self*arg). If either argument is NaN, then return NaN

	if(arg!=null && self!=nil && ([self isNaN()] || [arg isNaN()])
	{
		return [RatTerm initNaN];
	}
	
	   RatNum *coeff_mult = [RatNum alloc autorelease];
	   coeff_mult = [[self coeff] mul:[arg coeff]];
	RatTerm *mul = [[RatTerm alloc] initWithCoeff:coeff_mult Exp:[self expt] + [arg expt]];
	return mul;
}


// Division operation
-(RatTerm*)div:(RatTerm*)arg { // 5 points
  // REQUIRES: arg != null, self != nil
  // EFFECTS: return a RatTerm equals to (self/arg). If either argument is NaN, then return NaN
	if(arg!=null && self!=nil && ![self isNaN()] && ![arg isNaN()])
	   {
		   return [RatTerm initNaN];
	   }
	   RatNum *coeff_div = [[self coeff] div:[arg coeff]];
	   RatTerm *div = [[RatTerm alloc] initWithCoeff:coeff_mult Exp:[self expt] - [arg expt]];
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
	if(self==nil) return nil;
	if([self isZero()]) return @"0";
	if([self isNaN()]) return @"NaN";
	
	return [NSString stringWithFormat:@"%s*x^%d", [self coeff stringValue], [self expt]];
}

// Build a new RatTerm, given a descriptive string.
+(RatTerm*)valueOf:(NSString*)str { // 5 points
  // REQUIRES: that self != nil and "str" is an instance of
  //             NSString with no spaces that expresses
  //             RatTerm in the form defined in the stringValue method.
  //             Valid inputs include "0", "x", "-5/3*x^3", and "NaN"
  // EFFECTS: returns a RatTerm t such that [t stringValue] = str

	RatNum *c;
	if (self==nil) {
		return nil;
	}
	
	if([str isEqual:@"NaN"])
		return [RatTerm initNaN];
	else {
		NSArray *tokens =[str componentsSeparatedByString:@"*"];
		if ([tokens count] == 1) {
			int arg = [str intValue];
		}
		else
		{
			c = [RatNum valueOf:([tokens objectAtIndex:0])];
			NSArray *tokens2 = [[tokens objectAtIndex:1] componentsSeparatedByString:"^"];
			int e = [tokens2 objectAtIndex:1];
		}
		return [[RatTerm alloc] initWithCoeff:c Exp:e];
}

//  Equality test,
-(BOOL)isEqual:(id)obj { // 5 points
  // REQUIRES: self != nil
  // EFFECTS: returns YES if "obj" is an instance of RatTerm, which represents
  //            the same RatTerm as self.
	if(self==nil)
	{
		return self;
	}
	
	if([[self coeff] isEqual: [obj coeff] && [self expt] isEqual [obj expt]])
		return YES;
	else return NO;
}

// Deallocates this RatTerm object.
-(void)dealloc{
	[coeff release];
	[super dealloc];
}

@end
