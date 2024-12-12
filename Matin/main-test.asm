
@ge_currentColumn
M=0

@q_after_clear
M=0

@11111111
D=A
@decimalValue
M=D

    // read and print inputs from user
// Create return address
@main_after_pw_getInput
D=A
@pw_getInput_return
M=D

// call get input
@pw_getInput
0;JMP

(main_after_pw_getInput)
// At this point the user has hit enter, and stored a 16-bit binary word in R0-15 registers

    // convert binary word in R0-15 into decimal value
//mq_convert
// Create return address
@main_after_mq_convert
D=A
@mq_convert_return
M=D

// call convert
@mq_convertB2D
0;JMP

(main_after_mq_convert)

@decimalValue
D=M
@1280
M=D
@ENDB2D_MAIN_FILE
0;JMP

(ENDB2D_MAIN_FILE)
    @ENDB2D_MAIN_FILE
    0;JMP

//
// ***********************************pw_getInput***********************************
//
// Loops while user is inputting. Falls through six checks, one for each input of
// 1, 0, enter, backspace, c and q. If all six checks are passed without any being
// true, jumps to start of function. If a check is passed, jump to corresponding
// execution block (pw_input_0, pw_input_1, etc). Performs necessary actions within
// block before either jumping to the start of the function, jumping to the end of
// the program (quit), or returning to main (enter). For inputs that require access
// of R0 through R15, jumps to the function pw_storeInput for further processing.
//
// **********************************new variables**********************************
//
// q_after_clear: Flag that allows use of the clear execution block by the quit
// execution block (the program must clear the screen before quitting). A 1 means
// true (i.e. quit after running the clear execution block) and a 0 means false.
// 
// **IMPORTANT PRE-CONDITIONS**
// 
// - variable ge_currentColumn from function ge_output_X must be initialized to 0
// 
// - variable q_after_clear must be initialized to 0 before calling pw_getInput
// 
// - return address must be saved in pw_getInput_return
//
// C++ pseudocode: 
//
// (start)
//		while (KBD != 0){
// 		}
//
// 		if (ge_currentColumn != 16)
// 		{
// 			if (KBD == 48)
//				goto pw_input_0
//				goto start
// 			if (KBD == 49)
// 				goto pw_input_1
//				goto start
// 		}
// 		else
// 		{
// 			if (KBD == 128)
// 				return
// 		}
// 		if (ge_currentColumn != 0)
// 		{
// 			if (KBD == 129)
// 				goto pw_input_backspace
//				goto start
// 			if (KBD == 67)
// 				goto pw_input_c
// 		}
// 		if (KBD == 81)
// 			goto pw_input_q
// 
// (pw_input_0)
// 		tostore = 0
// 		output 0
// 		return
// 
// (pw_input_1)
// 		tostore = 1
// 		output 1
// 		return
// 
// (pw_input_backspace)
// 		tostore = -1
// 		output space
// 		return
// 
// (pw_input_c)
// 		while (ge_currentColumn != 0)
// 		{
// 			tostore = -1
// 			output space
// 			ge_currentColumn--
// 		}
// 		if (q_after_clear == 1)
// 			goto end
// 		else
// 			goto start
// 
// (pw_input_q)
// 		q_after_clear = 1
// 		goto pw_input_c
// 

