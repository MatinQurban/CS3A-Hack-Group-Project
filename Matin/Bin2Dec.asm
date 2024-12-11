//test:
@120
M=0
@122
M=0

// ============================= MAIN =============================
@ge_currentColumn
M=0

@q_after_clear
M=0

@decimalValue
M=1
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
// At this point we have a converted to decimal 2's complement binary word into variable decimalValue

    // convert result to print
// Create return address
@main_after_BN_format
D=A
@BN_displayHelper
M=D

// call format
@BN_formatDigits
0;JMP

(main_after_BN_format)
//Now, all the digits and their respective places are being held in the array BN_formatDigits.
    
    // output result
//kl_outputValue

//output arrow:
// Create return address
@main_after_kl_arrow
D=A
@KL_outputArrowReturn
M=D

@KL_outputArrow //call
0;JMP

(main_after_kl_arrow)

//output sign and number:
// Create return address
@main_after_kl_sign
D=A
@KL_outputSign_return
M=D

@KL_outputSign
0;JMP       // call

(main_after_kl_sign)

@ENDB2D_MAIL_FILE
0;JMP

// ============================= END MAIN =============================



// ============================= FUNCTIONS =============================


// ===================================================================================
// *
// ===============================   PARKER INPUT   ==================================
// *
// ===================================================================================

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
//test code:
@11111
D=A
@120
M=D
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
	

// ===================================================================================
// *
// ===============================  END PARKER INPUT  ==================================
// *
// ===================================================================================




//  .. . . . . .. .. . . . . . .. . . .  .. .  . ...  . . ..  . . . . . . . .. .  . ..




// ===================================================================================
// *
// ===============================  MATIN CONVERT  ==================================
// *
// ===================================================================================

//FUNCTIONS:
    //MULT
    //POW
//VARIABLES:
    //POW_BASE
    //POW_EXP
    //POW_VAL
    //MULT_X
    //MULT_Y
    //MULT_PRODUCT
    //exp
    //decimalValue
//RETURN CALLS:
    //after-pow
    //return-pow
    //next-pow
    //return-mult
    //after-MULT_bdigit
    //CB2D_loop
    //endCB2D_loop


// 
// This file provides the functionality to convert a 16-bit signed binary number into its 
// decimal representation, accounting for two's complement for negative numbers. It utilizes 
// functions for binary arithmetic operations such as multiplication and exponentiation 
// to perform this conversion.
//
// The conversion algorithm follows the formula:
//     decimalValue = Σ (R[i] * 2^(14-i))
// where R[i] represents the binary digits, and the exponent decrements from 14 to 0. The sign 
// bit (R0) is checked and, if set, the two's complement of the number is computed to handle 
// negative values.
//
// The file contains the following key components:
//
// 1. **CONVERT B2D FUNCTION**: 
//    - Iteratively calculates the decimal value of the binary input by using the `MULT` 
//      and `POW` functions.
//    - Computes each binary digit's contribution by multiplying the bit value by its corresponding 
//      power of 2 (determined using the `POW` function).
//    - Accumulates the results in `decimalValue`.
//    - Adjusts the result for negative numbers using two's complement logic.
//
// 2. **SIGN CHECK AND CONVERSION**:
//    - After the conversion loop, checks the sign bit (R0).
//    - If the number is negative, the function flips all bits of `decimalValue`, adds 1, and 
//      negates the result to complete the two's complement transformation.
//
// 3. **POW FUNCTION**:
//    - Computes `z = x^y`, where `x` is the base, and `y` is the exponent.
//    - Utilizes the `MULT` function to repeatedly multiply the base by itself in a loop, ensuring 
//      modularity and code reuse.
//    - Stores the result in `POW_VAL`.
//
// 4. **MULT FUNCTION**:
//    - Computes the product of two numbers, `MULT_X` and `MULT_Y`, using repeated addition.
//    - Handles negative multipliers by checking the sign, adjusting accordingly, and restoring 
//      the original values after computation.
//
// Pre-conditions:
//    - Input binary digits are stored in registers R0 to R15, where R0 is the sign bit and R1 
//      to R15 hold the most significant to least significant bits.
//    - Variables for intermediate values (e.g., `POW_BASE`, `POW_EXP`, `MULT_X`, `MULT_Y`) 
//      must be initialized appropriately.
//
// Post-conditions:
//    - The decimal equivalent of the input binary number is stored in `decimalValue`.
//    - For negative inputs, the result correctly reflects the two's complement interpretation.
//    - Registers and variables modified during computation are restored to their expected states.
//
// Call this program as follows:
//    - Provide binary input in registers R0 to R15.
//    - Invoke the `CONVERT B2D FUNCTION` to calculate the decimal value.
//    - Result is stored in `decimalValue` for further use or display.
//


