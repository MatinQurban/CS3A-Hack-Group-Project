// ============================= MAIN =============================

    // read and print inputs from user
pw_rpKey
//Create return address
@main-after_pw_rpKey
D=A
@return_pw_rpKey

    // convert binary word in R0-15 into decimal value
mq_convert

    // convert result to print
bw_outputFormat

    // output result
kl_outputValue

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