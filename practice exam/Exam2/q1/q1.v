// Netflix has been engaged by movie studios to advertise new movies.
// Netflix will show visitors one of 4 ads based on the kind of movie
// they last watched.

// The following characteristics of the last watched movie are
// considered:
// - Whether the movie was animated? (A = 1 means the movie was
//     animated; otherwise A = 0)
// - Whether the starring actor was female (F = 1) or male (F = 0)?
// - The type of movie: (T = 2'b00 (action movie), 2'b01 (romance),
//     2'b10 (comedy), 2'b11 (thriller))

// The ad served is chosen by the following rules:
// - "A Good Day to Die Hard" (M = 2'b00) will be shown to viewers of
//     action movies and thrillers, unless they are animated or had a
//     female starring actor.
// - "Safe Haven" (M = 2'b01) will be selected for people who had
//     viewed romance movies or movies with a female starring actor that
//     are not comedies.
// - When the previous two movie ads aren't shown, "Escape from Planet
//     Earth" (M = 2'b10) will be shown to people viewing animated movies,
//     comedies, or action movies.
// - Otherwise, "Saving Lincoln" (M = 2'b11) will be shown.

module movies(M, A, F, T);
   output [1:0] M;
   input  	A, F;
   input  [1:0]	T;	
	wire action, romance, comedy, thriller;
	wire goodday, safe,escape,saving;
	assign	action=~T[0]&~T[1];
	assign romance=T[0]&~T[1];
	assign comedy=~T[0]&T[1];
	assign thriller=T[0]&T[1];
		
	assign goodday=(action|thriller)&~F&~A;
	assign safe= romance|(F&~comedy);
	assign escape=~goodday&~safe&(A|action|comedy);
	assign saving=~(goodday|safe|escape);
   	
	assign M[0]=safe|saving;
	assign M[1]=escape|saving;
	//or o1(M[0],safe,saving);
	//or o2(M[1],escape,saving);

endmodule // movies

