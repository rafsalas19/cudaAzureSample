#include <stdlib.h>
#include <cuda_runtime.h>
#include <algorithm>
#include <assert.h>
#include <math.h>
#include <stdio.h>
#include <iostream>;
#include <fstream>
#include <string>

using namespace std;

#define ITERATION 500
#define LENX 100
#define LENY 100

void checkError(cudaError err) {
	if (err != cudaSuccess)
	{
		fprintf(stderr, "Cuda error (error code %s)!\n", cudaGetErrorString(err));
		exit(EXIT_FAILURE);
	}

}

__global__ void
transferHeat(const float* inGrid, float* outGrid)
{
	int i = blockDim.x * blockIdx.x + threadIdx.x;
	if (i > LENX * LENY) {
		return;
	}



	if (i > LENX && i <(LENX * LENY -1)-LENX)
	{		
		outGrid[i] = .25 * (inGrid[i-1] + inGrid[i+1] + inGrid[i + LENY] + inGrid[i - LENY]);
		//if(i==29)printf("%f | %f %f %f %f\n",outGrid[i], inGrid[i - 1], inGrid[i + 1], inGrid[i + LENY], inGrid[i - LENY]);
	}
	else
	{
		outGrid[i] = inGrid[i];
	}
}

void default_initialize(float * gridPointsCPU, int lenX, int lenY) {
	for (int j = 0;j<lenY;++j) {
		for (int i = 0; i < lenX; ++i) {
			int point = i + j * lenX;
			if (j == 0) {
				gridPointsCPU[point] = 100;
			}

			else if (j == lenY-1) {
				gridPointsCPU[point] = 0;
			}
			else if (j ==0 && i%lenX==0) {
				gridPointsCPU[point] = 0;
			}
			else if (j == lenY - 1 && i % lenX == lenX-1) {
				gridPointsCPU[point] = 0;
			}
			else {
				gridPointsCPU[point] = 30;
			}
		}
	}

	return;
}


int main(){
	int probSize = LENX * LENY;	
	float gridPointsCPU[LENX * LENY] = {0};
	float* gridPointsOutGPU = NULL;
	float* gridPointsInGPU = NULL;
	int devicecount = 0;

	//check device count
	cudaGetDeviceCount(&devicecount);
	cout << "Device count is " << devicecount << endl;
	cudaError err = cudaSuccess;

	err = cudaMalloc((void**)&gridPointsInGPU, probSize * sizeof(float));
	checkError(err);
	err = cudaMalloc((void**)&gridPointsOutGPU, probSize * sizeof(float));
	checkError(err);

	//initialize
	default_initialize(gridPointsCPU,LENX,LENY);

	//copy from cpu
	err = cudaMemcpy(gridPointsInGPU, gridPointsCPU, probSize*sizeof(float), cudaMemcpyHostToDevice);
	checkError(err);

	//fstream fstartBuffer;
	//fstartBuffer.open("htStart", fstream::out | fstream::trunc);
	//for (int i = 0; i < probSize; ++i) {
	//	//fstartBuffer << gridPointsCPU[i] << endl;
	//	int x = i % LENX;
	//	int y = i / LENY;
	//	fstartBuffer << "index: " << i << " point:" << x << "," << y << " " << gridPointsCPU[i] << endl;
	//}
	//fstartBuffer.close();


	int gridSize = 0;
	int blockSize = 128;
	gridSize = probSize/blockSize +1;
	for (int i = 0; i < ITERATION ; ++i) {



		transferHeat << < gridSize, blockSize >> > (gridPointsInGPU, gridPointsOutGPU);
		cudaDeviceSynchronize();

		if (i <( ITERATION - 1)) {
			float* swap = gridPointsInGPU;
			gridPointsInGPU = gridPointsOutGPU;
			gridPointsOutGPU = swap;
		}
	}
	
	err = cudaGetLastError();
	checkError(err);
	err = cudaMemcpy(gridPointsCPU, gridPointsOutGPU, probSize * sizeof(float), cudaMemcpyDeviceToHost);
	checkError(err);

	fstream fout;
	fout.open("htOut", fstream::out | fstream::trunc);
	for (int i = 0;i<probSize;++i) {
		int x = i % LENX;
		int y = i / LENY;
		fout  << x <<","<<y<<" "<<gridPointsCPU[i] << endl;
	}
	fout.close();
//	char endChar = 'c';
//	cout << "enter a character to exit"<<endl;
//	cin >> endChar;

	return 0;
}
