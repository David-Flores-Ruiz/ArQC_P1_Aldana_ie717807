/*
 ============================================================================
 Name        : 03_ArQC_TorresHanoi_Recursivo.c
 Author      : David Flores Ruiz
 Version     :
 Copyright   : Your copyright notice
 Description : Hello World in C, Ansi-style
 ============================================================================
 */

#include <stdio.h>
#include <stdlib.h>

void Hanoi ( int n, char org, char dst, char temp ); //Prototipo de la función

int main(void) {
	setvbuf (stdout, NULL, _IONBF, 0);

	int disk;	//Número de discos en la torre A
	printf("¿Cuántos discos desea en su torre?");
	scanf("%d", &disk);
	Hanoi( disk, 'A', 'C', 'B' );

	return EXIT_SUCCESS;
}

void Hanoi ( int n, char org, char dst, char temp ){	//Mi función recursiva
	if ( n == 1 ){		// ##### Caso base #####
		printf("\n Mover Disco%d de %c  a %c  -caso base", n, org, dst);
		return;
	}
	else{		// ##### Caso común (recursivo) #####
		Hanoi( n-1, org, temp, dst );
		printf("\n Mover Disco%d de %c  a %c ", n, org, dst);
		Hanoi( n-1, temp, dst, org );		// Se rotan los nuevos org y dst
	}
}