//============================== CONVERT B2D FUNCTION ==============================
// Numbers are going to be stored in registers R0 - R15
// with sign bit in R0, and msb in R1
// Algorithm is as follows:
// decimalValue = decimalValue + R[i] * POW(2 , exp)
// with exp = 14 - i
// After decimalValue has been calculated, check sign bit.
// if sign bit == 1, decimalValue = -decimalValue



(mq_convertB2D)

//  set loop control variable and also exponent dependency
@14
D=A
@lcvB2D
M=D

//  set decimalValue (accumulator)
@decimalValue
M=0


//  Check if the sign bit (R0) is 1
@mq_b2d_negflag
M=0
@R0
D=M
@negativeDone
D;JEQ // If R0 == 0, the number is positive, continue the program

@mq_b2d_negflag
M=1

@15
D=A
@fb_loop_var
M=D
(flipBitsLoop)
        @fb_loop_var
        D=M
        @R0
        A=D+A // get bit

        D=M     //store bit (0 or 1) into D-reg
        @1
        D=D-A       //check if bit is zero or one, run respective flip
        @mq_bitflag_one
        D;JEQ
        @mq_bitflag_zero
        D;JLT

        (mq_bitflag_one)
            @fb_loop_var
            D=M
            @R1
            A=D+A // get bit (we know it's a 1)

            M=0 //set to 0
            @mq_after_flip
            0;JMP

        (mq_bitflag_zero)
//test code:
@11111
D=A
@122
M=D
            @fb_loop_var
            D=M
            @R1
            A=D+A // get bit (we know it's a 1)

            M=1 //set to 1
            @mq_after_flip
            0;JMP

    (mq_after_flip)
    @fb_loop_var
    M=M-1
    D=M
    @negativeDone
    D;JEQ

    @flipBitsLoop
    0;JMP

(negativeDone)

    // Continue program execution


(CB2D_loop)

        //get POW(2, exp)

//Create return address 
@after-pow
D=A
@return-pow
M=D

    //Call POW FUNCTION, will compute POW_BASE ^ POW_EXP and store the result in POW_VAL
//create variables for pow function:
@2
D=A
@POW_BASE
M=D

@lcvB2D
D=M
@POW_EXP
M=D

@POW //CALL POW
0;JMP
(after-pow)  //call return address to continue here



        //CALC: bDigit = R[i] * 2^exp (using MULT function)
@14
D=A
@lcvB2D
D=D-M   // i = 14 - pow
@R1
A=D+A  //  Get R[i]
D=M    //  Store R[i] in D-reg

    //Call MULT function, it will compute: MULT_X * MULT_Y and store the result in MULT_PRODUCT
//MULT(pow_val, D-reg) = bDigit
//create variables for mult function:
@MULT_X
M=D     //R[i] in D-reg

@POW_VAL
D=M
@MULT_Y
M=D     //2^exp for base_2 digit place


//Create return address 
@after-MULT_bdigit
D=A
@return-mult
M=D

