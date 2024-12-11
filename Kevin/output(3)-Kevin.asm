// FUNCTIONS:
// (KL_outputArrow)
// (KL_outputArrowContinue)
// (KL_outputSign)
// (output_ten_thousand)
// (output_thousand)
// (output_hundred)
// (output_tens)
// (output_ones)
// (output_decimal)
// (KL_output_special_case)
// (KL_sign_return)
// (ten_thousands_return)
// (thousands_return)
// (hundreds_return)
// (tens_return)
// (ones_return)
// ------------------------------------------
// VARIABLES:
// ge_output_return
// ge_output_-
// ge_output_g
// ge_output_+
// most_significant_bit
// leading_zero
// ge_currentColumn
// ten_thousands_place
// digit
// thousands_place
// hundreds_place
// tens_place
// ones_place
// pw_getInput
// ge_output_(0-9)
// KL_outputArrowReturn
// KL_sign_return
// ten_thousands_return
// thousands_return
// hundreds_return
// tens_return
// ones_return
// -------------------------------------------
// RETURN CALLS:
// @KL_outputArrowReturn
// @ge_output_return
// @pw_getInput
// @KL_sign_return
// @ten_thousands_return
// @thousands_return
// @hundreds_return
// @tens_return
// @ones_return
// -------------------------------------------

// GLOBAL VARIABLES
ge_currentColumn		// set output to 0
M=0

@most_significant_bit	// set most_significant_bit to 0
M=0

@leading_zero			// set no leading zero unless set later
M=0

@ten_thousands_place
M=0

@thousands_place
M=0

@hundreds_place
M=0

@tens_place
M=0

@ones_place
M=0

@digit
M=0

// -------------------------------------------

// START OF OUTPUT ARROW
(KL_outputArrow)		// draw the left part of the arrow onto the screen
@KL_outputArrowContinue
D=A
@ge_output_return
M=D
@ge_output_-
0;JMP			// jump to ge_output_- to draw the minus portion of the arrow

(KL_outputArrowContinue) // complete the arrow by drawing the >
ge_currentColumn
M=M+1
@KL_outputArrowReturn
D=M
@ge_output_return
M=D
@ge_output_g	// draws the >
0;JMP			// jump to ge_output_g to draw
// END OF OUTPUT ARROW

(KL_outputSign)		// prints a + or - depending on the most significant bit of the number
@ge_currentColumn
M=M+1
@output_ten_thousand
D=A
@ge_output_return
M=D
@most_significant_bit
D=M				// load the value of the most significant bit
@ge_output_-
D;JGT			// if msb is a negative number, jump to draw the -
@ge_output_+	// draw a + if not
0;JMP

(output_ten_thousand)	// handles the output of the ten thousandths digit
@leading_zero			
M=1
@output_thousand
D=A
@ge_output_return
M=D
@ge_currentColumn
M=M+1
@ten_thousands_place
D=M						// load the ten thousandths digit
@digit
M=D
@output_decimal
D;JGT					// if digit is > 0 it jumps to output_decimal to print
@leading_zero
M=0
@ge_currentColumn
M=M-1

(output_thousand)	// handles the thousands digit output
@ge_currentColumn
M=M+1
@thousands_place
D=M					// load digit
@digit
M=D
@output_hundred
D=A
@ge_output_return
M=D
@digit
D=M
@output_decimal
D;JGT			// if digit is > 0 or no leading zero, then print
@leading_zero
D=M
@output_decimal
D;JGT
@ge_currentColumn
M=M-1			// move back one column if no digit is printed

(output_hundred)	// handles the hundreds digit ouput
@ge_currentColumn
M=M+1
@hundreds_place
D=M
@digit
M=D
@output_tens
D=A
@ge_output_return
M=D
@digit
D=M
@output_decimal
D;JGT
@leading_zero
D=M
@output_decimal
D;JGT
@ge_currentColumn
M=M-1				// move back if nothing was printed

