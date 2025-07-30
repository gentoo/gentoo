# Copyright 2022-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..13} )
ROCM_VERSION=6.1
inherit python-single-r1 cmake cuda flag-o-matic prefix rocm toolchain-funcs

MYPN=pytorch
MYP=${MYPN}-${PV}

DESCRIPTION="A deep learning framework"
HOMEPAGE="https://pytorch.org/"
SRC_URI="https://github.com/pytorch/${MYPN}/archive/refs/tags/v${PV}.tar.gz
	-> ${MYP}.tar.gz"

S="${WORKDIR}"/${MYP}

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE="cuda distributed fbgemm flash gloo memefficient mkl mpi nnpack +numpy
	onednn openblas opencl openmp qnnpack rocm xnnpack"
RESTRICT="test"
REQUIRED_USE="
	${PYTHON_REQUIRED_USE}
	mpi? ( distributed )
	gloo? ( distributed )
	?? ( cuda rocm )
	rocm? (
		|| ( ${ROCM_REQUIRED_USE} )
		!flash
	)
"

RDEPEND="
	${PYTHON_DEPS}
	dev-cpp/abseil-cpp:=
	dev-cpp/gflags:=
	>=dev-cpp/glog-0.5.0
	dev-cpp/nlohmann_json
	dev-cpp/opentelemetry-cpp
	dev-libs/cpuinfo
	dev-libs/libfmt:=
	dev-libs/protobuf:=
	dev-libs/pthreadpool
	dev-libs/sleef
	sci-ml/onnx
	sci-ml/foxi
	virtual/lapack
	cuda? (
		dev-libs/cudnn
		>=sci-ml/cudnn-frontend-1.0.3:0/8
		dev-util/nvidia-cuda-toolkit:=[profiler]
	)
	fbgemm? ( sci-ml/FBGEMM )
	gloo? ( <=sci-ml/gloo-2023.12.03[cuda?] )
	mpi? ( virtual/mpi )
	nnpack? ( sci-ml/NNPACK )
	numpy? ( $(python_gen_cond_dep '
		dev-python/numpy[${PYTHON_USEDEP}]
		') )
	onednn? ( =sci-ml/oneDNN-3.5* )
	opencl? ( virtual/opencl )
	qnnpack? (
		!sci-libs/QNNPACK
		sci-ml/gemmlowp
	)
	rocm? (
		=dev-util/hip-6.1*
		=dev-libs/rccl-6.1*
		=sci-libs/rocThrust-6.1*
		=sci-libs/rocPRIM-6.1*
		=sci-libs/hipBLAS-6.1*
		=sci-libs/hipFFT-6.1*
		=sci-libs/hipSPARSE-6.1*
		=sci-libs/hipRAND-6.1*
		=sci-libs/hipCUB-6.1*
		=sci-libs/hipSOLVER-6.1*
		=sci-libs/miopen-6.1*
		=dev-util/roctracer-6.1*

		=sci-libs/hipBLASLt-6.1*
		amdgpu_targets_gfx90a? ( =sci-libs/hipBLASLt-6.1*[amdgpu_targets_gfx90a] )
		amdgpu_targets_gfx940? ( =sci-libs/hipBLASLt-6.1*[amdgpu_targets_gfx940] )
		amdgpu_targets_gfx941? ( =sci-libs/hipBLASLt-6.1*[amdgpu_targets_gfx941] )
		amdgpu_targets_gfx942? ( =sci-libs/hipBLASLt-6.1*[amdgpu_targets_gfx942] )
	)
	distributed? (
		sci-ml/tensorpipe[cuda?]
		dev-cpp/cpp-httplib
	)
	xnnpack? ( ~sci-ml/XNNPACK-2024.02.29 )
	mkl? ( sci-libs/mkl )
	openblas? ( sci-libs/openblas )
"

DEPEND="
	${RDEPEND}
	dev-libs/flatbuffers
	dev-libs/FXdiv
	dev-libs/pocketfft
	dev-libs/psimd
	sci-ml/FP16
	sci-ml/kineto
	$(python_gen_cond_dep '
		dev-python/pybind11[${PYTHON_USEDEP}]
		dev-python/pyyaml[${PYTHON_USEDEP}]
		dev-python/typing-extensions[${PYTHON_USEDEP}]
	')
	cuda? ( <=dev-libs/cutlass-3.4.1 )
	onednn? ( sci-ml/ideep )
	qnnpack? ( dev-libs/clog )
"

PATCHES=(
	"${FILESDIR}"/${P}-unbundle_fmt.patch
	"${FILESDIR}"/${P}-unbundle_kineto.patch
	"${FILESDIR}"/${P}-cudnn_include_fix.patch
	"${FILESDIR}"/${P}-gentoo.patch
	"${FILESDIR}"/${PN}-2.4.0-cpp-httplib.patch
	"${FILESDIR}"/${P}-glog-0.6.0.patch
	"${FILESDIR}"/${P}-newfix-functorch-install.patch
)

src_prepare() {
	filter-lto #bug 862672

	# Unbundle fmt
	sed -i \
		-e 's|::fmt-header-only||' \
		c10/CMakeLists.txt \
		cmake/Dependencies.cmake \
		torch/CMakeLists.txt \
		|| die

	# Drop third_party from CMake tree
	sed -i \
		-e '/add_subdirectory.*third_party/d' \
		CMakeLists.txt \
		cmake/Dependencies.cmake \
		cmake/ProtoBuf.cmake \
		aten/src/ATen/CMakeLists.txt \
		|| die
	# Change libc10* path
	sed -i \
		-e "/EXPORT/s|DESTINATION lib)|DESTINATION $(get_libdir))|" \
		c10/cuda/CMakeLists.txt \
		c10/CMakeLists.txt \
		c10/hip/CMakeLists.txt \
		|| die
	sed -i \
		-e '/Using pocketfft in directory:/d' \
		cmake/Dependencies.cmake \
		|| die

	cmake_src_prepare
	pushd torch/csrc/jit/serialization || die
	flatc --cpp --gen-mutable --scoped-enums mobile_bytecode.fbs || die
	popd

	# prefixify the hardcoded paths, after all patches are applied
	hprefixify \
		aten/CMakeLists.txt \
		caffe2/CMakeLists.txt \
		cmake/Metal.cmake \
		cmake/Modules/*.cmake \
		cmake/Modules_CUDA_fix/FindCUDNN.cmake \
		cmake/Modules_CUDA_fix/upstream/FindCUDA/make2cmake.cmake \
		cmake/Modules_CUDA_fix/upstream/FindPackageHandleStandardArgs.cmake \
		cmake/public/LoadHIP.cmake \
		cmake/public/cuda.cmake \
		cmake/Dependencies.cmake \
		torch/CMakeLists.txt \
		CMakeLists.txt

	if use rocm; then
		sed -e "s:/opt/rocm:/usr:" \
			-e "s:lib/cmake:$(get_libdir)/cmake:g" \
			-e "s/HIP 1.0/HIP 1.0 REQUIRED/" \
			-i cmake/public/LoadHIP.cmake || die

		ebegin "HIPifying cuda sources"
		${EPYTHON} tools/amd_build/build_amd.py || die
		eend $?
	fi
}

src_configure() {
	if use cuda && [[ -z ${TORCH_CUDA_ARCH_LIST} ]]; then
		ewarn "WARNING: caffe2 is being built with its default CUDA compute capabilities: 3.5 and 7.0."
		ewarn "These may not be optimal for your GPU."
		ewarn ""
		ewarn "To configure caffe2 with the CUDA compute capability that is optimal for your GPU,"
		ewarn "set TORCH_CUDA_ARCH_LIST in your make.conf, and re-emerge caffe2."
		ewarn "For example, to use CUDA capability 7.5 & 3.5, add: TORCH_CUDA_ARCH_LIST=7.5 3.5"
		ewarn "For a Maxwell model GPU, an example value would be: TORCH_CUDA_ARCH_LIST=Maxwell"
		ewarn ""
		ewarn "You can look up your GPU's CUDA compute capability at https://developer.nvidia.com/cuda-gpus"
		ewarn "or by running /opt/cuda/extras/demo_suite/deviceQuery | grep 'CUDA Capability'"
	fi

	local mycmakeargs=(
		-DBUILD_CUSTOM_PROTOBUF=OFF
		-DLIBSHM_INSTALL_LIB_SUBDIR="${EPREFIX}"/usr/$(get_libdir)
		-DPython_EXECUTABLE="${PYTHON}"
		-DTORCH_INSTALL_LIB_DIR="${EPREFIX}"/usr/$(get_libdir)
		-DUSE_CCACHE=OFF
		-DUSE_CUDA=$(usex cuda)
		-DUSE_DISTRIBUTED=$(usex distributed)
		-DUSE_FAKELOWP=OFF
		-DUSE_FBGEMM=$(usex fbgemm)
		-DUSE_FLASH_ATTENTION=$(usex flash)
		-DUSE_GFLAGS=ON
		-DUSE_GLOG=ON
		-DUSE_GLOO=$(usex gloo)
		-DUSE_ITT=OFF
		-DUSE_KINETO=OFF # TODO
		-DUSE_MAGMA=OFF # TODO: In GURU as sci-libs/magma
		-DUSE_MEM_EFF_ATTENTION=$(usex memefficient)
		-DUSE_MKLDNN=$(usex onednn)
		-DUSE_MPI=$(usex mpi)
		-DUSE_NCCL=OFF
		-DUSE_NNPACK=$(usex nnpack)
		-DUSE_NUMA=OFF
		-DUSE_NUMPY=$(usex numpy)
		-DUSE_OPENCL=$(usex opencl)
		-DUSE_OPENMP=$(usex openmp)
		-DUSE_PYTORCH_QNNPACK=$(usex qnnpack)
		-DUSE_PYTORCH_METAL=OFF
		-DUSE_ROCM=$(usex rocm)
		-DUSE_SYSTEM_CPUINFO=ON
		-DUSE_SYSTEM_EIGEN_INSTALL=ON
		-DUSE_SYSTEM_FP16=ON
		-DUSE_SYSTEM_FXDIV=ON
		-DUSE_SYSTEM_GLOO=ON
		-DUSE_SYSTEM_ONNX=ON
		-DUSE_SYSTEM_PSIMD=ON
		-DUSE_SYSTEM_PSIMD=ON
		-DUSE_SYSTEM_PTHREADPOOL=ON
		-DUSE_SYSTEM_PYBIND11=ON
		-DUSE_SYSTEM_SLEEF=ON
		-DUSE_SYSTEM_XNNPACK=$(usex xnnpack)
		-DUSE_TENSORPIPE=$(usex distributed)
		-DUSE_UCC=OFF
		-DUSE_VALGRIND=OFF
		-DUSE_XNNPACK=$(usex xnnpack)
		-DUSE_XPU=OFF
		-Wno-dev
	)

	if use mkl; then
		mycmakeargs+=(-DBLAS=MKL)
	elif use openblas; then
		mycmakeargs+=(-DBLAS=OpenBLAS)
	else
		mycmakeargs+=(-DBLAS=Generic -DBLAS_LIBRARIES=)
	fi

	if use cuda; then
		addpredict "/dev/nvidiactl" # bug 867706
		addpredict "/dev/char"
		addpredict "/proc/self/task" # bug 926116

		mycmakeargs+=(
			-DUSE_CUDNN=ON
			-DTORCH_CUDA_ARCH_LIST="${TORCH_CUDA_ARCH_LIST:-3.5 7.0}"
			-DUSE_NCCL=OFF # TODO: NVIDIA Collective Communication Library
			-DCMAKE_CUDA_FLAGS="$(cuda_gccdir -f | tr -d \")"
		)
	elif use rocm; then
		export PYTORCH_ROCM_ARCH="$(get_amdgpu_flags)"

		mycmakeargs+=(
			-DUSE_NCCL=ON
			-DUSE_SYSTEM_NCCL=ON
		)

		# ROCm libraries produce too much warnings
		append-cxxflags -Wno-deprecated-declarations -Wno-unused-result

		if tc-is-clang; then
			# fix mangling in LLVM: https://github.com/llvm/llvm-project/issues/85656
			append-cxxflags -fclang-abi-compat=17
		fi
	fi

	if use onednn; then
		mycmakeargs+=(
			-DMKLDNN_FOUND=ON
			-DMKLDNN_LIBRARIES=dnnl
			-DMKLDNN_INCLUDE_DIR="${ESYSROOT}/usr/include/oneapi/dnnl"
		)
	fi

	cmake_src_configure
}

src_compile() {
	PYTORCH_BUILD_VERSION=${PV} \
	PYTORCH_BUILD_NUMBER=0 \
	cmake_src_compile
}

python_install() {
	python_domodule python/torch
	mkdir "${D}"$(python_get_sitedir)/torch/bin || die
	mkdir "${D}"$(python_get_sitedir)/torch/lib || die
	mkdir "${D}"$(python_get_sitedir)/torch/include || die
	ln -s ../../../../../include/torch \
		"${D}$(python_get_sitedir)"/torch/include/torch || die # bug 923269
	ln -s ../../../../../bin/torch_shm_manager \
		"${D}"/$(python_get_sitedir)/torch/bin/torch_shm_manager || die
	ln -s ../../../../../$(get_libdir)/libtorch_global_deps.so \
		"${D}"/$(python_get_sitedir)/torch/lib/libtorch_global_deps.so || die
}

src_install() {
	cmake_src_install

	# Used by pytorch ebuild
	insinto "/var/lib/${PN}"
	doins "${BUILD_DIR}"/CMakeCache.txt
	dostrip -x /var/lib/${PN}/functorch.so

	rm -rf python
	mkdir -p python/torch || die
	cp torch/version.py python/torch/ || die
	python_install
}
