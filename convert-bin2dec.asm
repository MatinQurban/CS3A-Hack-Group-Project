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

//============================== CONVERT B2D FUNCTION ==============================
// Numbers are going to be stored in registers R0 - R15
// with sign bit in R0, and msb in R1
// Algorithm is as follows:
// decimalValue = decimalValue + R[i] * POW(2 , exp)
// with exp = 14 - i
// After decimalValue has been calculated, check sign bit.
// if sign bit == 1, decimalValue = -decimalValue

//  set loop control variable and also exponent dependency
@14
D=A
@lcvB2D
M=D

//  set decimalValue (accumulator)
@decimalValue
M=0


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
A=D+A  //Get R[i]
D=M    //Store R[i] in D-reg

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

//Calc: 
//  decimalValue = decimalValue + R[i] * POW(2, exp)
//  exp = 14 - lcvB2D

(endCB2D_loop)


//============================== END CONVERT B2D FUNCTION ==============================




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