(output_tens)		// handles the tens digit output
@ge_currentColumn
M=M+1
@tens_place
D=M
@digit
M=D
@output_ones
D=A
@ge_output_return
M=D
@digit
D=M
@output_decimal
D;JGT
@leading_zero
D=M
@output_decimal
D;JGT
@ge_currentColumn
M=M-1			// move back if nothing was printed

(output_ones)
@ge_currentColumn
M=M+1
@ones_place
D=M			// load ones digit
@digit
M=D			// store it in digit
@pw_getInput		// get input
D=A
@ge_output_return
M=D			// updates the return address after getKey is done

(output_decimal) // checks which decimal is stored in digit and calls the correct ge_output_ function
@leading_zero
M=1
@digit
D=M				// loads the digit
@ge_output_0
D;JEQ			// if digit is 0, jumps to draw 0
@digit
D=M
@1
D=D-A
@ge_output_1
D;JEQ			// if digit is 1, jumps to draw 1
@digit
D=M
@2
D=D-A
@ge_output_2
D;JEQ			// if digit is 2, jumps to draw 2
@digit
D=M
@3
D=D-A
@ge_output_3
D;JEQ			// if digit is 3, jump to draw 3
@digit
D=M
@4
D=D-A
@ge_output_4
D;JEQ			// if digit is 4, jump to draw 4
@digit
D=M
@5
D=D-A
@ge_output_5
D;JEQ			// if digit is 5 jump to draw 5
@digit
D=M
@6
D=D-A
@ge_output_6
D;JEQ			// if digit is 6, jump to draw 6
@digit
D=M
@7
D=D-A
@ge_output_7
D;JEQ			// if digit is 7, jump to draw 7
@digit
D=M
@8
D=D-A
@ge_output_8
D;JEQ			// if digit is 8, jumps to draw 8
@digit
D=M
@9
D=D-A
@ge_output_9
D;JEQ			// if digit is 9, jump to draw 9


// SPECIAL CASE HANDLING
(KL_output_special_case) // handles special case output if its needed
@KL_sign_return	// sets return to KL_sign_return
D=A
@KL_outputArrowReturn	// updates KL_outputArrowReturn
M=D
@KL_outputArrow
0;JMP // jumps back to KL_outputArrow to reprint an arrow or sign if needed

(KL_sign_return)	// called after KL_output_special_case to return or print a sign/character
@ge_currentColumn
M=M+1
@ten_thousands_return // sets return to ten_thousands_return
D=A
@ge_output_return
M=D
@ge_output_-
0;JMP		// print - sign if needed

(ten_thousands_return)	move on to print 3 after dealing with the sign
@ge_currentColumn
M=M+1
@thousands_return
D=A
@ge_output_return
M=D
@ge_output_3
0;JMP			// print 3

(thousands_return)
@ge_currentColumn
M=M+1
@hundreds_return
D=A
@ge_output_return
M=D
@ge_output_2
0;JMP		// print 2

(hundreds_return)
@ge_currentColumn
M=M+1
@tens_return
D=A
@ge_output_return
M=D
@ge_output_7
0;JMP		// print 7

(tens_return)
@ge_currentColumn
M=M+1
@ones_return
D=A
@ge_output_return
M=D
@ge_output_6
0;JMP		// print 6

(ones_return)
@ge_currentColumn
M=M+1
@pw_getInput			// get input
D=A
@ge_output_return
M=D
@ge_output_8
0;JMP		// print 8





// ----------- START OF GE_OUTPUT_X.ASM -------------
//
// ge_continue_output
// this helper function ge_continue_output outputs the character defined by
// frontRow1 through initialized below it in the functions ge_output_X
(ge_continue_output)
//
// ***constants***
//
// ge_rowOffset - number of words to move to the next row of pixels
@32
D=A
@ge_rowOffset
M=D
// end of constants
//

//
// ***key variables***
//

