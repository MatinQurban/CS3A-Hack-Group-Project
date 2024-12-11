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
/ HandleZero
/ BN_decimalValue
// Functions
/ OUTPUT_FORMATTING_BEGIN
/ BN_formatDigits - BN_formatDigits extracts and formats each digit of the decimal value into BN_formattedResult. Leading zeros are skipped until a non-zero digit is encountered.
/ BN_divide - Performs division to extract each digit from the decimal value. Updates tempQuotient and tempRemainder.

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
    M=1              // Disable leading zeros
(SkipDigit)
//test code:
@91
D=M
@91
M=D
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
    0;JMP