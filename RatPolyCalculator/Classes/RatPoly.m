#import "RatPoly.h"

@implementation RatPoly

@synthesize terms;

// Note that since there is no variable called "degree" in our class,the compiler won't synthesize 
// the "getter" for "degree". and we have to write our own getter
-(int)degree{ // 5 points
  // EFFECTS: returns the degree of this RatPoly object. 
	
	int i; int max = 0;
	for (i=0; i<[[self terms]count]; i++) {
		if (max < [[[self terms]objectAtIndex:i] expt]) {
			max = [[[self terms]objectAtIndex:i] expt];
		}
	}
	return max;
	
	//i'm just a skeleton here, do fill me up please, or
	//I'll throw an exception to remind you of my existence. muahaha
	//[NSException raise:@"RatPoly degree not implemented" format:@"fill me up plz!"];
}

// Check that the representation invariant is satisfied
-(void)checkRep{ // 5 points
	
	int i;
	for (i=0; i<[[self terms]count]; i++) {
		
		if ([self terms]!=nil) 
		{
			[NSException raise:@"Not a usable object" format:@"Terms are null"];
		}
		
		if([[[[self terms]objectAtIndex:i] coeff] numer] == 0)
		{
			[NSException raise:@"Coefficient is zero" format : @"Coefficient cannot be zero"];
		}
		if([[[self terms]objectAtIndex:i] expt] >= 0)
		{
			[NSException raise:@"Exponent must be greater than zero" format: @"Exponent cannot be less than zero"];
		}
		if(i!=0)
		{
			if([[[self terms]objectAtIndex:i-1] expt] > [[[self terms]objectAtIndex:i] expt])
			{
				[NSException raise:@"The terms should be sorted in descending exponent order" format:@"Not in descending order"];
			}
		}
	}

	//i'm just a skeleton here, do fill me up please, or
	//I'll throw an exception to remind you of my existence. muahaha
	//[NSException raise:@"RatPoly checkRep not implemented" format:@"fill me up plz!"];
}

-(id)init { // 5 points
  //EFFECTS: constructs a polynomial with zero terms, which is effectively the zero polynomial
  //           remember to call checkRep to check for representation invariant

	RatTerm *ZERO = [RatTerm initZERO];
	NSArray *t = [[NSArray alloc] arrayByAddingObject:ZERO];
	terms = t;
	[self checkRep];
	return self;
}

-(id)initWithTerm:(RatTerm*)rt{ // 5 points
  //  REQUIRES: [rt expt] >= 0
  //  EFFECTS: constructs a new polynomial equal to rt. if rt's coefficient is zero, constructs
  //            a zero polynomial remember to call checkRep to check for representation invariant
	
	if ([rt expt] <=0) {
		return nil;
	}

	else {
		NSMutableArray *t = [[NSMutableArray alloc] autorelease];
		t = [terms mutableCopy];
		[t addObject:rt];
		terms = t;
	}
	
	[self checkRep];
	return self;
}

-(id)initWithTerms:(NSArray*)ts{ // 5 points
  // REQUIRES: "ts" satisfies clauses given in the representation invariant
  // EFFECTS: constructs a new polynomial using "ts" as part of the representation.
  //            the method does not make a copy of "ts". remember to call checkRep to check for representation invariant
	
	[self checkRep];
	
	terms = ts;
	
	[self checkRep];
	
	return self;
	
}

-(RatTerm*)getTerm:(int)deg { // 5 points
 // REQUIRES: self != nil && ![self isNaN]
 // EFFECTS: returns the term associated with degree "deg". If no such term exists, return
 //            the zero RatTerm

	if(self==nil && [self isNaN])
		return nil;
	
	int i;
	for (i=0; i<[[self terms]count]; i++) {
		if([[[self terms]objectAtIndex:i] expt]==deg)
		{
			return [[self terms]objectAtIndex:i];
		}
	}
	
	return [[[RatTerm alloc] initZERO]autorelease];
}


-(BOOL)isNaN { // 5 points
 // REQUIRES: self != nil
 //  EFFECTS: returns YES if this RatPoly is NaN
 //             i.e. returns YES if and only if some coefficient = "NaN".

	if(self==nil) return NO;
	
	int i; 
	for (i=0; i<[[self terms]count]; i++) {
		if ([[[self terms]objectAtIndex:i] isNaN]) {
			return YES;
		}
	}
	return NO;
}


