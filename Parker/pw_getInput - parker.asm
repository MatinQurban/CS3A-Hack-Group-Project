@position
M=0

(pw_getInput)

	@position
	D=M
		
	@16
	D=D-A
		
	@pw_non_integer_input
	D;JEQ

	// check for input '0' (ASCII 48)
	@KBD
	D=M
		
	@48
	D=D-A
	@pw_input_0
	D;JEQ
	
	// check for input '1' (ASCII 49)
	@KBD
	D=M
	
	@49
	D=D-A
	@pw_input_1
	D;JEQ
	
	(pw_non_integer_input)

		@position
		D=M
	
		@16
		D=D-A

		@pw_position_not_16
		D;JNE
	
		// check for input "Enter" (ASCII 128)
		@KBD
		D=M
	
		@128
		D=D-A
		@pw_input_enter
		D;JEQ
	
	(pw_position_not_16)
	
		@position
		D=M

		@pw_position_0
		D;JEQ
	
		// check for input "Backspace" (ASCII 129)
		@KBD
		D=M
	
		@129
		D=D-A
		@pw_input_backspace
		D;JEQ
	
		// check for input 'C' (ASCII 67)
		@KBD
		D=M
	
		@67
		D=D-A
		@pw_input_c
		D;JEQ
		
	(pw_position_0)
	
		// check for input 'Q' (ASCII 81)
		@KBD
		D=M
	
		@81
		D=D-A
		@pw_input_q
		D;JEQ
		
		@pw_getInput
		0;JMP
	
	(pw_input_0)
	
		@tostore
		M=0
		
		@pw_input_0_continue_A
		D=A
		@pw_storeInput_return
		M=D
		@pw_storeInput
		0;JMP
		
		(pw_input_0_continue_A)
	
			@pw_input_0_continue_B
			D=A
			@ge_output_return
			M=D
			@ge_output_0
			0;JMP
	
			(pw_input_0_continue_B)
		
				@position
				M=M+1
				D=M
		
				@ge_currentColumn
				M=D	
		
				@pw_getInput_end
				0;JMP

	(pw_input_1)
	
		@tostore
		M=1
		
		@pw_input_1_continue_A
		D=A
		@pw_storeInput_return
		M=D
		@pw_storeInput
		0;JMP
		
		(pw_input_1_continue_A)
	
			@pw_input_1_continue_B
			D=A
			@ge_output_return
			M=D
			@ge_output_1
			0;JMP
	
			(pw_input_1_continue_B)
		
				@position
				M=M+1
				D=M
		
				@ge_currentColumn
				M=D	
		
				@pw_getInput_end
				0;JMP

	(pw_input_enter)
	
		@pw_input_enter_continue_A
		D=A
		@ge_output_return
		M=D
		@ge_output_-
		0;JMP
		
		(pw_input_enter_continue_A)
		
			@position
			M=M+1
			D=M
			
			@ge_currentColumn
			M=D		
			
			@pw_input_enter_continue_B
			D=A
			@ge_output_return
			M=D
			@ge_output_g
			0;JMP
			
			(pw_input_enter_continue_B)
			
				@position
				M=M+1
				D=M
		
				@ge_currentColumn
				M=D	
			
				@pw_getInput_return
				A=M
				0;JMP
			
	(pw_input_backspace)
	
		@position
		M=M-1
		D=M
		
		@ge_currentColumn
		M=D
		
		@tostore
		M=-1
		
		@pw_input_backspace_continue_A
		D=A
		@pw_storeInput_return
		M=D
		@pw_storeInput
		0;JMP
		
		(pw_input_backspace_continue_A)
	
			@pw_input_backspace_continue_B
			D=A
			@ge_output_return
			M=D
			@ge_output_s
			0;JMP
	
			(pw_input_backspace_continue_B)
	
				@pw_getInput_end
				0;JMP		

	(pw_input_c)
	
		(pw_while_position_not_0)
		
			@position
			M=M-1
			D=M
		
			@ge_currentColumn
			M=D
	
			@tostore
			M=-1
		
			@pw_input_c_continue_A
			D=A
			@pw_storeInput_return
			M=D
			@pw_storeInput
			0;JMP
			
			(pw_input_c_continue_A)
	
				@pw_input_c_continue_B
				D=A
				@ge_output_return
				M=D
				@ge_output_s
				0;JMP
	
				(pw_input_c_continue_B)
			
					@position
					D=M
				
					@pw_while_position_not_0
					D;JNE
	
					@pw_getInput_end
					0;JMP		

	(pw_input_q)
	
		@pw_getInput_return
		A=M
		0;JMP

	(pw_getInput_end)
	
		(pw_wait_for_reset)
		
			@KBD
			D=M
		
			@pw_wait_for_reset
			D;JNE
	
		@pw_getInput
		0;JMP