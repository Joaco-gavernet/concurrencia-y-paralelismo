#include <pthread.h>
#include <stdio.h>
#include <semaphore.h>
#define  SHARED 1

sem_t vacio, lleno;
int dato, numItems;

void *Productor(void *);
void *Consumidor(void *);


int main(int argc, char *argv[]) {
	printf("Inicializando...\n");
	sem_init(&vacio,SHARED,1);
	sem_init(&lleno,SHARED,0);

	pthread_create(&pid,&attr,Productor,NULL);
	pthread_create(&cid,&attr,Consumidor,NULL);

	pthread_join(pid,NULL);
	pthread_join(cid,NULL);

	return 0;
}


void *Productor(void *arg) {
	int item;
	for (item = 1; item <= numItems; item++) {
		sem_wait(&vacio); // hace de P(sem)
		dato = item;
		sem_post(&lleno); // hace de V(sem)
	}
	pthread_exit();
}

void *Consumidor(void *arg) {
	int total = 0, item, aux;
	for (item = 1; item <= numItems; item++) {
		sem_wait(&lleno);
		aux = dato;
		sem_post(&vacio);
		total = total + aux;
	}
	printf("TOTAL: %d\n", total);
	pthreads_exit();
}
