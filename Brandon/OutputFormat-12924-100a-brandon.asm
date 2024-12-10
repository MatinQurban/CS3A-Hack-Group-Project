// Functions:
// ROLE_3_START
// BN_formatArrow
// BN_formatSpecialCase
// BN_formatSign
// BN_formatDigits
// BN_divide
// BN_displayHelper
// ------------------------------------------

// ------------------------------------------
// Variables:
// isSpecialCase (1 = special case, 0 = normal)
// negFlag (1 = negative, 0 = positive)
// decimalValue (single input from Role 2)
// BN_formattedResult (buffer for digits)
// BN_formattedSign (stores "+" or "-")
// BN_hasLeadingZero (1 = leading zeros exist, 0 = no leading zeros)
// BN_format- (ASCII for '-')
// BN_format> (ASCII for '>')
// tempQuotient (stores quotient during division)
// tempRemainder (stores remainder during division)
// tempDivisor (stores divisor during division)
// ------------------------------------------

(ROLE_3_START)
    @BN_hasLeadingZero
    M=1                  // Initialize leading zero flag to 1
    @BN_formatArrow
    0;JMP                 // Start formatting with arrow

(BN_formatArrow)
    @BN_format-
    M=45                 // ASCII for '-'
    @BN_format>
    M=62                 // ASCII for '>'
    @isSpecialCase
    D=M
    @BN_formatSpecialCase
    D;JEQ                // If special case, handle it
    @BN_formatSign
    0;JMP                 // Otherwise, proceed with sign formatting

(BN_formatSpecialCase)
    @BN_formattedSign
    M=45                 // '-' for the special case
    @BN_formattedResult
    A=M
    M=51                 // ASCII '3'
    M=M+1
    A=M
    M=50                 // ASCII '2'
    M=M+1
    A=M
    M=55                 // ASCII '7'
    M=M+1
    A=M
    M=54                 // ASCII '6'
    M=M+1
    A=M
    M=56                 // ASCII '8'
    M=M+1
    @BN_displayHelper
    0;JMP                 // Pass to Role 4

(BN_formatSign)
    @negFlag
    D=M
    @BN_positiveSign
    D;JEQ                 // If SIGN == 0, jump to positive sign
    @BN_negativeSign
    0;JMP                 // Otherwise, handle negative sign

(BN_positiveSign)
    @BN_formattedSign
    M=43                 // ASCII for '+'
    @BN_formatDigits
    0;JMP

(BN_negativeSign)
    @BN_formattedSign
    M=45                 // ASCII for '-'
    @BN_formatDigits
    0;JMP

(BN_formatDigits)
    // Divide decimalValue by 10000
    @10000
    D=A
    @tempDivisor
    M=D                  // Set divisor to 10000
    @decimalValue
    D=M
    @BN_divide
    0;JMP                // Perform division to extract the digit
(StoreTenThousands)
    @tempQuotient
    D=M
    @BN_hasLeadingZero
    A=M
    D=D+A
    @SkipTenThousands
    D;JEQ                // Skip if leading zero and digit is 0
    @BN_formattedResult
    A=M
    M=D                  // Store digit
    @BN_formattedResult
    M=M+1                // Move buffer pointer
    @BN_hasLeadingZero
    M=0                  // Clear leading zero flag
(SkipTenThousands)
    // Compute the remainder of decimalValue % 10000
    @tempRemainder
    D=M
    @decimalValue
    M=D                  // Update decimalValue with remainder

    // Repeat process for thousands, hundreds, tens, and ones
    @1000
    D=A
    @tempDivisor
    M=D
    @BN_divide
    0;JMP
(StoreThousands)
    @tempQuotient
    D=M
    @BN_hasLeadingZero
    A=M
    D=D+A
    @SkipThousands
    D;JEQ
    @BN_formattedResult
    A=M
    M=D
    @BN_formattedResult
    M=M+1
    @BN_hasLeadingZero
    M=0
(SkipThousands)
    @tempRemainder
    D=M
    @decimalValue
    M=D

    @100
    D=A
    @tempDivisor
    M=D
    @BN_divide
    0;JMP
(StoreHundreds)
    @tempQuotient
    D=M
    @BN_hasLeadingZero
    A=M
    D=D+A
    @SkipHundreds
    D;JEQ
    @BN_formattedResult
    A=M
    M=D
    @BN_formattedResult
    M=M+1
    @BN_hasLeadingZero
    M=0
(SkipHundreds)
    @tempRemainder
    D=M
    @decimalValue
    M=D

    @10
    D=A
    @tempDivisor
    M=D
    @BN_divide
    0;JMP
(StoreTens)
    @tempQuotient
    D=M
    @BN_hasLeadingZero
    A=M
    D=D+A
    @SkipTens
    D;JEQ
    @BN_formattedResult
    A=M
    M=D
    @BN_formattedResult
    M=M+1
    @BN_hasLeadingZero
    M=0
(SkipTens)
    @tempRemainder
    D=M
    @decimalValue
    M=D

    // Extract ones place
    @decimalValue
    D=M
    @BN_formattedResult
    A=M
    M=D                  // Store ones digit
    @BN_formattedResult
    M=M+1                // Move buffer pointer
    @BN_displayHelper
    0;JMP

(BN_divide)
    @tempQuotient
    M=0                  // Initialize quotient to 0
(DivideLoop)
    @decimalValue
    D=M
    @tempDivisor
    A=M
    D=D-A                // Subtract divisor from value
    @EndDivide
    D;JLT                // If result is negative, end division
    @decimalValue
    M=D                  // Update value with the remainder
    @tempQuotient
    M=M+1                // Increment quotient
    @DivideLoop
    0;JMP
(EndDivide)
    @decimalValue
    D=M
    @tempRemainder
    M=D                  // Store remainder
    @tempQuotient
    0;JMP

// here starts where if special case apply negative sign and then output the formattedResult which role4 has function to determine which digit in formattedResult
(BN_displayHelper)
    @isSpecialCase
    D=M
    @SpecialCaseFlow
    D;JEQ                // If special case, handle it

    @BN_formattedSign
    D=M
    @ge_output_+
    D;JEQ                // If sign is '+', display it
    @ge_output_-
    0;JMP                // If sign is '-', display it

(SpecialCaseFlow)
    @BN_format-
    D=M
    @ge_output_-
    0;JMP
    @BN_formattedResult
    A=M
    // Role 4 iterates over buffer to display digits