@MULT //CALL MULT
0;JMP
(after-MULT_bdigit)  //call return address to continue here



        //CALC: Dv = Dv + bDigit
@MULT_PRODUCT
D=M  // bdigit = MULT_PRODUCT
@decimalValue
M=D+M // bDigit + Dv

        //check lcvB2D
@lcvB2D
D=M
@endCB2D_loop
D;JEQ

D=D-1
@CB2D_loop //else, decrement lcv and loop
0;JMP

//Calc Done: 
//  decimalValue = decimalValue + R[i] * POW(2, exp)
//  exp = 14 - lcvB2D

(endCB2D_loop)

@mq_b2d_negflag // check for sign change
D=M
@mq_finish_convert
D;JEQ

//          if the value is negative, add one and flip the sign.
@decimalValue
M=M+1
M=-M

(mq_finish_convert)
//end function


@mq_convert_return
A=M
0;JMP			// return to main; leave function
		

//============================== END CONVERT B2D FUNCTION ==============================




// ===================================================================================
// *
// ===============================  END MATIN CONVERT  ==================================
// *
// ===================================================================================




//  .. . . . . .. .. . . . . . .. . . .  .. .  . ...  . . ..  . . . . . . . .. .  . ..




// ===================================================================================
// *
// ===============================    BRANDON FORMAT    ==============================
// *
// ===================================================================================


// Role2-Variables
// decimalValue
// mq_b2b_negflag Indicates the sign of the number: 1 for negative, 0 for positive.
// Role3 - Variables
// BN_decimalValue (single input from Role 2)
// BN_formattedResult (buffer for digits, stores numeric values)
// BN_formattedSign (stores "+" or "-")
// BN_hasLeadingZero (1 = leading zeros exist, 0 = no leading zeros)
// tempQuotient (stores quotient during division)
// tempRemainder (stores remainder during division)
// tempDivisor (stores divisor during division)
// HandleZero
// BN_decimalValue
/// Functions
// OUTPUT_FORMATTING_BEGIN
// BN_formatDigits - BN_formatDigits extracts and formats each digit of the decimal value into BN_formattedResult. Leading zeros are skipped until a non-zero digit is encountered.
// BN_divide - Performs division to extract each digit from the decimal value. Updates tempQuotient and tempRemainder.

// ****************OUTPUT_FORMATTING_BEGIN******************
// Begins the output formatting process.
// This function loads `decimalValue` from Role 2 and decides
// whether the number is positive or negative based on 
// `mq_b2b_negflag`. It then initiates the digit formatting 
// process by calling `BN_formatDigits`.
// ***************Key Variables******************
// decimalValue: The numeric value to be formatted.
// mq_b2b_negflag: Indicates if the number is negative (1) or positive (0).
// Returns:
// Control is passed to `BN_formatDigits` for digit extraction.

(OUTPUT_FORMATTING_BEGIN)
    @decimalValue
    D=M              // Load decimalValue from Role 2
    @BN_formatDigits
    0;JMP            // Start with formatting the sign

// ****************BN_formatDigits******************
// Converts the `decimalValue` into individual digits, starting 
// from the most significant digit (ten-thousands place). It uses 
// progressive division by factors of 10 (10000, 1000, etc.) to 
// extract each digit. Leading zeros are skipped unless a non-zero
// digit has already been stored, managed by the `BN_hasLeadingZero` 
// flag. Also a imlementation to handle if the value is 0.
//  The digits are stored sequentially in `BN_formattedResult` 
// for later display by Role 4.
// ***************Key Variables******************
// decimalValue: Original number from Role 2.
// BN_formattedResult: Buffer for formatted digits.
// BN_hasLeadingZero: Tracks if leading zeros are active (1 = yes, 0 = no).
// tempDivisor: Current divisor for digit extraction.
// tempQuotient: Stores extracted digit.
// tempRemainder: Stores the remainder after division.

