// ============================= MAIN =============================

    // read and print inputs from user
// Create return address
@main-after_pw_getInput
D=A
@pw_getInput_return
M=D

// call get input
@pw_getInput
0;JMP

(main-after_pw_rpInput)
// At this point the user has hit enter, and stored a 16-bit binary word in R0-15 registers

    // convert binary word in R0-15 into decimal value
//mq_convert
// Create return address
@main-after_mq_convert
D=A
@mq_convert_return
M=D

// call convert
@mq_convertB2D
0;JMP

(main-after_mq_convert)
// At this point we have a converted to decimal 2's complement binary word into variable decimalValue

    // convert result to print
// Create return address
@main-after_BN_format
D=A
@BN_displayHelper
M=D

// call format
@BN_formatDigits
0;JMP

(main-after_BN_format)
//Now, all the digits and their respective places are being held in the array BN_formatDigits.
    
    // output result
//kl_outputValue

//output arrow:
// Create return address
@main-after_kl_arrow
D=A
@KL_outputArrowReturn
M=D

@KL_outputArrow //call
0;JMP

(main-after_kl_arrow)

//output sign and number:
// Create return address
@main-after_kl_sign
D=A
@KL_outputSign_return
M=D

@KL_outputSign
0;JMP       // call

(main-after_kl_sign)

@ENDB2D_MAIL_FILE
0;JMP

// ============================= END MAIN =============================



// ============================= FUNCTIONS =============================

//import parker main (exclude helpers like ge_output)



//import matin convert (exclude helpers like pow and mult)



//import brandon format (no ge_outputx)



//import kevin output (no ge_outputx)


// convert helpers
    // pow
    // mult

// output helpers
    //ge_output_x








(ENDB2D_MAIL_FILE)