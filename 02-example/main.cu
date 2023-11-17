#include <stdio.h>

__global__
void add(int *a, int *b, int* result)
{
    *result = *a + *b;
}

int main(void)
{
    int *x, *y, result;
    int *d_x, *d_y, *d_result;

    x = (int*)malloc(sizeof(int));
    y = (int*)malloc(sizeof(int));

    cudaMalloc(&d_x, sizeof(int));
    cudaMalloc(&d_y, sizeof(int));
    cudaMalloc(&d_result, sizeof(int));
    
    *x = 1;
    *y = 2;

    cudaMemcpy(d_x, x, sizeof(int), cudaMemcpyHostToDevice);
    cudaMemcpy(d_y, y, sizeof(int), cudaMemcpyHostToDevice);

    add<<<1024, 16>>>(d_x, d_y, d_result);

    cudaMemcpy(&result, d_result, sizeof(int), cudaMemcpyDeviceToHost);

    printf("%d\n", result);

    cudaFree(d_x);
    cudaFree(d_y);
    cudaFree(d_result);
    free(x);
    free(y);
}