// ge_currentRow - variable holding the display memory address to be written,
//                 which starts at the fourth row of pixels (SCREEN + 3 x rowOffset) 
//                 offset by the current column and
//                 increments row by row to draw the character
//               - initialized to the beginning of the fourth row in screen memory
//                 plus the current column
@SCREEN
D=A
@ge_rowOffset
// offset to the fourth row
D=D+M
D=D+M
D=D+M
// add the current column
@ge_currentColumn
D=D+M
@ge_currentRow
M=D
//


// write the first row of pixels
// load pattern in D via A
@ge_fontRow1
D=M
// write pattern at currentLine
@ge_currentRow
A=M
M=D
//

// update current line
@ge_rowOffset
D=M
@ge_currentRow
M=D+M
// load pattern in D via A
@ge_fontRow2
D=M
// write pattern at currentLine
@ge_currentRow
A=M
M=D
//


// update current line
@ge_rowOffset
D=M
@ge_currentRow
M=D+M
// load pattern in D via A
@ge_fontRow3
D=M
// write pattern at currentLine
@ge_currentRow
A=M
M=D
//


// update current line
@ge_rowOffset
D=M
@ge_currentRow
M=D+M
// load pattern in D via A
@ge_fontRow4
D=M
// write pattern at currentLine
@ge_currentRow
A=M
M=D
//


// update current line
@ge_rowOffset
D=M
@ge_currentRow
M=D+M
// load pattern in D via A
@ge_fontRow5
D=M
// write pattern at currentLine
@ge_currentRow
A=M
M=D
//


// update current line
@ge_rowOffset
D=M
@ge_currentRow
M=D+M
// load pattern in D via A
@ge_fontRow6
D=M
// write pattern at currentLine
@ge_currentRow
A=M
M=D
//


// update current line
@ge_rowOffset
D=M
@ge_currentRow
M=D+M
// load pattern in D via A
@ge_fontRow7
D=M
// write pattern at currentLine
@ge_currentRow
A=M
M=D
//


// update current line
@ge_rowOffset
D=M
@ge_currentRow
M=D+M
// load pattern in D via A
@ge_fontRow8
D=M
// write pattern at currentLine
@ge_currentRow
A=M
M=D
//


// update current line
@ge_rowOffset
D=M
@ge_currentRow
M=D+M
// load pattern in D via A
@ge_fontRow9
D=M
// write pattern at currentLine
@ge_currentRow
A=M
M=D
//



// return from function
@ge_output_return
A=M
0;JMP



//
// individual function ge_output_X definitions which are 
// just font definitions for the helper function above
//

//ge_output_0
(ge_output_0)
//do Output.create(12,30,51,51,51,51,51,30,12); // 0

@12
D=A
@ge_fontRow1
M=D

@30
D=A
@ge_fontRow2
M=D

@51
D=A
@ge_fontRow3
M=D

@51
D=A
@ge_fontRow4
M=D

@51
D=A
@ge_fontRow5
M=D

@51
D=A
@ge_fontRow6
M=D

@51
D=A
@ge_fontRow7
M=D

@30
D=A
@ge_fontRow8
M=D

@12
D=A
@ge_fontRow9
M=D
@ge_continue_output
0;JMP
// end ge_output_0

//ge_output_1
(ge_output_1)
//do Output.create(12,14,15,12,12,12,12,12,63); // 1

@12
D=A
@ge_fontRow1
M=D

@14
D=A
@ge_fontRow2
M=D

@15
D=A
@ge_fontRow3
M=D

@12
D=A
@ge_fontRow4
M=D

@12
D=A
@ge_fontRow5
M=D

@12
D=A
@ge_fontRow6
M=D

@12
D=A
@ge_fontRow7
M=D

@12
D=A
@ge_fontRow8
M=D

@63
D=A
@ge_fontRow9
M=D
@ge_continue_output
0;JMP
// end ge_output_1

//ge_output_2
(ge_output_2)
//do Output.create(30,51,48,24,12,6,3,51,63);   // 2

