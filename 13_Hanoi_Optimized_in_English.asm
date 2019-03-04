#///////////////////////////////////////////////#
#	   Mars4.5 Assembler to MIPS		#
#	    Student: David Flores Ruiz		#
#						#
#	"Resolve de HANOI TOWERS by way of 	#
#		RECURSIVELY"			#
#///////////////////////////////////////////////#
.data 
towerA: .word 0 0 0 0 0 0 0 0	# org
towerB: .word 0 0 0 0 0 0 0 0	# temp
towerC: .word 0 0 0 0 0 0 0 0	# dst

.text
#########################     MAIN     ########################
MAIN:
 addi $s0, $zero, 8	# $s0 = number of disks in initial tower
 add $a0, $zero, $s0	# Parameter of disks
 add $s1, $zero, $s0	# For to building the tower
 
 addi $t1, $zero, 0x1001	# Load High part of Tower A address
 sll $t1, $t1, 16		# Shift 4 nibbles to left
 ori $t1, $t1,   0x0000		# $t1 = 0x1001 0000
 
Construir_torre_en_RAM:
 sw $s1, 0($t1)			# Puts disks in initial tower
 addi $s1, $s1, -1		# n-1
 addi $t1,$t1, 4		# TowerA + 4 bytes
 bne $s1, $zero, Construir_torre_en_RAM

 addi $t1, $zero, 0x1001	# la $t1, torreA   ### $t1 = TowerA = org
 sll $t1, $t1, 16		# $t1 = 0x1001 0000
 ori $t1, $t1,   0x0000		#
 
 addi $t2, $zero, 0x1001	# la $t2, torreB   ### $t2 = TowerB = temp
 sll $t2, $t2, 16		# $t2 = 0x1001 0020
 ori $t2, $t2,   0x0020		#					

 addi $t3, $zero, 0x1001	# la $t3, torreC   ### $t3 = TowerC = dst
 sll $t3, $t3, 16		# $t3 = 0x1001 0040
 ori $t3, $t3,   0x0040		#
 
# /// Constants for future comparations and reduced my IC
 addi $t0, $zero, 0	# $t0 = cte "0" used to erased logic in RAM
 addi $t6, $zero, 1	# $t1 = cte "1" used for subtract one later
 addi $sp, $sp, 4	# Only purpose to watch Stack in order
 
 jal f_Hanoi		# Call to Recursive function from Main
  
 j EXIT			# End of program execution
##############################################################

################  RECURSIVE FUNCTION "HANOI"  ################
 f_Hanoi:
#---------- SAVE 5 variables into STACK ----------#
	addi $sp, $sp, -32	# We take bytes of space from the STACK
	 sw $a0, 0($sp)		# number of disks
	 sw $t1, 4($sp)		# dir. of ORG 
	 sw $t2, 8($sp)		# dir. of Temp
	 sw $t3, 12($sp)	# dir. of DST
	 sw $ra, 16($sp)	# Address RETURN
#-----------------------------------------------#

 	 beq $a0, $t6, casoBase		# if( n == 1 )
 	 
casoRecursivo:		# else make the common case (recursive)		
   #sub $a0, $a0, 1
   addi $a0, $a0, -1	 # disks: n-1
   addi $t1, $t1, 4	 # I go to next disk
   
MOV:	### MOVE THE ORIGIN TO DESTINE "ACCORDING TO PARAMETERS SENT"
   add $t5, $zero, $t2 	 ### $t5 is AUX. for the SWAPEO
   add $t2, $zero, $t3	 ### Interchange temp and dst
   add $t3, $zero, $t5	 ### dst = $t2  and  temp = $t3
  
 jal f_Hanoi	# Second call recursive
 # Here return the first RETURN 
 
   add $t5, $zero, $t2   ### SWAPEO DST and TEMP
   add $t2, $zero, $t3	 ### 
   add $t3, $zero, $t5	 ###
   
Caso_comun:
#//////////////// Validation of the origin and destination position /////////////////
VALIDA_ORG_Y_DST_2:  	
  lw $t4, 0($t3)	
  beq $t4, $zero, Valida_pequeño_2	
  add $t3, $t3, 4
  j VALIDA_ORG_Y_DST_2		
  					  ### For commits check in another code block
Valida_pequeño_2:			
  lw $t5, 0($t1)		
  beq $t5, $zero, End_valid_2
  add $t1, $t1, 4
j Valida_pequeño_2
  
End_valid_2:
 addi $t1, $t1, -4
#////////////////////////////////////////////////////////////////////////////////////
MOV_2:			# Move disk from ORG to DST
   lw $t4, 0($t1)	# Use aux $t4 for the change
   sw $t0, 0($t1)	# Erase the moved disk...
   sw $t4, 0($t3)	# 	... from A to C
   
   add $t5, $zero, $t2 	### $t5 eis AUX. for the SWAPEO
   add $t2, $zero, $t1	### Interchange org and temp
   add $t1, $zero, $t5	### temp = $t1  and  org = $t2
   
   
 jal f_Hanoi	# call recursive
 j end_if	# jump the case base
   
       
casoBase:	# MOVE THE ORIGIN TO DESTINE "ACCORDING TO PARAMETERS SENT"
#//////////////// Validation of the origin and destination position /////////////////
   VALIDA_ORG_Y_DST_1:  
  	lw $t4, 0($t3)		# Load the value of my disk in my dst to aux = $t4
  	beq $t4, $zero, Valida_pequeño_1   # Finish if find 0 in dst	
  	add $t3, $t3, 4		# If else jump to next disk position
 	j VALIDA_ORG_Y_DST_1		
  
   Valida_pequeño_1:		
  	lw $t5, 0($t1)		# Load the value of my disk in my org to aux = $t5
  	beq $t5, $zero, End_valid_1	   # Finish if find 0 in dst
  	add $t1, $t1, 4		# If else review the next disk more up
	j Valida_pequeño_1
  
   End_valid_1:
 	addi $t1, $t1, -4	# I find the smallest disk so... subtract 4 bytes for to get disk
#////////////////////////////////////////////////////////////////////////////////////
MOV_1: 			# Move disk from ORG to DST
   lw $t4, 0($t1)	# Use aux $t4 for the change
   sw $t0, 0($t1)	# Erase the moved disk...
   sw $t4, 0($t3)	# 	... from A to C
   
end_if:
#---------- LOAD 5 variables of the STACK ----------# 
	 lw $a0, 0($sp)
	 lw $t1, 4($sp)	
     # addi $t1, $t1, -4
	 lw $t2, 8($sp)
	 lw $t3, 12($sp)
	 lw $ra, 16($sp)
	addi $sp, $sp, 32	
#------------------------------------------------#
 jr $ra			# RETURN to recursive function HANOI
##############################################################

################# FINISH OF THE PROGRAM #################
EXIT:	# END + NOP