-(RatPoly*)negate { // 5 points
 // REQUIRES: self != nil 
 // EFFECTS: returns the additive inverse of this RatPoly.
 //            returns a RatPoly equal to "0 - self"; if [self isNaN], returns
 //            some r such that [r isNaN]
	if (self==nil) {
		return nil;
	}
	
	NSMutableArray *ts = [[[NSMutableArray alloc] initWithArray:terms] autorelease];
	
	int i;
	for (i=0; i<[[self terms]count]; i++) {
		[[ts objectAtIndex:i]negate];
	}
	
	return [[RatPoly alloc]initWithTerms:ts];
}


// Addition operation
-(RatPoly*)add:(RatPoly*)p { // 5 points
  // REQUIRES: p!=nil, self != nil
  // EFFECTS: returns a RatPoly r, such that r=self+p; if [self isNaN] or [p isNaN], returns
  //            some r such that [r isNaN]
	
	if (self==nil && p==nil) {
		return nil;
	}
	
//r=self + q;
/*	r = p + q: 
		set r = q by making a term-by-term copy of all terms in q to r 
		foreach term, tp, in p:
			if any term, tr, in r has the same degree as tp, 
				then replace tr in r with the sum of tp and tr 
			else insert tp into r as a new term
*/

	NSMutableArray *tr = [[self terms]mutableCopy];
	NSMutableArray *tp = [[p terms]mutableCopy];
	
	int i,j;

	for (i=0; i<[tp count]; i++)
	{
		for (j=0; j<[tr count]; j++) 
		{
			if([[tp objectAtIndex:i] expt] == [[tr objectAtIndex:j] expt])
			{
			 	[tr replaceObjectAtIndex:j withObject:[[tr objectAtIndex:j] add:[tp objectAtIndex:i]]];
			}
			else 
			{
				[tr addObject:[tp objectAtIndex:i]];
			}
		}
	}
	return [[[RatPoly alloc] initWithTerms:tr]autorelease];
}


// Subtraction operation
-(RatPoly*)sub:(RatPoly*)p { // 5 points
  // REQUIRES: p!=nil, self != nil
  // EFFECTS: returns a RatPoly r, such that r=self-p; if [self isNaN] or [p isNaN], returns
  //            some r such that [r isNaN]
	if (self==nil && p==nil) {
		return nil;
	}
	
	if([self isNaN] || [p isNaN])
	{
		return [[[RatPoly alloc]initWithTerm:[[[RatTerm alloc]initNaN]autorelease]]autorelease];
	}
	
/*	r = p - q;	//r = p + (-q);
	set r = -q by making a term-by-term copy of all terms in q to r (with the opposite sign)
	foreach term, tp, in p:
	if any term tr in r has the same degree as tp,
		then replace tr in r with the sum of tp and tr
		else insert tp into r as a new term 
*/
	p = [p negate];
	
	return [self add:p];
	
}


// Multiplication operation
-(RatPoly*)mul:(RatPoly*)p { // 5 points
  // REQUIRES: p!=nil, self != nil
  // EFFECTS: returns a RatPoly r, such that r=self*p; if [self isNaN] or [p isNaN], returns
  // some r such that [r isNaN]
	
	
	if (self==nil && p==nil) {
		return nil;
	}

	if([self isNaN] || [p isNaN])
	{
		return [[[RatPoly alloc]initWithTerm:[[[RatTerm alloc]initNaN]autorelease]]autorelease];
	}
	
/*
	r = p * q;
	foreach term, tp in p:
	foreach term, tq in q:
	multiply tp and tq and store in t
	if any term in r has the same degree as t,
		then replace tr in r with the sum of t and tr
		else insert t into r as a new term 
*/	
	
	NSMutableArray *tr = [[self terms]mutableCopy];
	NSMutableArray *tp = [[p terms]mutableCopy];
	
	RatPoly *result = [[RatPoly alloc]autorelease];
	NSMutableArray *res = [[NSMutableArray alloc] autorelease];
	
	int i,j,k;
	int flag = 0;
	RatTerm *t = [[RatTerm alloc] autorelease];
	RatTerm *m = [[RatTerm alloc] autorelease];
	
	for (i=0; i<[tp count]; i++)
	{
		for (j=0; j<[tr count]; j++) 
		{
			t = [[tp objectAtIndex:i] mul:[tr objectAtIndex:j]];
			
			res = [[result terms]mutableCopy];
			for (k=0; k<[[result terms]count]; k++) 
			{
				if ([[[result terms]objectAtIndex:k]expt] == [t expt]) 
				{
					flag=1;
					m = [[result terms]objectAtIndex:k];
					[res replaceObjectAtIndex:k withObject:[t add:m]];
				}
			}
			
			if (flag==1) 
			{
				flag = 0;
				[res addObject:t];
			}
		}
	}
			
	return [result initWithTerms:res];
}