(pw_getInput)

	@ge_currentColumn
	D=M
		
	@16
	D=D-A
		
	@pw_non_integer_input
	D;JEQ			// skip checks for 0 and 1 if 16 bits have been inputted (ge_currentColumn == 16)

	// check for input '0' (ASCII 48)
	@KBD
	D=M
		
	@48
	D=D-A
	@pw_input_0
	D;JEQ			// if input == 0 goto pw_input_0
	
	// check for input '1' (ASCII 49)
	@KBD
	D=M
	
	@49
	D=D-A
	@pw_input_1
	D;JEQ			// if input == 1 goto pw_input_1
	
	(pw_non_integer_input)

		@ge_currentColumn
		D=M
	
		@16
		D=D-A

		@pw_position_not_16
		D;JNE		// skip check for enter if less than 16 bits have been inputted (ge_currentColumn != 16)
	
		// check for input "Enter" (ASCII 128)
		@KBD
		D=M
	
		@128
		D=D-A
		@pw_input_enter
		D;JEQ		// if input == enter goto pw_input_enter
	
	(pw_position_not_16)
	
		@ge_currentColumn
		D=M

		@pw_position_0
		D;JEQ		// skip checks for backspace and clear if 0 bits have been inputted (ge_currentColumn == 0)
	
		// check for input "Backspace" (ASCII 129)
		@KBD
		D=M
	
		@129
		D=D-A
		@pw_input_backspace
		D;JEQ		// if input == backspace goto pw_input_backspace
	
		// check for input 'C' (ASCII 67)
		@KBD
		D=M
	
		@67
		D=D-A
		@pw_input_c
		D;JEQ		// if input == clear goto pw_input_c
		
	(pw_position_0)
	
		// check for input 'Q' (ASCII 81)
		@KBD
		D=M
	
		@81
		D=D-A
		@pw_input_q
		D;JEQ		// if input == quit goto pw_input_q
		
		@pw_getInput
		0;JMP		// if no valid inputs are detected goto pw_getInput (loop and check again)
	
	(pw_input_0)
	
		@tostore
		M=0
		
		@pw_input_0_continue_A
		D=A
		@pw_storeInput_return
		M=D
		@pw_storeInput
		0;JMP					// call pw_storeInput for tostore = 0
		
		(pw_input_0_continue_A)
	
			@pw_input_0_continue_B
			D=A
			@ge_output_return
			M=D
			@ge_output_0
			0;JMP				// output 0 using ge_output_0
	
			(pw_input_0_continue_B)
		
				@ge_currentColumn
				M=M+1
		
				@pw_getInput_end
				0;JMP			// goto pw_getInput_end for a key holding prevention check

	(pw_input_1)
	
		@tostore
		M=1
		
		@pw_input_1_continue_A
		D=A
		@pw_storeInput_return
		M=D
		@pw_storeInput
		0;JMP					// call pw_storeInput for tostore = 1
		
		(pw_input_1_continue_A)
	
			@pw_input_1_continue_B
			D=A
			@ge_output_return
			M=D
			@ge_output_1
			0;JMP				// output 0 using ge_output_1
	
			(pw_input_1_continue_B)
		
				@ge_currentColumn
				M=M+1
		
				@pw_getInput_end
				0;JMP			// goto pw_getInput_end for a key holding prevention check

	(pw_input_enter)
			
		@pw_getInput_return
		A=M
		0;JMP					// return to main; leave function
			
	(pw_input_backspace)
	
		@ge_currentColumn
		M=M-1					// go back one character
		
		@tostore
		M=-1					
		
		@pw_input_backspace_continue_A
		D=A
		@pw_storeInput_return
		M=D
		@pw_storeInput
		0;JMP					// call pw_storeInput for tostore = 1
		
		(pw_input_backspace_continue_A)
	
			@pw_input_backspace_continue_B
			D=A
			@ge_output_return
			M=D
			@ge_output_s
			0;JMP				// output a space (empty character) using ge_output_s
	
			(pw_input_backspace_continue_B)
	
				@pw_getInput_end
				0;JMP			// goto pw_getInput_end for a key holding prevention check

	(pw_input_c)
		
		@ge_currentColumn
		M=M-1				// go back one character

		@tostore
		M=-1
	
		@pw_input_c_continue_A
		D=A
		@pw_storeInput_return
		M=D
		@pw_storeInput
		0;JMP				// call pw_storeInput for tostore = 1
		
		(pw_input_c_continue_A)

			@pw_input_c_continue_B
			D=A
			@ge_output_return
			M=D
			@ge_output_s
			0;JMP			// output a space (empty character) using ge_output_s

			(pw_input_c_continue_B)
		
				@ge_currentColumn
				D=M
			
				@pw_input_c
				D;JNE		// if ge_currentColumn > 0 goto pw_input_c (delete the previous character until there are no more to delete)
				
				@q_after_clear
				D=M
				
				@END
				D-1;JEQ		// if q_after_clear == 1 goto END (quit; end the program)

				@pw_getInput_end
				0;JMP		// else goto pw_getInput_end for a key holding prevention check

	(pw_input_q)
	
		@q_after_clear
		M=1			// set q_after_clear flag to 1 (true) so the program can reuse the clear code
	
		@pw_input_c
		0;JMP		// goto pw_input_c for a clear before program termination

	(pw_getInput_end)

		@KBD
		D=M
	
		@pw_getInput_end
		D;JNE		// loop until KBD == 0 (no keys are pressed) to prevent mass inputs
	
		@pw_getInput
		0;JMP		// goto pw_getInput (loop function for next input)
