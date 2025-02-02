/**
 *  @file sat.cu
 *  @brief Algorithm SAT (Summed-area Tables) in the GPU
 *  @author Andre Maximo
 *  @date Jan, 2012
 *  @copyright The MIT License
 */

#ifndef ORDER
#define ORDER 1 // default filter order r=1
#endif
#define APPNAME "[sat_" << ORDER << "]"

 //== INCLUDES ==================================================================

#include <cmath>
#include <cfloat>
#include <cstdio>
#include <cstdlib>
#include <cassert>
#include <iostream>
#include <algorithm>
#include <complex>
#include <iomanip>

#include <util/util.h>
#include <util/symbol.h>
#include <util/dvector.h>
#include <util/timer.h>
#include <util/recfilter.h>
#include <util/image.h>
#include <util/gaussian.h>

#include "cpudefs.h"
#include "gpudefs.h"
#include "alg0_cpu.h"
#include "sat_gpu.cuh"

//== IMPLEMENTATION ============================================================

/**
 *  @ingroup api_gpu
 *  @brief Compute Algorithm SAT (order agnostic) with any boundary condition
 *
 *  This function computes R-order recursive filtering with given
 *  weights of an input 2D image using algorithm \f$SAT\f$ and any
 *  given boundary condition.  All choices of boundary conditions
 *  imply border input padding, that is the algorithm SAT is
 *  restricted to the discussions and considerations in
 *  [NehabEtAl:2011] cited in alg5().
 *
 *  @see [NehabEtAl:2011] cited in alg5()
 *  @param[in,out] h_img The in(out)put 2D image to filter in host memory
 *  @param[in] width Image width
 *  @param[in] height Image height
 *  @param[in] runtimes Number of run times (1 for debug and 1000 for performance measurements)
 *  @param[in] w Filter weights (feedforward and feedback coefficients)
 *  @param[in] border Number of border blocks (32x32) outside image
 *  @param[in] btype Border type (either zero, clamp, repeat or reflect)
 *  @tparam R Filter order
 */
template<int R>
void sat(float* h_img,
	const int& width, const int& height, const int& runtimes,
	const gpufilter::Vector<float, R + 1>& w,
	const int& border,
	const gpufilter::BorderType& btype) {

	if (border == 0) {
		gpufilter::sat_gpu<false, R>(h_img, width, height, runtimes, w);
	}
	else if (border > 0) {
		gpufilter::sat_gpu<true, R>(h_img, width, height, runtimes, w,
			border, btype);
	}

}

// Main ------------------------------------------------------------------------

int main(int argc, char** argv) {

	int width, height, runtimes, border, a0border;
	gpufilter::BorderType btype;
	std::vector<float> cpu_img, gpu_img;
	gpufilter::Vector<float, ORDER + 1> w;
	float me, mre;

	initial_setup(width, height, runtimes, btype, border,
		cpu_img, gpu_img, w, a0border, me, mre,
		argc, argv);

	w[0] = 1.; w[1] = -1.; // this is sat


	if (runtimes == 1) // running for debugging
		print_info(width, height, btype, border, a0border, w);

	//gpufilter::print_pixels(&cpu_img[0], width, height);

	gpufilter::ref_sat_cpu<ORDER>(&cpu_img[0], width, height, w, a0border, btype);

	sat<ORDER>(&gpu_img[0], width, height, runtimes, w, border, btype);

	gpufilter::check_cpu_reference(&cpu_img[0], &gpu_img[0], width * height, me, mre);

	//gpufilter::print_pixels(&cpu_img[0], width, height);

	if (runtimes == 1) // running for debugging
		std::cout << APPNAME << " [max-error] [max-relative-error]:";

	// in sat max error is normally big because its values are big
	std::cout << " " << std::scientific << me << " "
		<< std::scientific << mre << "\n";

	return 0;

}
