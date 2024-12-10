@position
M=0
D=M

@ge_currentColumn
M=D

@q_after_clear
M=0

@END
D=A
@pw_getInput_return
M=D
@pw_getInput
0;JMP

(END)

	@END
	0;JMP

(pw_getInput)

	@position
	D=M
		
	@16
	D=D-A
		
	@pw_non_integer_input
	D;JEQ

	// check for input '0' (ASCII 48)
	@KBD
	D=M
		
	@48
	D=D-A
	@pw_input_0
	D;JEQ
	
	// check for input '1' (ASCII 49)
	@KBD
	D=M
	
	@49
	D=D-A
	@pw_input_1
	D;JEQ
	
	(pw_non_integer_input)

		@position
		D=M
	
		@16
		D=D-A

		@pw_position_not_16
		D;JNE
	
		// check for input "Enter" (ASCII 128)
		@KBD
		D=M
	
		@128
		D=D-A
		@pw_input_enter
		D;JEQ
	
	(pw_position_not_16)
	
		@position
		D=M

		@pw_position_0
		D;JEQ
	
		// check for input "Backspace" (ASCII 129)
		@KBD
		D=M
	
		@129
		D=D-A
		@pw_input_backspace
		D;JEQ
	
		// check for input 'C' (ASCII 67)
		@KBD
		D=M
	
		@67
		D=D-A
		@pw_input_c
		D;JEQ
		
	(pw_position_0)
	
		// check for input 'Q' (ASCII 81)
		@KBD
		D=M
	
		@81
		D=D-A
		@pw_input_q
		D;JEQ
		
		@pw_getInput
		0;JMP
	
	(pw_input_0)
	
		@tostore
		M=0
		
		@pw_input_0_continue_A
		D=A
		@pw_storeInput_return
		M=D
		@pw_storeInput
		0;JMP
		
		(pw_input_0_continue_A)
	
			@pw_input_0_continue_B
			D=A
			@ge_output_return
			M=D
			@ge_output_0
			0;JMP
	
			(pw_input_0_continue_B)
		
				@position
				M=M+1
				D=M
		
				@ge_currentColumn
				M=D	
		
				@pw_getInput_end
				0;JMP

	(pw_input_1)
	
		@tostore
		M=1
		
		@pw_input_1_continue_A
		D=A
		@pw_storeInput_return
		M=D
		@pw_storeInput
		0;JMP
		
		(pw_input_1_continue_A)
	
			@pw_input_1_continue_B
			D=A
			@ge_output_return
			M=D
			@ge_output_1
			0;JMP
	
			(pw_input_1_continue_B)
		
				@position
				M=M+1
				D=M
		
				@ge_currentColumn
				M=D	
		
				@pw_getInput_end
				0;JMP

	(pw_input_enter)
	
		@pw_input_enter_continue_A
		D=A
		@ge_output_return
		M=D
		@ge_output_-
		0;JMP
		
		(pw_input_enter_continue_A)
		
			@position
			M=M+1
			D=M
			
			@ge_currentColumn
			M=D		
			
			@pw_input_enter_continue_B
			D=A
			@ge_output_return
			M=D
			@ge_output_g
			0;JMP
			
			(pw_input_enter_continue_B)
			
				@position
				M=M+1
				D=M
		
				@ge_currentColumn
				M=D	
			
				@pw_getInput_return
				A=M
				0;JMP
			
	(pw_input_backspace)
	
		@position
		M=M-1
		D=M
		
		@ge_currentColumn
		M=D
		
		@tostore
		M=-1
		
		@pw_input_backspace_continue_A
		D=A
		@pw_storeInput_return
		M=D
		@pw_storeInput
		0;JMP
		
		(pw_input_backspace_continue_A)
	
			@pw_input_backspace_continue_B
			D=A
			@ge_output_return
			M=D
			@ge_output_s
			0;JMP
	
			(pw_input_backspace_continue_B)
	
				@pw_getInput_end
				0;JMP		

	(pw_input_c)
	
		(pw_while_position_not_0)
		
			@position
			M=M-1
			D=M
		
			@ge_currentColumn
			M=D
	
			@tostore
			M=-1
		
			@pw_input_c_continue_A
			D=A
			@pw_storeInput_return
			M=D
			@pw_storeInput
			0;JMP
			
			(pw_input_c_continue_A)
	
				@pw_input_c_continue_B
				D=A
				@ge_output_return
				M=D
				@ge_output_s
				0;JMP
	
				(pw_input_c_continue_B)
			
					@position
					D=M
				
					@pw_while_position_not_0
					D;JNE
					
					@q_after_clear
					D=M
					
					@END
					D-1;JEQ
	
					@pw_getInput_end
					0;JMP		

	(pw_input_q)
	
		@q_after_clear
		M=1
	
		@pw_input_c
		0;JMP

	(pw_getInput_end)
	
		(pw_wait_for_reset)
		
			@KBD
			D=M
		
			@pw_wait_for_reset
			D;JNE
	
		@pw_getInput
		0;JMP		
		

(pw_storeInput)
	
	@tostore
	D=M
	
	@pw_store_0
	D;JEQ
	
	@pw_store_1
	D;JGT
	
	@pw_store_clear
	D;JLT
	
	(pw_store_0)
	
		@position
		A=M
		M=0
		
		@pw_storeInput_end
		0;JMP
	
	(pw_store_1)
	
		@position
		A=M
		M=1
		
		@pw_storeInput_end
		0;JMP
		
	(pw_store_clear)
	
		@position
		A=M
		M=-1
		
	(pw_storeInput_end)
	
		@pw_storeInput_return
		A=M
		0;JMP
		
		
		
		
// This file uses the Hack language and fonts
// that are part of www.nand2tetris.org
// and the book "The Elements of Computing Systems"
// by Nisan and Schocken, MIT Press.
//
// coded by George Eaton November 2020 for CS 3A

//
// functions ge_output_X (where X is one of the characters 0,1,2,3,4,5,6,7,8,9,0,- (minus),
//                        + (plus), s (space bar), or g (greater than  > ))
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