// end pw_getInput
		
//
// ***********************************pw_storeInput*********************************
//
// Uses prestored variable "tostore" to place a value in the virtual register that
// corresponds to the current value of ge_currentColumn. pw_getInput's execution
// blocks will store the correct values in tostore before calling this function,
// where a 1 input will store a 1 in tostore, a 0 will store a 0, and a backspace or
// clear will store a -1 (which will inevitably be overwritten, but serves to show
// in memory that something has changed).
//
// ***********************************new variables*********************************
//
// tostore: Variable that holds either 1, 0, or -1, and is needed to place the
// correct values in R0 through R15.
// 
// **IMPORTANT PRE-CONDITIONS**
// 
// - variable tostore must be set to the intended value (1, 0, or -1)
// 
// - return address must be saved in pw_storeInput_return
//
// C++ pseudocode:
// 
// switch (tostore)
// {
// 		case 0:
//			RAM[ge_currentColumn] = 0
// 		case 1:
// 			RAM[ge_currentColumn] = 1
// 		case -1:
// 			RAM[ge_currentColumn] = -1
// }
// 

(pw_storeInput)
	
	@tostore
	D=M
	
	@pw_store_0
	D;JEQ			// execute pw_store_0 block if tostore = 0
	
	@pw_store_1
	D;JGT			// execute pw_store_1 block if tostore > 0 (1)
	
	@pw_store_clear
	D;JLT			// execute pw_store_clear block if tostore < 0 (-1)
	
	(pw_store_0)
	
		@ge_currentColumn
		A=M
		M=0					// RAM[ge_currentColumn] = 0
		
		@pw_storeInput_end
		0;JMP				// goto end
	
	(pw_store_1)
	
		@ge_currentColumn
		A=M
		M=1					// RAM[ge_currentColumn] = 1
		
		@pw_storeInput_end
		0;JMP				// goto end
		
	(pw_store_clear)
	
		@ge_currentColumn
		A=M
		M=-1				// RAM[ge_currentColumn] = -1
		
	(pw_storeInput_end)
	
		@pw_storeInput_return
		A=M
		0;JMP				// return
// end pw_storeInput
		
//
// coded by George Eaton November 2020 for CS 3A
//
// functions ge_output_X (where X is one of the characters 0,1,2,3,4,5,6,7,8,9,0,- (minus),
//                        + (plus), s (space bar), or g (greater than  > )
//
// Outputs character X (see above) at a specified column, where columns run from
// 0 to 31.
//
// Call ge_output_X as follows (Pre-conditions):
//     - save return address in ge_output_return
//     - save the current column (starting with 0 for the first column) in
//       variable ge_currentColumn
//     - jump to ge_output_X to output the character X in
//       column ge_currentColumn, where X is one of the
//       the characters 0,1,2,3,4,5,6,7,8,9,0,-,+,s, or g
//
// Result (Post-conditions) is character X is output on the display at column ge_currentColumn
//

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