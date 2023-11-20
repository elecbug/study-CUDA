#include <string>
#include <iostream>
#include <thread>
#include <chrono>

using namespace std;
using namespace std::chrono;

void task1(string msg)
{
    cout << "task1 says: " << msg;
}

void use_thread()
{
    thread t1(task1, "Hello");
    t1.join();
}

void xor_cpu(size_t *dst, size_t *src, size_t* size)
{
    for (int i = 0; i < *size; i++)
    {
        dst[i] = dst[i] ^ src[i];
    }
}

__global__
void xor_gpu(size_t *dst, size_t *src, size_t* size)
{
    for (int i = 0; i < *size; i++)
    {
        dst[i] = dst[i] ^ src[i];
    }
}

void check_time_cpu(int tried)
{
    milliseconds ms1 = duration_cast<milliseconds>(system_clock::now().time_since_epoch());

    size_t size = 1 << 20;
    size_t *src, *dst;
        
    src = (size_t*)malloc(sizeof(size_t) * size);
    dst = (size_t*)malloc(sizeof(size_t) * size);

    for (int i = 0; i < tried; i++)
    {
        xor_cpu(dst, src, &size);
    }

    free(src);
    free(dst);

    milliseconds ms2 = duration_cast<milliseconds>(system_clock::now().time_since_epoch());

    printf("CPU: %lld\n", (ms2 - ms1).count());
}

void check_time_gpu(int tried)
{
    milliseconds ms1 = duration_cast<milliseconds>(system_clock::now().time_since_epoch());

    size_t size = 1 << 20;
    size_t *src, *dst;
        
    cudaMalloc(&src, sizeof(size_t) * size);
    cudaMalloc(&dst, sizeof(size_t) * size);

    for (int i = 0; i < tried; i++)
    {
        xor_gpu<<<2048, 32>>>(dst, src, &size);
    }

    cudaFree(src);
    cudaFree(dst);

    milliseconds ms2 = duration_cast<milliseconds>(system_clock::now().time_since_epoch());

    printf("GPU: %lld\n", (ms2 - ms1).count());
}

int main()
{
    check_time_cpu(1000);
    check_time_gpu(1000);
}