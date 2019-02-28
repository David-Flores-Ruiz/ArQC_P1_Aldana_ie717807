#///////////////////////////////////////////////#
#	   Mars4.5 Ensamblador del MIPS		#
#	    Alumno: David Flores Ruiz		#
#						#
#	"Resolver las TORRES DE HANOI de 	#
#		forma RECURSIVA"		#
#///////////////////////////////////////////////#
.data 
torreA: .word 0 0 0 0 0 0 0 0	# Caso máx. con 8 discos
torreB: .word 0 0 0 0 0 0 0 0
torreC: .word 0 0 0 0 0 0 0 0

.text
##################     MAIN     #################
MAIN:
 addi $s0, $zero, 3	# En $s0 se guarda el NUM de DISCOS de la torre
 add $a0, $zero, $s0	# Parametro de DISCOS
 add $s1, $zero, $s0	# El mayor valor para construir la torre
 
 addi $t0, $zero, 0	# $t0 = 0, para BORRAR en RAM
 addi $t1, $zero, 0x1001	# Carga parte Alta de dir. de Torre A
 sll $t1, $t1, 16		# $t1 = 0x1001 0000
 
Construir_torre_en_RAM:
 sw $s1, 0($t1)		# Discos en TORRE
 sub $s1, $s1, 1	# Restas uno para poner el disco de arriba
 addi $t1,$t1, 4	# Desplazamos la dirreccion para nuevo dato
 bne $s1, $zero, Construir_torre_en_RAM

 addi $t1, $zero, 0x1001	# la $t1, torreA	### torreA es mi  ORG
 sll $t1, $t1, 16		# $t1 = 0x1001 0000
 addi $t1, $t1,   0x0000	#
 
 addi $t2, $zero, 0x1001	# la $t2, torreB	### torreB es mi  temp
 sll $t2, $t2, 16		# $t2 = 0x1001 0020
 addi $t2, $t2,   0x0020	#					

 addi $t3, $zero, 0x1001	# la $t3, torreC	### torreC es mi  DST
 sll $t3, $t3, 16		# $t3 = 0x1001 0040
 addi $t3, $t3,   0x0040	#
 
 jal f_Hanoi
 
 j EXIT

############### FUNCION RECURSIVA ###############
 f_Hanoi:	# MUEVE DEL ORIGEN AL DST "SEGÚN LOS PARÁMETROS MANDADOS"
#---------- SAVE 2 variables en STACK ----------#
	addi $sp, $sp, -20	# Pedimos bytes de espacio del Stack
	 sw $a0, 0($sp)		# altura: num. de discos
	 sw $t1, 4($sp)		# dir. de ORG 
	 sw $t2, 8($sp)		# dir. de Temp
	 sw $t3, 12($sp)	# dir. de DST
	 sw $ra, 16($sp)	# Address RETURN
#-----------------------------------------------#
 beq $a0, 1, casoBase		# if( n == 1 )
  casoRecursivo:		# else haz el caso comun (recursivo)		
   #add $t7, $zero, $a0
   sub $a0, $a0, 1	 # discos n-1 
   addi $t1, $t1, 4	 # posicionarme en 1 disco más arriba
   add $t5, $zero, $t2 #la $t5, 0($t2)	### $t5 es AUX. para el SWAPEO
   add $t2, $zero, $t3	 ### Intercambiamos temp y dst
   add $t3, $zero, $t5	 ### dst = $t2  y  temp = $t3
 
 jal f_Hanoi	# llamado recursivo
 # aqui regresa el primer RETURN 
Mueve_disco_de_ORG_a_DST:
   add $t5, $zero, $t2   ### SWAPEO ORG y DST
   add $t2, $zero, $t3	 ### 
   add $t3, $zero, $t5	 ###
#   sub $t1, $t1, 4 	# regresa un disco para atrás
   lw $t4, 0($t1)		# if (n == 1) entonces: Mueve disco...
   sw $t0, 0($t1)		# Borra disco movido
   sw $t4, 0($t3)		# ... de A  a C
   #NO va!!! #sub $a0, $a0, 1	# discos n-1 
   la $t5, 0($t2) 	### $t5 es AUX. para el SWAPEO
   la $t2, 0($t1)	### Intercamnbiamos org y temp
   la $t1, 0($t5)	### temp = $t1  y  org = $t2
 jal f_Hanoi	# llamado recursivo
 j end_if
  casoBase:	# Mueve_disco_de_ORG_a_DST #
  lw $t4, 0($t3)	# Cargoo el valor de mi DESTINO a un aux. que es $t4
  beq $t4, 0, Mueve_de_ORG_a_DST	# Si no hay disco ya puedo mover
  add $t3, $t3, 4
  j casoBase		# Salta un disco arriba si hay algo escrito en el DESTINO  
Mueve_de_ORG_a_DST:
   lw $t4, 0($t1)		# if (n == 1) entonces: Mueve disco...
   sw $t0, 0($t1)		# Borra disco movido
   sw $t4, 0($t3)		# ... de A  a C
   		
  end_if:
   add $v0, $zero, $v0		# NOP... RETURN con $v0
#---------- LOAD 2 variables del STACK ----------# 
	 lw $a0, 0($sp)
	 lw $t1, 4($sp)
   sub $t1, $t1, 4 	# Del disco anterior baja 1
	 lw $t2, 8($sp)
	 lw $t3, 12($sp)
	 lw $ra, 16($sp)
	addi $sp, $sp, 20	
#------------------------------------------------#
 jr $ra			# RETURN a la función recursiva

################# FIN DE PROGRAMA #################
EXIT: add $a0, $a0, $zero	# FIN + NOP
