#include <stdlib.h>
#include <cuda_runtime.h>
#include <algorithm>
#include <assert.h>
#include <math.h>
#include <stdio.h>
#include <iostream>;
#include <string>

using namespace std;



int main(){
	
	int devicecount = 0;
	cudaGetDeviceCount(&devicecount);
	cout << "Device count is " << devicecount << endl;
	char endChar = 'c';
	cout << "enter a character to exit"<<endl;
	cin >> endChar;

	return 0;
}