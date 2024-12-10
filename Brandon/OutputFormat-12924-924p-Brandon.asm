/ Role2-Variables
/ decimalValue
/ mq_b2b_negflag Indicates the sign of the number: 1 for negative, 0 for positive.
/ Role3 - Variables
/ BN_decimalValue (single input from Role 2)
/ BN_formattedResult (buffer for digits, stores numeric values)
/ BN_formattedSign (stores "+" or "-")
/ BN_hasLeadingZero (1 = leading zeros exist, 0 = no leading zeros)
/ tempQuotient (stores quotient during division)
/ tempRemainder (stores remainder during division)
/ tempDivisor (stores divisor during division)

// Functions
/ OUTPUT_FORMATTING_BEGIN
/ BN_positiveSign - Helper functions for BN_formatSign to handle positive and negative signs, respectively.
/ BN_negativeSign - Helper functions for BN_formatSign to handle positive and negative signs, respectively.
/ BN_formatDigits - BN_formatDigits extracts and formats each digit of the decimal value into BN_formattedResult. Leading zeros are skipped until a non-zero digit is encountered.
/ BN_divide - Performs division to extract each digit from the decimal value. Updates tempQuotient and tempRemainder.
/ BN_displayHelper - Outputs the arrow (->) and sign (+ or -), then hands off to Role 4 to traverse BN_formattedResult and display the digits.

// ================================================
// OUTPUT_FORMATTING_BEGIN
// -----------------------------------------------
// This is the starting point for the output formatting process.
// It begins by loading the `decimalValue` provided by Role 2 and 
// jumps to the BN_formatSign function to determine the sign 
// (positive or negative) based on the `mq_b2b_negflag` variable.
// Variables used: `decimalValue`, `mq_b2b_negflag`.
// ================================================

(OUTPUT_FORMATTING_BEGIN)
    @decimalValue
    D=M              // Load decimalValue from Role 2
    @BN_formatDigits
    0;JMP            // Start with formatting the sign

// ================================================
// BN_formatDigits
// -----------------------------------------------
// Converts the `decimalValue` into individual digits, starting 
// from the most significant digit (ten-thousands place). It uses 
// progressive division by factors of 10 (10000, 1000, etc.) to 
// extract each digit. Leading zeros are skipped unless a non-zero
// digit has already been stored, managed by the `BN_hasLeadingZero` 
// flag. The digits are stored sequentially in `BN_formattedResult` 
// for later display by Role 4.
// Variables used: `decimalValue`, `BN_formattedResult`, 
// `BN_hasLeadingZero`, `tempDivisor`, `tempQuotient`, `tempRemainder`.
// ================================================

(BN_formatDigits)
    // Copy `decimalValue` to `BN_decimalValue`
    @decimalValue
    D=M              // Load `decimalValue`
    @BN_decimalValue
    M=D              // Copy to `BN_decimalValue`

    // Check if the number is negative
    @mq_b2b_negflag
    D=M              // Load `mq_b2b_negflag`
    @SkipNegCheck
    D;JEQ            // If `mq_b2b_negflag` == 0, skip negation
    @BN_decimalValue
    M=-M             // Negate `BN_decimalValue` to make it positive
(SkipNegCheck)

    // Initialize divisor to 10000 (highest place value)
    @10000
    D=A
    @tempDivisor
    M=D

    // Start digit extraction
    @BN_decimalValue
    D=M
    @BN_divide
    0;JMP            // Start division to extract the first digit

(ProcessThousands)
    @1000
    D=A
    @tempDivisor
    M=D              // Set divisor to 1000
    @BN_divide
    0;JMP

(ProcessHundreds)
    @100
    D=A
    @tempDivisor
    M=D              // Set divisor to 100
    @BN_divide
    0;JMP

(ProcessTens)
    @10
    D=A
    @tempDivisor
    M=D              // Set divisor to 10
    @BN_divide
    0;JMP