@30
D=A
@ge_fontRow1
M=D

@51
D=A
@ge_fontRow2
M=D

@48
D=A
@ge_fontRow3
M=D

@24
D=A
@ge_fontRow4
M=D

@12
D=A
@ge_fontRow5
M=D

@6
D=A
@ge_fontRow6
M=D

@3
D=A
@ge_fontRow7
M=D

@51
D=A
@ge_fontRow8
M=D

@63
D=A
@ge_fontRow9
M=D
@ge_continue_output
0;JMP
// end ge_output_2


//ge_output_3
(ge_output_3)
//do Output.create(30,51,48,48,28,48,48,51,30); // 3

@30
D=A
@ge_fontRow1
M=D

@51
D=A
@ge_fontRow2
M=D

@48
D=A
@ge_fontRow3
M=D

@48
D=A
@ge_fontRow4
M=D

@28
D=A
@ge_fontRow5
M=D

@48
D=A
@ge_fontRow6
M=D

@48
D=A
@ge_fontRow7
M=D

@51
D=A
@ge_fontRow8
M=D

@30
D=A
@ge_fontRow9
M=D
@ge_continue_output
0;JMP
// end ge_output_3

//ge_output_4
(ge_output_4)
//do Output.create(16,24,28,26,25,63,24,24,60); // 4

@16
D=A
@ge_fontRow1
M=D

@24
D=A
@ge_fontRow2
M=D

@28
D=A
@ge_fontRow3
M=D

@26
D=A
@ge_fontRow4
M=D

@25
D=A
@ge_fontRow5
M=D

@63
D=A
@ge_fontRow6
M=D

@24
D=A
@ge_fontRow7
M=D

@24
D=A
@ge_fontRow8
M=D

@60
D=A
@ge_fontRow9
M=D
@ge_continue_output
0;JMP
// end ge_output_4

//ge_output_5
(ge_output_5)
//do Output.create(63,3,3,31,48,48,48,51,30);   // 5

@63
D=A
@ge_fontRow1
M=D

@3
D=A
@ge_fontRow2
M=D

@3
D=A
@ge_fontRow3
M=D

@31
D=A
@ge_fontRow4
M=D

@48
D=A
@ge_fontRow5
M=D

@48
D=A
@ge_fontRow6
M=D

@48
D=A
@ge_fontRow7
M=D

@51
D=A
@ge_fontRow8
M=D

@30
D=A
@ge_fontRow9
M=D
@ge_continue_output
0;JMP
// end ge_output_5

//ge_output_6
(ge_output_6)
//do Output.create(28,6,3,3,31,51,51,51,30);    // 6

@28
D=A
@ge_fontRow1
M=D

@6
D=A
@ge_fontRow2
M=D

@3
D=A
@ge_fontRow3
M=D

@3
D=A
@ge_fontRow4
M=D

@31
D=A
@ge_fontRow5
M=D

@51
D=A
@ge_fontRow6
M=D

@51
D=A
@ge_fontRow7
M=D

@51
D=A
@ge_fontRow8
M=D

@30
D=A
@ge_fontRow9
M=D
@ge_continue_output
0;JMP
// end ge_output_6

//ge_output_7
(ge_output_7)
//do Output.create(63,49,48,48,24,12,12,12,12); // 7

@63
D=A
@ge_fontRow1
M=D

@49
D=A
@ge_fontRow2
M=D

@48
D=A
@ge_fontRow3
M=D

@48
D=A
@ge_fontRow4
M=D

@24
D=A
@ge_fontRow5
M=D

@12
D=A
@ge_fontRow6
M=D

@12
D=A
@ge_fontRow7
M=D

@12
D=A
@ge_fontRow8
M=D

@12
D=A
@ge_fontRow9
M=D
@ge_continue_output
0;JMP
// end ge_output_7


//ge_output_8
(ge_output_8)
//do Output.create(30,51,51,51,30,51,51,51,30); // 8

