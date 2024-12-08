// Functions
// BN_formatArrow
// BN_formatSpecialCase
// BN_formatR0
// BN_formatTenThousands
// BN_formatThousands
// BN_formatHundreds
// BN_formatTens
// BN_formatOnes
// BN_passToDisplay

//from Role2
// isSpecialCase (1=special, 0=no)
// R0 the sign (1 negative 0 positive)
// ten_thousands_place
// thousands_place
// hundreds_place
// tens_place
// ones_place
//ROLE 3 VAR
// BN_formattedSign
// BN_format-
// BN_format>
// BN_tenthousands
// BN_thousands
// BN_tens
// BN_ones
// BN_hasLeadingZero

// RETURN CALLS: (can add if we even need return call but dont believe we do)
// BN_formatArrowReturn
// BN_formatR0Return
// BN_formatTenThousandsReturn
// BN_formatThousandsReturn
// BN_formatHundredsReturn
// BN_formatTensReturn
// BN_formatOnesReturn
// BN_handleSpecialCaseReturn
// BN_passToDisplayReturn

(ROLE_3_START)
	@BN_hasLeadingZero
    M=1                  // Initialize leading zero flag to 1
    @BN_formatArrow
    0;JMP                 // Add the arrow and continue
	
(BN_formatArrow)
    @BN_format-
    M=45                // ASCII for '-'
    @BN_format>
    M=62                // ASCII for '>'
    @isSpecialCase
    D=M
    @BN_formatSpecialCase
    D;JEQ               // If special case, jump to handle it
    @BN_formatR0
    0;JMP               // Otherwise, proceed with R0 formatting

(BN_formatSpecialCase)
    @Sign
    M=-1                  // Set sign to negative for Role 4
    @BN_tenThousands
    M=3                   // Set digits for special case
    @BN_thousands
    M=2
    @BN_hundreds
    M=7
    @BN_tens
    M=6
    @BN_ones
    M=8
    @BN_passToDisplay
    0;JMP              

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
    @BN_formatTenThousands
    0;JMP

(BN_negativeSign)
    @BN_formatted_sign
    M=45                  // ASCII for '-'
    @BN_formatTenThousands
    0;JMP

(BN_formatTenThousands)
    @ten_thousands_place
    D=M                   // Load the digit
    @BN_hasLeadingZero
    A=M
    D=D+A                 // Add leading zero flag to digit
    @BN_formatThousands
    D;JEQ                 // Skip digit if D == 0
    @BN_tenThousands
    M=D                   // Store digit independently
    @BN_hasLeadingZero
    M=0                   // Clear leading zero flag
    @BN_formatThousands
    0;JMP

(BN_formatThousands)
    @thousands_place
    D=M
    @BN_hasLeadingZero
    A=M
    D=D+A                 // Add leading zero flag to digit
    @BN_formatHundreds
    D;JEQ                 // Skip digit if D == 0
    @BN_thousands
    M=D                   // Store digit independently
    @BN_hasLeadingZero
    M=0                   // Clear leading zero flag
    @BN_formatHundreds
    0;JMP

(BN_formatHundreds)
    @hundreds_place
    D=M
    @BN_hasLeadingZero
    A=M
    D=D+A                 // Add leading zero flag to digit
    @BN_formatTens
    D;JEQ                 // Skip digit if D == 0
    @BN_hundreds
    M=D                   // Store digit independently
    @BN_hasLeadingZero
    M=0                   // Clear leading zero flag
    @BN_formatTens
    0;JMP

(BN_formatTens)
    @tens_place
    D=M
    @BN_hasLeadingZero
    A=M
    D=D+A                 // Add leading zero flag to digit
    @BN_formatOnes
    D;JEQ                 // Skip digit if D == 0
    @BN_tens
    M=D                   // Store digit independently
    @BN_hasLeadingZero
    M=0                   // Clear leading zero flag
    @BN_formatOnes
    0;JMP

(BN_formatOnes)
    @ones_place
    D=M                   // Load the ones digit
    @BN_ones
    M=D                   // Store digit independently
    @BN_passToDisplay
    0;JMP

(BN_passToDisplay)
    @Role4_startDisplay
    0;JMP