(BN_formatDigits)
    @decimalValue
    D=M              // Load `decimalValue`
    @BN_decimalValue
    M=D              // Copy to `BN_decimalValue`

    @mq_b2b_negflag
    D=M
    @SkipNegCheck
    D;JEQ            // If positive, skip negation
    @BN_decimalValue
    M=-M             // Negate to make it positive
(SkipNegCheck)

    @BN_decimalValue
    D=M
    @HandleZero
    D;JEQ            // If `decimalValue` is 0, handle it directly

    @BN_hasLeadingZero
    M=0

    @10000
    D=A
    @tempDivisor
    M=D              // Initialize divisor to 10000
    @BN_divide
    0;JMP            // Start digit extraction

(HandleZero)
    @BN_formattedResult
    A=M
    M=0              // Store 0 as the first digit
    @BN_formattedResult
    M=M+1            // Move buffer pointer forward
    @EndFormatDigits // Skip further processing
    0;JMP

// Extract and process thousands place
(ProcessThousands)
    @1000
    D=A
    @tempDivisor
    M=D
    @BN_divide
    0;JMP

// Extract and process hundreds place
(ProcessHundreds)
    @100
    D=A
    @tempDivisor
    M=D
    @BN_divide
    0;JMP

// Extract and process tens place
(ProcessTens)
    @10
    D=A
    @tempDivisor
    M=D
    @BN_divide
    0;JMP

// Extract and process ones place
(ProcessOnes)
    @1
    D=A
    @tempDivisor
    M=D
    @BN_divide
    0;JMP

(EndFormatDigits)
    @BN_passToDisplay
    0;JMP

// ****************BN_divide******************
// Implements the division process to extract a single digit 
// from the `BN_decimalValue`. The function subtracts the divisor 
// (`tempDivisor`) repeatedly from 'BN_decimalValue`, counting how 
// many times the subtraction occurs (stored in `tempQuotient`). 
// The leftover value is stored as `tempRemainder`.
// Variables used: `decimalValue`, `tempDivisor`, `tempQuotient`, 
// `tempRemainder`.
// ***************Key Variables******************
// BN_decimalValue: Value being divided.
// tempDivisor: Current divisor.
// tempQuotient: Resulting digit.
// tempRemainder: Remaining value after division.

(BN_divide)
    @tempQuotient
    M=0              // Initialize quotient
(DivideLoop)
    @BN_decimalValue
    D=M
    @tempDivisor
    D=D-M            // Subtract divisor
    @EndDivide
    D;JLT            // If negative, exit
    @BN_decimalValue
    M=D              // Update remainder
    @tempQuotient
    M=M+1            // Increment quotient
    @DivideLoop
    0;JMP
(EndDivide)
    @StoreDigits
    0;JMP

(StoreDigits)
    @tempQuotient
    D=M              // Get digit
    @BN_hasLeadingZero
    A=M
    D=D+A
    @SkipDigit
    D;JEQ            // Skip leading zeros
    @BN_formattedResult
    A=M
    M=D              // Store digit
    @BN_formattedResult
    M=M+1
    @BN_hasLeadingZero
    M=0              // Disable leading zeros
(SkipDigit)
    @tempRemainder
    D=M
    @BN_decimalValue
    M=D              // Update remainder
    @NextDivisor      // Explicit jump to NextDivisor
    0;JMP

(NextDivisor)
    @tempDivisor
    D=M
    @10000
    D=D-A
    @ProcessThousands
    D;JEQ
    @1000
    D=D-A
    @ProcessHundreds
    D;JEQ
    @100
    D=D-A
    @ProcessTens
    D;JEQ
    @1
    D=D-A
    @ProcessOnes
    D;JEQ
	@EndFormatDigits
    0;JMP