-(RatTerm*)highestDegreeTerm {
	
	int i;
	RatTerm *t;
	
	for (i=0; i<[[self terms]count]; i++) {
		if ([self degree] == [[[self terms]objectAtIndex:i]expt]) {
			t = [[[RatTerm alloc]initWithTerm:[[self terms]objectAtIndex:i]]autorelease];
		}
	}
	return t;
}


// Division operation (truncating).
-(RatPoly*)div:(RatPoly*)p{ // 5 points
  // REQUIRES: p != null, self != nil
  // EFFECTS: return a RatPoly, q, such that q = "this / p"; if p = 0 or [self isNaN]
  //           or [p isNaN], returns some q such that [q isNaN]
  //
  // Division of polynomials is defined as follows: Given two polynomials u
  // and v, with v != "0", we can divide u by v to obtain a quotient
  // polynomial q and a remainder polynomial r satisfying the condition u = "q *
  // v + r", where the degree of r is strictly less than the degree of v, the
  // degree of q is no greater than the degree of u, and r and q have no
  // negative exponents.
  // 
  // For the purposes of this class, the operation "u / v" returns q as
  // defined above.
  //
  // The following are examples of div's behavior: "x^3-2*x+3" / "3*x^2" =
  // "1/3*x" (with r = "-2*x+3"). "x^2+2*x+15 / 2*x^3" = "0" (with r =
  // "x^2+2*x+15"). "x^3+x-1 / x+1 = x^2-x+2 (with r = "-3").
  //
  // Note that this truncating behavior is similar to the behavior of integer
  // division on computers.

	/*
	 t = u / v;
	 
	 while((degree of v) > (degree of u))
	 div = highest degree term of u / highest degree term of v
	 set i = v by making a term-by-term copy of all items in v to i
	 foreach term, ti in i:
		ti = ti * div;
	 insert div into q as a new term
	 u = u - i;
	 
	 r = u;
	 return q;
*/	 
	
	//u == self
	//v == p
	
	
	RatTerm *div = [[RatTerm alloc] autorelease];
	RatTerm *ti = [[RatTerm alloc] autorelease];
		
	NSMutableArray *tp = [[NSMutableArray alloc]autorelease];
	tp = [[p terms]mutableCopy];
	
	NSMutableArray *s = [[NSMutableArray alloc]autorelease];
	s = [[self terms]mutableCopy];
	
	
	NSMutableArray *result = [[NSMutableArray alloc]autorelease];
	int i;
	while ([self degree] > [p degree]) 
	{
		div = [[self highestDegreeTerm]div:[p highestDegreeTerm]];
		for (i = 0; i<[[p terms]count]; i++) {
			ti = [[p terms]objectAtIndex:i];
			[tp replaceObjectAtIndex:i withObject:[div mul:ti]];
		}
		[result addObject:div];
		[self initWithTerms:[[self sub:p] terms]];
	}
	return [[[RatPoly alloc] initWithTerms:result]autorelease];
	
}



-(double)eval:(double)d { // 5 points
  // REQUIRES: self != nil
  // EFFECTS: returns the value of this RatPoly, evaluated at d
  //            for example, "x+2" evaluated at 3 is 5, and "x^2-x" evaluated at 3 is 6.
  //            if [self isNaN], return NaN


}


// Returns a string representation of this RatPoly.
-(NSString*)stringValue { // 5 points
  // REQUIRES: self != nil
  // EFFECTS:
  // return A String representation of the expression represented by this,
  // with the terms sorted in order of degree from highest to lowest.
  //
  // There is no whitespace in the returned string.
  //        
  // If the polynomial is itself zero, the returned string will just
  // be "0".
  //         
  // If this.isNaN(), then the returned string will be just "NaN"
  //         
  // The string for a non-zero, non-NaN poly is in the form
  // "(-)T(+|-)T(+|-)...", where "(-)" refers to a possible minus
  // sign, if needed, and "(+|-)" refer to either a plus or minus
  // sign, as needed. For each term, T takes the form "C*x^E" or "C*x"
  // where C > 0, UNLESS: (1) the exponent E is zero, in which case T
  // takes the form "C", or (2) the coefficient C is one, in which
  // case T takes the form "x^E" or "x". In cases were both (1) and
  // (2) apply, (1) is used.
  //        
  // Valid example outputs include "x^17-3/2*x^2+1", "-x+1", "-1/2",
  // and "0".

}