(ProcessOnes)
    @1
    D=A
    @tempDivisor
    M=D              // Set divisor to 1
    @BN_divide
    0;JMP

(EndFormatDigits)
    @BN_passToDisplay
    0;JMP 

// ================================================
// BN_divide
// -----------------------------------------------
// Implements the division process to extract a single digit 
// from the `decimalValue`. The function subtracts the divisor 
// (`tempDivisor`) repeatedly from `decimalValue`, counting how 
// many times the subtraction occurs (stored in `tempQuotient`). 
// The leftover value is stored as `tempRemainder`.
// Variables used: `decimalValue`, `tempDivisor`, `tempQuotient`, 
// `tempRemainder`.
// ================================================
(BN_divide)
    @tempQuotient
    M=0              // Initialize quotient to 0
(DivideLoop)
    @BN_decimalValue
    D=M
    @tempDivisor
    D=D-M            // Subtract divisor from `BN_decimalValue`
    @EndDivide
    D;JLT            // If result < 0, end division
    @BN_decimalValue
    M=D              // Update `BN_decimalValue` with the remainder
    @tempQuotient
    M=M+1            // Increment quotient
    @DivideLoop
    0;JMP
(EndDivide)
    @BN_decimalValue
    D=M
    @tempRemainder
    M=D              // Store remainder
    @StoreDigits
    0;JMP

(StoreDigits)
    @tempQuotient
    D=M              // Load the current digit (quotient)
    @BN_hasLeadingZero
    A=M              // Check if leading zeros are still active
    D=D+A            // Add leading zero flag to digit
    @SkipDigit
    D;JEQ            // If digit is 0 and leading zeros exist, skip storing
    @BN_formattedResult
    A=M
    M=D              // Store the valid digit in the result buffer
    @BN_formattedResult
    M=M+1            // Move buffer pointer forward
    @BN_hasLeadingZero
    M=0              // Disable leading zero flag (non-zero digit found)
(SkipDigit)
    @tempRemainder
    D=M
    @BN_decimalValue
    M=D              // Update `BN_decimalValue` with remainder
    @tempDivisor
    D=M
    @NextDivisor
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
    0;JMP

//*******************
//INSTRUCTIONS: EITHER CHANGE THE @BN_displayHelper above to a function in Role 4 to jump to and delete all below....
// OR
// have role 4 cut to where the iteration through digit which should be changed to BN_formattedResult is 
//*******************

// ================================================
// BN_displayHelper
// -----------------------------------------------
// This function facilitates displaying the formatted output.
// It explicitly outputs the arrow (->), the sign (based on 
// `mq_b2b_negflag`), and the digits stored in `BN_formattedResult`. 
// Each digit is converted to its ASCII representation and 
// handed off to Role 4 for rendering.
// Variables used: `mq_b2b_negflag`, `BN_formattedResult`.
// ================================================

(BN_displayHelper)
    // Output '->'
    @45             // ASCII code for '-'
    D=A
    @ge_output_-
    0;JMP           // Output '-'

    @62             // ASCII code for '>'
    D=A
    @ge_output_>
    0;JMP           // Output '>'

    // Output sign based on `mq_b2b_negflag`
    @mq_b2b_negflag
    D=M             // Load `mq_b2b_negflag`
    @OutputMinus
    D;JEQ           // If `mq_b2b_negflag` == 1, output '-'
    @OutputPlus
    0;JMP           // Otherwise, output '+'

(OutputMinus)
    @45             // ASCII code for '-'
    D=A
    @ge_output_-
    0;JMP           // Output '-'

(OutputPlus)
    @43             // ASCII code for '+'
    D=A
    @ge_output_+
    0;JMP           // Output '+'

    // Output digits from `BN_formattedResult`
    @BN_formattedResult
    A=M             // Point to the start of the result buffer


// if keep display helper change @Role4_startDisplay to name of function in Role 4 to begin
    
	@Role4_startDisplay
    0;JMP