// ================================================
// BN_passToDisplay
// -----------------------------------------------
// Marks the end of the formatting process and passes control 
// to the display logic in Role 4. This ensures that the formatted 
// result stored in `BN_formattedResult` is ready for rendering.
// No additional variables are modified in this function.
// ================================================
(BN_passToDisplay)
    @BN_displayHelper
    A=M
    0;JMP


// ===================================================================================
// *
// ===============================  END BRANDON FORMAT  ==================================
// *
// ===================================================================================




//  .. . . . . .. .. . . . . . .. . . .  .. .  . ...  . . ..  . . . . . . . .. .  . ..




// ===================================================================================
// *
// ===============================  KEVIN OUTPUT  ==================================
// *
// ===================================================================================


// ===============================  KL_output  ==================================
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
// @KL_sign_return
// @ten_thousands_return
// @thousands_return
// @hundreds_return
// @tens_return
// @ones_return
// -------------------------------------------

// GLOBAL VARIABLES
@ge_currentColumn		// set output to 0
M=0

@most_significant_bit	// set most_significant_bit to 0
M=0

@leading_zero			// set no leading zero unless set later
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
@ge_currentColumn
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

@BN_formattedResult
A=M
D=M

@digit
M=D

@BN_formattedResult
M=M+1

@output_decimal
D;JGT					// if digit is > 0 it jumps to output_decimal to print
@leading_zero
M=0
@ge_currentColumn
M=M-1

(output_thousand)	// handles the thousands digit output
@ge_currentColumn
M=M+1

@BN_formattedResult
A=M
D=M

@digit
M=D

@BN_formattedResult
M=M+1

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

@BN_formattedResult
A=M
D=M

@digit
M=D

@BN_formattedResult
M=M+1

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

@BN_formattedResult
A=M
D=M

@digit
M=D

@BN_formattedResult
M=M+1

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

@BN_formattedResult
A=M
D=M

@digit
M=D			// store it in digit

@BN_formattedResult
M=M+1

@KL_outputSign_return
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

(ten_thousands_return)	// move on to print 3 after dealing with the sign
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
@ge_output_return
M=D
@ge_output_8
0;JMP		// print 8
// ===============================  END KL_output  ==================================


// ===================================================================================
// *
// ===============================  END KEVIN OUTPUT  ==================================
// *
// ===================================================================================




//  .. . . . . .. .. . . . . . .. . . .  .. .  . ...  . . ..  . . . . . . . .. .  . ..




// ===================================================================================
// *
// ===============================  CONVERT HELPERS  ==================================
// *
// ===================================================================================


// ============================== POW FUNCTION ==============================
// Create a power program Pow.asm that computes 
// z = x to the power of y, where y must be >= 1
// *
// You MUST convert your Multi.asm program into a function in your Pow.asm
//and call this function in a loop in order to implement the exponentiation.
// *
// *
// x must be stored in POW_BASE, y in POW_EXP, and the result z in POW_VAL. 
// You must not modify POW_BASE or POW_EXP. You may use variables and other 
// registers except for MULT_X, MULT_Y, and MULT_PRODUCT which are dedicated
// to your Mult function.
(POW_FUNCTION)

    //Creating LCVpow
@POW_EXP
D=M
@LCVpow
M=D
    //Case: Power of 1
@POW_BASE     // x into D-reg
D=M
@POW_VAL     // z = x
M=D
@LCVpow     // y--
M=M-1


//POW(x^y) = x * x * x ... * x -> y times

(loopPow)
        //IF y=0, end.
    @LCVpow
    D=M
    @END
    D;JEQ

        
        //Set MULT_Y and MULT_X vals to x and z to prepare for calling mult
    @POW_BASE     //Get x
    D=M     //Store x in D-reg
    @MULT_X     //Store x in MULT_X
    M=D

    @POW_VAL     //Get z
    D=M     //Store z in D-reg
    @MULT_Y     //Store z in MULT_Y
    M=D


        //Create return address
    @next-pow
    D=A
    @return-mult
    M=D

        //Call MULT FUNCTION, will compute MULT_X * MULT_Y and store it in MULT_PRODUCT
    @MULT
    0;JMP
    (next-pow)  //call return address to continue here
    
    
    //At this point, we have {x * z} stored in MULT_PRODUCT, lets store this new value in z (POW_VAL), decremenet LCV, and loop

        //Store result of MULT into POW_VAL (z)
    @MULT_PRODUCT
    D=M
    @POW_VAL
    M=D

        //decremenet LCV
    @LCVpow
    M=M-1

        //Loop
    @loopPow
    0;JMP

