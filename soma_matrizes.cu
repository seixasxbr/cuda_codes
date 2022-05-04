#include <stdio.h>
#include <stdlib.h>

#define N 9

__global__ void add(int *a, int *b, int *c) {
	c[blockIdx.x] = a[blockIdx.x] + b[blockIdx.x];
}

void random_ints(int* x, int size)
{
	int i;
	for (i=0;i<size;i++) {
		x[i]=rand()%10;
	}
}

int main(void) 
{
	int *a, *b, *c; // host copies of a, b, c
	int *d_a, *d_b, *d_c; // device copies of a, b, c
	int size = N * sizeof(int);
	
	// Alloc space for device copies of a, b, c
	cudaMalloc((void **)&d_a, size);
	cudaMalloc((void **)&d_b, size);
	cudaMalloc((void **)&d_c, size);
	
	// Alloc space for host copies of a, b, c and setup input values
	a = (int *)malloc(size); 
    a[0]=1;
    a[1]=2;
    a[2]=3;
    a[3]=4;
    a[4]=5;
    a[5]=6;
    a[6]=7;
    a[7]=8;
    a[8]=9;
    // for (int i=0;i<N;i++) {
	// 	printf("a[%d]=%d\n",i,a[i]);
	// }
	b = (int *)malloc(size);
    b[0]=2;
    b[1]=3;
    b[2]=4;
    b[3]=5;
    b[4]=6;
    b[5]=7;
    b[6]=8;
    b[7]=9;
    b[8]=10;
	c = (int *)malloc(size);

	// Copy inputs to device
	cudaMemcpy(d_a, a, size, cudaMemcpyHostToDevice);
	cudaMemcpy(d_b, b, size, cudaMemcpyHostToDevice);
	
	// Launch add() kernel on GPU with N blocks
	add<<<N,1>>>(d_a, d_b, d_c);
	// Copy result back to host
	cudaMemcpy(c, d_c, size, cudaMemcpyDeviceToHost);
	// Cleanup

	for (int i=0;i<N;i++) {
		printf("a[%d]=%d , b[%d]=%d, c[%d]=%d\n",i,a[i],i,b[i],i,c[i]);
	}
    // 
    int M[3][3];
    M[0][0] = c[0];
    M[0][1] = c[1];
    M[0][2] = c[2];
    M[1][0] = c[3];
    M[1][1] = c[4];
    M[1][2] = c[5];
    M[2][0] = c[6];
    M[2][1] = c[7];
    M[2][2] = c[8];
    printf("\n");
    printf("MATRIZ DE RESULTADO:\n");
    printf("M[0][0]=%d, M[0][1]=%d, M[0][2]=%d\nM[1][0]=%d, M[1][1]=%d, M[1][2]=%d\nM[2][0]=%d, M[2][1]=%d, M[2][2]=%d\n",M[0][0],M[0][1],M[0][2],M[1][0],M[1][1],M[1][2],M[2][0],M[2][1],M[2][2]);
    printf("\n");
    for (int j=0;j<3;j++){
        for (int i=0;i<3;i++) {
            int index=j*3+i;
            M[j][i] = c[index];
            printf("M[%d][%d]=%d ",j,i,M[j][i]);
        }
        printf("\n");
    }
    // for (int i=0;i<3;i++) {
    //     M[0][i] = c[i];
	// 	printf("%d ",M[0][i]);
	// }
    
	free(a); free(b); free(c);
	cudaFree(d_a); cudaFree(d_b); cudaFree(d_c);
	return 0;
}