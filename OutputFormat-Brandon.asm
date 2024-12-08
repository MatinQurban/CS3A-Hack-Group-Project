// Functions
// BN_formatArrow
// BN_formatSpecialCase
// BN_formatSign
// BN_formatTenThousands
// BN_formatThousands
// BN_formatHundreds
// BN_formatTens
// BN_formatOnes
// BN_passToDisplay

// Variables
// isSpecialCase (1=special, 0=no)
// SIGN (1 negative, 0 positive)
// ten_thousands_place
// thousands_place
// hundreds_place
// tens_place
// ones_place
// BN_formattedSign
// BN_resultBuffer (temporary buffer for output storage)
// BN_hasLeadingZero

// RETURN CALLS: (can add if we even need return call but dont believe we do)
// BN_formatArrowReturn
// BN_formatSignReturn
// BN_formatTenThousandsReturn
// BN_formatThousandsReturn
// BN_formatHundredsReturn
// BN_formatTensReturn
// BN_formatOnesReturn
// BN_handleSpecialCaseReturn
// BN_passToDisplayReturn

(ROLE_3_START)
    @BN_formatArrow
    0;JMP                 // Add the arrow and continue

(BN_formatArrow)
    @BN_result_buffer
    A=M
    M=45                  // ASCII for '-'
    @BN_result_buffer
    M=M+1                 // Move buffer pointer forward
    A=M
    M=62                  // ASCII for '>'
    @BN_result_buffer
    M=M+1                 // Move buffer pointer forward
    @isSpecialCase
    D=M
    @BN_formatSpecialCase
    D;JEQ                 // If special case, jump to handle it
    @BN_formatSign
    0;JMP                 // Otherwise, proceed with sign formatting

(BN_formatSpecialCase)
    @BN_result_buffer
    A=M
    M=45                  // ASCII for '-'
    @BN_result_buffer
    M=M+1
    A=M
    M=51                  // ASCII for '3'
    @BN_result_buffer
    M=M+1
    A=M
    M=50                  // ASCII for '2'
    @BN_result_buffer
    M=M+1
    A=M
    M=55                  // ASCII for '7'
    @BN_result_buffer
    M=M+1
    A=M
    M=54                  // ASCII for '6'
    @BN_result_buffer
    M=M+1
    A=M
    M=56                  // ASCII for '8'
    @BN_result_buffer
    M=M+1
    @BN_passToDisplay
    0;JMP                 // Pass to Role 4 for display

(BN_formatSign)
    @Sign
    D=M
    @BN_positiveSign
    D;JEQ                 // If Sign = 0, jump to BN_positiveSign
    @BN_negativeSign
    0;JMP

(BN_positiveSign)
    @BN_formatted_sign
    M=43                  // ASCII for '+'
    @BN_result_buffer
    A=M
    M=43                  // Store '+' in the buffer
    @BN_result_buffer
    M=M+1
    @BN_formatTenThousands
    0;JMP

(BN_negativeSign)
    @BN_formatted_sign
    M=45                  // ASCII for '-'
    @BN_result_buffer
    A=M
    M=45                  // Store '-' in the buffer
    @BN_result_buffer
    M=M+1
    @BN_formatTenThousands
    0;JMP

(BN_formatTenThousands)
    @ten_thousands_place
    D=M                   // Load the digit
    @BN_hasLeadingZero
    D=M+D                 // Check if still leading zero
    @BN_formatThousands
    D;JEQ                 // Skip digit if leading zero
    @BN_result_buffer
    A=M
    M=D                   // Store the digit
    @BN_result_buffer
    M=M+1                 // Move buffer pointer forward
    @BN_hasLeadingZero
    M=0                   // Clear leading zero flag
    @BN_formatThousands
    0;JMP

(BN_formatThousands)
    @thousands_place
    D=M
    @BN_hasLeadingZero
    D=M+D
    @BN_formatHundreds
    D;JEQ                 // Skip digit if leading zero
    @BN_result_buffer
    A=M
    M=D
    @BN_result_buffer
    M=M+1
    @BN_hasLeadingZero
    M=0                   // Clear leading zero flag
    @BN_formatHundreds
    0;JMP

(BN_formatHundreds)
    @hundreds_place
    D=M
    @BN_hasLeadingZero
    D=M+D
    @BN_formatTens
    D;JEQ                 // Skip digit if leading zero
    @BN_result_buffer
    A=M
    M=D
    @BN_result_buffer
    M=M+1
    @BN_hasLeadingZero
    M=0                   // Clear leading zero flag
    @BN_formatTens
    0;JMP

(BN_formatTens)
    @tens_place
    D=M
    @BN_hasLeadingZero
    D=M+D
    @BN_formatOnes
    D;JEQ                 // Skip digit if leading zero
    @BN_result_buffer
    A=M
    M=D
    @BN_result_buffer
    M=M+1
    @BN_hasLeadingZero
    M=0                   // Clear leading zero flag
    @BN_formatOnes
    0;JMP

(BN_formatOnes)
    @ones_place
    D=M
    @BN_result_buffer
    A=M
    M=D                   // Always store the ones digit
    @BN_result_buffer
    M=M+1                 // Move buffer pointer forward
    @BN_passToDisplay
    0;JMP

(BN_passToDisplay)
    @Role4_startDisplay
    0;JMP