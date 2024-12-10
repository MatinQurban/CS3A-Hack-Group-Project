/ Role2-Variables
/ decimalValue
/ mq_b2b_negflag Indicates the sign of the number: 1 for negative, 0 for positive.
/ Role3 - Variables
/ isSpecialCase A flag set to 1 if the value is the special case (-32768), otherwise 0.
/ decimalValue (single input from Role 2)
/ BN_formattedResult (buffer for digits, stores numeric values)
/ BN_formattedSign (stores "+" or "-")
/ BN_hasLeadingZero (1 = leading zeros exist, 0 = no leading zeros)
/ tempQuotient (stores quotient during division)
/ tempRemainder (stores remainder during division)
/ tempDivisor (stores divisor during division)

// Functions
/ OUTPUT_FORMATTING_BEGIN
/ BN_formatSign - Determines and stores the sign (+ or -) in BN_formattedSign.
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
    @BN_formatSign
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
    @10000
    D=A
    @tempDivisor
    M=D              // Initialize divisor to 10000 (highest place value)
    @decimalValue
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
    0;JMP            // Hand off to Role 4 for display

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
    @decimalValue
    D=M
    @tempDivisor
    D=D-M            // Subtract divisor from decimalValue
    @EndDivide
    D;JLT            // If result < 0, end division
    @decimalValue
    M=D              // Update decimalValue with the remainder
    @tempQuotient
    M=M+1            // Increment quotient
    @DivideLoop
    0;JMP
(EndDivide)
    @decimalValue
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
    @decimalValue
    M=D              // Update decimalValue with remainder
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

// ================================================
// BN_displayHelper
// -----------------------------------------------
// This function facilitates displaying the formatted output.
// It first outputs the sign (from `BN_formattedSign`), then 
// iterates through the digits stored in `BN_formattedResult`. 
// Each digit is converted to its ASCII representation and 
// handed off to Role 4 for rendering.
// Variables used: `BN_formattedSign`, `BN_formattedResult`.
// ================================================
(BN_displayHelper)
	@BN_format-
    D=M
    @ge_output_-
    0;JMP            // Output '-'.

    @BN_format>
    D=M
    @ge_output_>
    0;JMP            // Output '>'.
	
    @mq_b2b_negflag
    D=M          // Load mq_b2b_negflag value into D
    @ge_output_-
    D;JEQ        // Jump to output '-' if mq_b2b_negflag is 1

    @ge_output_+
    0;JMP        // Otherwise, jump to output '+'


    @BN_formattedResult
    A=M              // Point to the start of the result buffer
(DisplayDigits)
    D=M              // Load digit from buffer
    @ge_output_0
    D=D+A            // Adjust to ASCII for display
    0;JMP


//
// unless i am mistaken i believe kevin can skip to the function that iterates through his 'digit' variable 
replace digit with formattedResult and his function will go through the stored decimal value and output the correct to display
//
    // Hand off to Role 4 for displaying digits using variable BN_formattedResult
    
	@Role4_startDisplay
    0;JMP



/// **********************
/// likely delete below 
/// **********************
	
//dont beleive we need special case handling should be handled in role 2
/(BN_handleSpecialCaseR0R15)
/    @R0
/    D=M
/    @SpecialCaseCheck
/    D;JLT
/    @BN_formatSign
/    0;JMP

/(SpecialCaseCheck)
/    @R0
/    D=M
/    @R15
/    D=D+M
/    @SpecialCaseMatch
/    D;JEQ
/   @BN_formatSign
/    0;JMP

/(SpecialCaseMatch)
/   @isSpecialCase
/    M=1
/   @mq_b2b_negflag
/    M=1
/    @BN_formattedResult
/    A=M
/    M=3                // Numeric value 3
/    M=M+1
/    A=M
/    M=2                // Numeric value 2
/    M=M+1
/    A=M
/    M=7                // Numeric value 7
/    M=M+1
/    A=M
/    M=6                // Numeric value 6
/    M=M+1
/    A=M
/    M=8                // Numeric value 8
/    M=M+1
/    @BN_passToDisplay
/   0;JMP	

// ================================================
// BN_formatSign
// -----------------------------------------------
// Determines the sign of the decimal value. If `mq_b2b_negflag` is 1,
// the number is negative, and the function sets `BN_formattedSign` 
// to '-' (ASCII 45). If `mq_b2b_negflag` is 0, the number is positive, 
// and the function sets `BN_formattedSign` to '+' (ASCII 43).
// This function then passes control to the BN_formatDigits function.
// Variables used: `mq_b2b_negflag`, `BN_formattedSign`.
// ================================================

(BN_formatSign)
    @mq_b2b_negflag
    D=M
    @BN_positiveSign
    D;JEQ            // If mq_b2b_negflag is 0, jump to positive sign
    @BN_negativeSign
    0;JMP            // Otherwise, handle negative sign

(BN_positiveSign)
    @BN_formattedSign
    M=43             // ASCII for '+'
    @BN_formatDigits
    0;JMP

(BN_negativeSign)
    @BN_formattedSign
    M=45             // ASCII for '-'
    @BN_formatDigits
    0;JMP