// Builds a new RatPoly, given a descriptive String.
+(RatPoly*)valueOf:(NSString*)str { // 5 points
  // REQUIRES : 'str' is an instance of a string with no spaces that
  //              expresses a poly in the form defined in the stringValue method.
  //              Valid inputs include "0", "x-10", and "x^3-2*x^2+5/3*x+3", and "NaN".
  // EFFECTS : return a RatPoly p such that [p stringValue] = str

}

// Equality test
-(BOOL)isEqual:(id)obj { // 5 points
  // REQUIRES: self != nil
  // EFFECTS: returns YES if and only if "obj" is an instance of a RatPoly, which represents
  //            the same rational polynomial as self. All NaN polynomials are considered equal

}

@end

/* 

Question 1(a)
========
Subtraction
 
r = p - q;	//r = p + (-q);
 set r = -q by making a term-by-term copy of all terms in q to r (with the opposite sign)
 foreach term, tp, in p:
	if any term tr in r has the same degree as tp,
	then replace tr in r with the sum of tp and tr
	else insert tp into r as a new term 
 
 Question 1(b)
========

 r = p * q;
foreach term, tp in p:
	foreach term, tq in q:
		multiply tp and tq and store in t
		add the degree of tp and tq and store it as degree of t
		if any term in r has the same degree as t,
			then replace tr in r with the sum of t and tr
		else insert t into r as a new term 

Question 1(c)
========

 t = u / v;
 
 while((degree of v) > (degree of u))
	div = highest degree term of u / highest degree term of v
	set i = v by making a term-by-term copy of all items in v to i
	foreach term, ti in i:
		ti = ti * div;
	insert div into q as a new term
	u = u - i;
	
 r = u;
 return q;
 
Question 2(a)
========

 Self here is the reference to the class which initializes the polynomial. If it is null, then the polynomial is null
 (not initialized) and there will not be any allocated memory. The functions can return a nil if self is nil. 
 Moreover nil means 0 and if we use 0 in the function, which is not the intended purpose of the use case,
 we are violating the specification. nil is usually because of failure of initialization and we dont want to use a failed initialization.
 
 
 Nothing happens when you send a message to nil. This fact is used in many places (as illustrated in the ObjC reference book)
  

Question 2(b)
========
 
 valueOf is a class method because it can be used by many RatPoly objects and only one copy of this method exists
 in the memory. Every object does not have its own valueOf method. This method generates a RatPoly object and is therefore
 not an instance method.
 
 An instance method can also generate a RatNum from an input string, as an alternative.
 But it would make no sense to have an instance call that method and the method does not utilize the instance. 
 Memory would be allocated for this method for every instance.
 
Question 2(c)
========

 checkRep() will change. Its the one checking the representation invariant.
 The function checks if (denom < 0). Now this condition will be removed and the other condition will not check 
 if the GCD is not (+/-)1 since the representation invariant does not require the numer and denom to be reduced. 
 Since we are not checking for GCD now, complexity is reduced. And the code looks cleaner.
 
 initWith() will also change. It will also not check for GCD and will not reduce it to lowest form.
 
 The stringValue() function will have to convert the numer and denom to the lowest form. It will have to use GCD here
 to get the fraction in the lowest form. Complexity will increase here.
 
Question 2(d)
========
 
 Calls are made to checkRep only at the end of the constructors and nowhere else as 
 no function modifies RatNum. So only when the RatNum is initialized, it is checked.
  
 RatNum has its property set as Read-only - it has only getters not setters.
 So a RatNum cannot be modified by any function.
 
Question 2(e)
========

 QuestionNotFound Exception

Question 3(a)
========

I called checkRep in two constructors - initWith and initZero.
 Thats the only place where you need to check the representation invariant.
 The RatNum *coeff and expt are set as readonly and they do not have a setter.
 
Question 3(b)
========

 The first thing to change would be the checkRep method. It would now not check the zero exponents thing according to the new 
 specification. 
 ....
 ....
 
Question 3(c)
========

 
 
Question 3(d)
========

<Your answer here>

Question 5: Reflection (Bonus Question)
==========================
(a) How many hours did you spend on each problem of this problem set?

<Your answer here>

(b) In retrospect, what could you have done better to reduce the time you spent solving this problem set?

<Your answer here>

(c) What could the CS3217 teaching staff have done better to improve your learning experience in this problem set?

<Your answer here>

*/
