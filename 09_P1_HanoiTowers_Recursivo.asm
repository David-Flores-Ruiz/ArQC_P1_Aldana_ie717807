#///////////////////////////////////////////////#
#	   Mars4.5 Ensamblador del MIPS		#
#	    Alumno: David Flores Ruiz		#
#						#
#	"Resolver las TORRES DE HANOI de 	#
#		forma RECURSIVA"		#
#///////////////////////////////////////////////#
.data 
torreA: .word 0


.text
##################	MAIN	 #################
MAIN:
 addi $s0, $zero, 3	# En $s0 se guarda el NUM de DISCOS de la torre
 add $a0, $zero, $s0	# Parametro de DISCOS
 add $t0, $zero, $s0	# El mayor valor para construir la torre
 
 la $t1, torreA		# Carga dirección inicial de la torre A
 
Construir_torre_en_RAM:
 sw $t0, 0($t1)
 sub $t0, $t0, 1
 addi $t1,$t1, 4	# Desplazamos la dirreccion para nuevo dato
 bne $t0, $zero, Construir_torre_en_RAM
 
 
 jal f_Hanoi
 
  j EXIT

############### FUNCION RECURSIVA ###############
 f_Hanoi:
 




 jr $ra			# RETURN a la función recursiva

################# FIN DE PROGRAMA #################
EXIT: add $a0, $a0, $zero	# FIN + NOP