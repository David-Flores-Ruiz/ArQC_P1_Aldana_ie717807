#///////////////////////////////////////////////#
#	   Mars4.5 Ensamblador del MIPS		#
#	    Alumno: David Flores Ruiz		#
#						#
#	"Resolver las TORRES DE HANOI de 	#
#		forma RECURSIVA"		#
#///////////////////////////////////////////////#
.data 
torreA: .word 0 0 0 0 0 0 0 0	# Caso m�x. con 8 discos
torreB: .word 0 0 0 0 0 0 0 0
torreC: .word 0 0 0 0 0 0 0 0

.text
##################     MAIN     #################
MAIN:
 addi $s0, $zero, 8	# En $s0 se guarda el NUM de DISCOS de la torre
 add $a0, $zero, $s0	# Parametro de DISCOS
 add $s1, $zero, $s0	# El mayor valor para construir la torre
 
 addi $t0, $zero, 0		# $t0 = 0, para BORRAR en RAM
 addi $t1, $zero, 0x1001	# Carga parte Alta de dir. de Torre A
 sll $t1, $t1, 16		# $t1 = 0x1001 0000
 ori $t1, $t1,   0x0000	
 
Construir_torre_en_RAM:
 sw $s1, 0($t1)		# Discos en TORRE
 addi $s1, $s1, -1	# Restas uno para poner el disco de arriba
 addi $t1,$t1, 4	# Desplazamos la dirreccion para nuevo dato
 bne $s1, $zero, Construir_torre_en_RAM

 addi $t1, $zero, 0x1001	# la $t1, torreA	### torreA es mi  ORG
 sll $t1, $t1, 16		# $t1 = 0x1001 0000
 ori $t1, $t1,   0x0000		#
 
 addi $t2, $zero, 0x1001	# la $t2, torreB	### torreB es mi  temp
 sll $t2, $t2, 16		# $t2 = 0x1001 0020
 ori $t2, $t2,   0x0020		#					

 addi $t3, $zero, 0x1001	# la $t3, torreC	### torreC es mi  DST
 sll $t3, $t3, 16		# $t3 = 0x1001 0040
 ori $t3, $t3,   0x0040		#
 
 addi $t6, $zero, 1		# Para restar 1 con el registro m�s adelante y bajar el IC
 
 jal f_Hanoi
 
 j EXIT



############### FUNCION RECURSIVA ###############
 f_Hanoi:	# MUEVE DEL ORIGEN AL DST "SEG�N LOS PAR�METROS MANDADOS"
#---------- SAVE 5 variables en STACK ----------#
	addi $sp, $sp, -20	# Pedimos bytes de espacio del Stack
	 sw $a0, 0($sp)		# altura: num. de discos
	 sw $t1, 4($sp)		# dir. de ORG 
	 sw $t2, 8($sp)		# dir. de Temp
	 sw $t3, 12($sp)	# dir. de DST
	 sw $ra, 16($sp)	# Address RETURN
#-----------------------------------------------#
 beq $a0, $t6, casoBase		# if( n == 1 )
  casoRecursivo:		# else haz el caso comun (recursivo)		
   #sub $a0, $a0, 1
   addi $a0, $a0, -1	 # discos n-1
   addi $t1, $t1, 4	 # posicionarme en 1 disco m�s arriba
   
MOV:
   add $t5, $zero, $t2 	 # cambio de instrucci�n: la $t5, 0($t2)   ### $t5 es AUX. para el SWAPEO
   add $t2, $zero, $t3	 ### Intercambiamos temp y dst
   add $t3, $zero, $t5	 ### dst = $t2  y  temp = $t3
  
 jal f_Hanoi	# llamado recursivo
 # aqui regresa el primer RETURN 
 
   add $t5, $zero, $t2   ### SWAPEO TEMP y DST
   add $t2, $zero, $t3	 ### 
   add $t3, $zero, $t5	 ###
   
Caso_comun:
 # j VALIDA_ORG_Y_DST_2

  #//////////////// FUNCION VALIDAR /////////////////
VALIDA_ORG_Y_DST_2:  
  lw $t4, 0($t3)	# Cargo el valor de mi DESTINO a un aux. que es $t4
  beq $t4, $zero, Valida_peque�o_2	# Si no hay disco ya puedo ahora ir a validar mi origen
  add $t3, $t3, 4		# Salta un disco arriba si hay algo escrito en el DESTINO
  j VALIDA_ORG_Y_DST_2		
  
Valida_peque�o_2:			# Revisa hasta que estes en el disco de hasta arriba (el m�s peque�o)
  lw $t5, 0($t1)		# Una vez que encuentres 0s le restas 4 bytes para obtener disco
  beq $t5, $zero, End_valid_2
  add $t1, $t1, 4
j Valida_peque�o_2
  
End_valid_2:
 addi $t1, $t1, -4
#/////////////////////////////////////////////////
  
MOV_2: # Mueve_disco_de_ORG_a_DST
   lw $t4, 0($t1)		# if (n == 1) entonces: Mueve disco...
   sw $t0, 0($t1)		# Borra disco movido
   sw $t4, 0($t3)		# ... de A  a C
   
   add $t5, $zero, $t2 	### $t5 es AUX. para el SWAPEO
   add $t2, $zero, $t1	### Intercamnbiamos org y temp
   add $t1, $zero, $t5	### temp = $t1  y  org = $t2
   
 jal f_Hanoi	# llamado recursivo
 j end_if
     
  casoBase:	# Mueve_disco_de_ORG_a_DST #
#  j VALIDA_ORG_Y_DST_1
  
#//////////////// FUNCION VALIDAR /////////////////
VALIDA_ORG_Y_DST_1:  
  lw $t4, 0($t3)	# Cargo el valor de mi DESTINO a un aux. que es $t4
  beq $t4, $zero, Valida_peque�o_1	# Si no hay disco ya puedo ahora ir a validar mi origen
  add $t3, $t3, 4		# Salta un disco arriba si hay algo escrito en el DESTINO
  j VALIDA_ORG_Y_DST_1		
  
Valida_peque�o_1:			# Revisa hasta que estes en el disco de hasta arriba (el m�s peque�o)
  lw $t5, 0($t1)		# Una vez que encuentres 0s le restas 4 bytes para obtener disco
  beq $t5, $zero, End_valid_1
  add $t1, $t1, 4
j Valida_peque�o_1
  
End_valid_1:
 addi $t1, $t1, -4
#////////////////////////////////////////////////

MOV_1: # Mueve_de_ORG_a_DST
   lw $t4, 0($t1)		# if (n == 1) entonces: Mueve disco...
   sw $t0, 0($t1)		# Borra disco movido
   sw $t4, 0($t3)		# ... de A  a C
 
  end_if:
#---------- LOAD 5 variables del STACK ----------# 
	 lw $a0, 0($sp)
	 lw $t1, 4($sp)
#sub $t1, $t1, 4 	
#	 addi $t1, $t1, -4	# Del disco anterior baja 1 ######################## Comentar esta baja IC, pero no tiene l�gica
	 lw $t2, 8($sp)
	 lw $t3, 12($sp)
	 lw $ra, 16($sp)
	addi $sp, $sp, 20	
#------------------------------------------------#
 jr $ra			# RETURN a la funci�n recursiva

################# FIN DE PROGRAMA #################
EXIT:	# FIN + NOP
