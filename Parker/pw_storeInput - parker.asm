(pw_storeInput)
	
	@tostore
	D=M
	
	@pw_store_0
	D;JEQ
	
	@pw_store_1
	D;JGT
	
	@pw_store_clear
	D;JLT
	
	(pw_store_0)
	
		@position
		A=M
		M=0
		
		@pw_storeInput_end
		0;JMP
	
	(pw_store_1)
	
		@position
		A=M
		M=1
		
		@pw_storeInput_end
		0;JMP
		
	(pw_store_clear)
	
		@position
		A=M
		M=-1
		
	(pw_storeInput_end)
	
		@pw_storeInput_return
		A=M
		0;JMP