(ENDPOWLOOP)



(END_POW_FUNCTION)
// Return back to where the function was called
@return-pow
A=M
0;JMP

// ============================== END POW FUNCTION ==============================





// ============================== MULT FUNCTION ==============================
(MULT)

    // Multiplies MULT_X and MULT_Y and stores the result in MULT_PRODUCT.
    // (MULT_X, MULT_Y, MULT_PRODUCT refer to RAM[0], RAM[1], and RAM[2], respectively.)
    // The algorithm is based on repetitive addition.
    //loop add z = z+x (y times) OR add z = z+y (x times)

    //First check if lcv is negative
    @MULT_Y
    D=M

    @negflag //create a negflag variable
    M=0 //set it to false off the bat

    @notneg //if (D [currently MULT_Y is stored] is > 0), then jump to notneg
    D;JGT
    D;JEQ //in case acculmulater is 0

    // else, MULT_Y(LCV) is negative, so change negflag to true (or just not false(0), in this case 1 but could be any number)
    @negflag
    M=1

    @MULT_Y
    M=-M //and also change the sign of the LCV

    (notneg)
    //... 4a Mult, leave this unchanged ...
    @MULT_PRODUCT
    M=0 //Make sure value of MULT_PRODUCT(accumulater) starts at 0

    //Setting loop control variable
    @MULT_Y
    D=M //save value of MULT_Y into D
    @LCVmult
    M=D //save value of D (val of MULT_Y) into LCV

    (loop)

        // Check LCV
        @LCVmult 
        D=M 
        @loopEnd 
        D;JEQ // if (LCV == 0) end loop

        @MULT_PRODUCT
        D=M // Current acculated value loaded into D
        
        // z=z+x (y times)
        @MULT_X
        D=D+M 
        @MULT_PRODUCT
        M=D

        //Decrement LCV and loop again
        @LCVmult
        M=M-1
        @loop
        0;JMP    

    (loopEnd)

    //... ...

    //Now sign switch if negflag = true
    @negflag
    D=M //load negflag

    @ENDMULT
    D;JEQ // if it's equal to 0, meaning negflag is false, end.

    //else, if it's anything but 0, that means lcv is negative.
    //So, we have to switch the sign of the final result
    @MULT_PRODUCT
    M=-M

    //Switch the LCV(MULT_Y) sign back so MULT_Y remains unchanged
    @MULT_Y
    M=-M


    (ENDMULT)
// Return back to where the function was called
@return-mult
A=M
0;JMP

//============================== END MULT FUNCTION ==============================


// ===================================================================================
// *
// ============================  END CONVERT HELPERS  ================================
// *
// ===================================================================================



//  .. . . . . .. .. . . . . . .. . . .  .. .  . ...  . . ..  . . . . . . . .. .  . ..



// ===================================================================================
// *
// ===============================  OUTPUT HELPERS  ==================================
// *
// ===================================================================================


// =================================  GE_OUTPUT_X  ===================================
// This file uses the Hack language and fonts
// that are part of www.nand2tetris.org
// and the book "The Elements of Computing Systems"
// by Nisan and Schocken, MIT Press.
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


// ================================= END GE_OUTPUT_X =================================


// ===================================================================================
// *
// ================================= END OUTPUT HELPERS =================================
// *
// ===================================================================================




(ENDB2D_MAIL_FILE)