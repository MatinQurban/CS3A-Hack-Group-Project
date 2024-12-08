// Create a power program Pow.asm that computes 
// z = x to the power of y, where y must be >= 1
// *
// You MUST convert your Multi.asm program into a function in your Pow.asm
//and call this function in a loop in order to implement the exponentiation.
// *
// *
// x must be stored in R3, y in R4, and the result z in R5. 
// You must not modify R3 or R4. You may use variables and other 
// registers except for R0, R1, and R2 which are dedicated
// to your Mult function.


    //Creating LCVpow
@R4
D=M
@LCVpow
M=D
    //Case: Power of 1
@R3     // x into D-reg
D=M
@R5     // z = x
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

        
        //Set R1 and R0 vals to x and z to prepare for calling mult
    @R3     //Get x
    D=M     //Store x in D-reg
    @R0     //Store x in R0
    M=D

    @R5     //Get z
    D=M     //Store z in D-reg
    @R1     //Store z in R1
    M=D


        //Create return address
    @next
    D=A
    @return
    M=D

        //Call MULT FUNCTION, will compute R0 * R1 and store it in R2
    @MULT
    0;JMP
    (next)  //call return address to continue here
    
    
    //At this point, we have {x * z} stored in R2, lets store this new value in z (R5), decremenet LCV, and loop

        //Store result of MULT into R5 (z)
    @R2
    D=M
    @R5
    M=D

        //decremenet LCV
    @LCVpow
    M=M-1

        //Loop
    @loopPow
    0;JMP

(ENDPOW)



// --------- MULT FUNCTION ---------
(MULT)

    // Multiplies R0 and R1 and stores the result in R2.
    // (R0, R1, R2 refer to RAM[0], RAM[1], and RAM[2], respectively.)
    // The algorithm is based on repetitive addition.
    //loop add z = z+x (y times) OR add z = z+y (x times)

    //First check if lcv is negative
    @R1
    D=M

    @negflag //create a negflag variable
    M=0 //set it to false off the bat

    @notneg //if (D [currently R1 is stored] is > 0), then jump to notneg
    D;JGT
    D;JEQ //in case acculmulater is 0

    // else, R1(LCV) is negative, so change negflag to true (or just not false(0), in this case 1 but could be any number)
    @negflag
    M=1

    @R1
    M=-M //and also change the sign of the LCV

    (notneg)
    //... 4a Mult, leave this unchanged ...
    @R2
    M=0 //Make sure value of R2(accumulater) starts at 0

    //Setting loop control variable
    @R1
    D=M //save value of R1 into D
    @LCVmult
    M=D //save value of D (val of R1) into LCV

    (loop)

        // Check LCV
        @LCVmult 
        D=M 
        @loopEnd 
        D;JEQ // if (LCV == 0) end loop

        @R2
        D=M // Current acculated value loaded into D
        
        // z=z+x (y times)
        @R0
        D=D+M 
        @R2
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
    @R2
    M=-M

    //Switch the LCV(R1) sign back so R1 remains unchanged
    @R1
    M=-M


    (ENDMULT)
// Return back to where the function was called
@return
A=M
0;JMP

(END)