@30
D=A
@ge_fontRow1
M=D

@51
D=A
@ge_fontRow2
M=D

@51
D=A
@ge_fontRow3
M=D

@51
D=A
@ge_fontRow4
M=D

@30
D=A
@ge_fontRow5
M=D

@51
D=A
@ge_fontRow6
M=D

@51
D=A
@ge_fontRow7
M=D

@51
D=A
@ge_fontRow8
M=D

@30
D=A
@ge_fontRow9
M=D
@ge_continue_output
0;JMP
// end ge_output_8



//ge_output_9
(ge_output_9)
//do Output.create(30,51,51,51,62,48,48,24,14); // 9

@30
D=A
@ge_fontRow1
M=D

@51
D=A
@ge_fontRow2
M=D

@51
D=A
@ge_fontRow3
M=D

@51
D=A
@ge_fontRow4
M=D

@62
D=A
@ge_fontRow5
M=D

@48
D=A
@ge_fontRow6
M=D

@48
D=A
@ge_fontRow7
M=D

@25
D=A
@ge_fontRow8
M=D

@14
D=A
@ge_fontRow9
M=D
@ge_continue_output
0;JMP
// end ge_output_9


//ge_output_s
(ge_output_s)
//do Output.create(0,0,0,0,0,0,0,0,0); // space

@0
D=A
@ge_fontRow1
M=D

@0
D=A
@ge_fontRow2
M=D

@0
D=A
@ge_fontRow3
M=D

@0
D=A
@ge_fontRow4
M=D

@0 // temporarily change to 255 so you can see it
D=A
@ge_fontRow5
M=D

@0
D=A
@ge_fontRow6
M=D

@0
D=A
@ge_fontRow7
M=D

@0
D=A
@ge_fontRow8
M=D

@0
D=A
@ge_fontRow9
M=D
@ge_continue_output
0;JMP
// end ge_output_s



//ge_output_-
(ge_output_-)
//do Output.create(0,0,0,0,0,63,0,0,0);         // -

@0
D=A
@ge_fontRow1
M=D

@0
D=A
@ge_fontRow2
M=D

@0
D=A
@ge_fontRow3
M=D

@0
D=A
@ge_fontRow4
M=D

@0
D=A
@ge_fontRow5
M=D

@63 // use 16128 to have minus to the right of the word
D=A
@ge_fontRow6
M=D

@0
D=A
@ge_fontRow7
M=D

@0
D=A
@ge_fontRow8
M=D

@0
D=A
@ge_fontRow9
M=D
@ge_continue_output
0;JMP
// end ge_output_-


//ge_output_g
(ge_output_g)
//do Output.create(0,0,3,6,12,24,12,6,3);       // >

@0
D=A
@ge_fontRow1
M=D

@0
D=A
@ge_fontRow2
M=D

@3
D=A
@ge_fontRow3
M=D

@6
D=A
@ge_fontRow4
M=D

@12
D=A
@ge_fontRow5
M=D

@24
D=A
@ge_fontRow6
M=D

@12
D=A
@ge_fontRow7
M=D

@6
D=A
@ge_fontRow8
M=D

@3
D=A
@ge_fontRow9
M=D
@ge_continue_output
0;JMP
// end ge_output_g


//ge_output_+
(ge_output_+)
//do Output.create(0,0,0,12,12,63,12,12,0);     // +

@0
D=A
@ge_fontRow1
M=D

@0
D=A
@ge_fontRow2
M=D

@0
D=A
@ge_fontRow3
M=D

@12
D=A
@ge_fontRow4
M=D

@12
D=A
@ge_fontRow5
M=D

@63
D=A
@ge_fontRow6
M=D

@12
D=A
@ge_fontRow7
M=D

@12
D=A
@ge_fontRow8
M=D

@0
D=A
@ge_fontRow9
M=D
@ge_continue_output
0;JMP
// end ge_output_+