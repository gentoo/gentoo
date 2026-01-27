# Copyright 2022-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..14} )
ROCM_VERSION=6.1
inherit python-single-r1 cmake cuda flag-o-matic prefix rocm toolchain-funcs

MYPN=pytorch
MYP=${MYPN}-${PV}

# caffe2-2.9.0 depends on future version of composable kernel
# TODO: replace it with DEPEND in the future
CK_COMMIT=7fe50dc3da2069d6645d9deb8c017a876472a977
CK_P=composable_kernel-${CK_COMMIT:0:8}

FLASH_PV=2.7.4
FLASH_PN=flash-attention
FLASH_P=${FLASH_PN}-${FLASH_PV}
FLASH_ATT_URI="https://github.com/Dao-AILab/${FLASH_PN}/archive/refs/tags/v${FLASH_PV}.tar.gz -> ${FLASH_P}.gh.tar.gz"

AOTRITON_PV=0.9.2b
AOTRITON_PN=aotriton
AOTRITON_P=${AOTRITON_PN}-${AOTRITON_PV}
AOTRITON_tar=${AOTRITON_P}-manylinux_2_28_x86_64-rocm6.3-shared.tar.gz

DESCRIPTION="A deep learning framework"
HOMEPAGE="https://pytorch.org/"
SRC_URI="
	https://github.com/pytorch/${MYPN}/archive/refs/tags/v${PV}.tar.gz -> ${MYP}.tar.gz
	rocm? (
		https://github.com/ROCm/composable_kernel/archive/${CK_COMMIT}.tar.gz
		-> ${CK_P}.tar.gz
	)
	cuda? (
		flash? ( ${FLASH_ATT_URI} )
		memefficient? ( ${FLASH_ATT_URI} )
	)
"

S="${WORKDIR}"/${MYP}

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm64"
IUSE="cuda cusparselt distributed fbgemm flash gloo memefficient mkl mpi nccl nnpack +numpy
	onednn openblas opencl openmp qnnpack rocm xnnpack"
RESTRICT="test"
REQUIRED_USE="
	${PYTHON_REQUIRED_USE}
	mpi? ( distributed )
	gloo? ( distributed )
	?? ( cuda rocm )
	rocm? (
		|| ( ${ROCM_REQUIRED_USE} )
	)
	flash? ( || ( cuda rocm ) )
	memefficient? ( || ( cuda rocm ) )
	nccl? ( rocm )
"

RDEPEND="
	${PYTHON_DEPS}
	dev-cpp/abseil-cpp:=
	dev-cpp/gflags:=
	>=dev-cpp/glog-0.5.0:=
	dev-libs/cpuinfo
	dev-libs/libfmt:=
	dev-cpp/opentelemetry-cpp
	dev-libs/protobuf:=
	dev-libs/sleef
	~sci-ml/kineto-0.4.0_p20250617
	sci-ml/onnx
	virtual/lapack
	cuda? (
		dev-libs/cudnn
		>=sci-ml/cudnn-frontend-1.12.0:=
		>=dev-util/nvidia-cuda-toolkit-12.9:=[profiler]
		cusparselt? ( dev-libs/cusparselt )
	)
	fbgemm? ( sci-ml/FBGEMM )
	gloo? ( >=sci-ml/gloo-2025.06.04[cuda?,rocm?] )
	mpi? ( virtual/mpi )
	nnpack? (
		sci-ml/NNPACK
		dev-libs/pthreadpool
	)
	numpy? ( $(python_gen_cond_dep '
		dev-python/numpy[${PYTHON_USEDEP}]
	') )
	onednn? ( sci-ml/oneDNN )
	opencl? ( virtual/opencl )
	qnnpack? (
		!sci-libs/QNNPACK
		sci-ml/gemmlowp
		dev-libs/pthreadpool
	)
	rocm? (
		nccl? ( >=dev-libs/rccl-6.3:= <dev-libs/rccl-7.2:= )
		>=dev-util/hip-6.3:=       <dev-util/hip-7.2:=
		>=dev-util/roctracer-6.3:= <dev-util/roctracer-7.2:=
		>=sci-libs/hipBLAS-6.3:=   <sci-libs/hipBLAS-7.2:=[rocsolver(+)]
		>=sci-libs/hipBLASLt-6.3:= <sci-libs/hipBLASLt-7.2:=
		>=sci-libs/hipFFT-6.3:=    <sci-libs/hipFFT-7.2:=
		>=sci-libs/hipRAND-6.3:=   <sci-libs/hipRAND-7.2:=
		>=sci-libs/hipSOLVER-6.3:= <sci-libs/hipSOLVER-7.2:=
		>=sci-libs/hipSPARSE-6.3:= <sci-libs/hipSPARSE-7.2:=
		>=sci-libs/miopen-6.3:=    <sci-libs/miopen-7.2:=
		>=sci-libs/rocBLAS-6.3:=   <sci-libs/rocBLAS-7.2:=
		>=sci-libs/rocRAND-6.3:=   <sci-libs/rocRAND-7.2:=
		>=sci-libs/rocSOLVER-6.3:= <sci-libs/rocSOLVER-7.2:=
		memefficient? ( =sci-libs/aotriton-bin-0.11*:= )
		distributed? ( >=dev-util/rocm-smi-6.3:= <dev-util/rocm-smi-7.2:= )
	)
	distributed? (
		!rocm? ( sci-ml/tensorpipe[cuda?] )
		dev-cpp/cpp-httplib:=
	)
	xnnpack? (
		>=sci-ml/XNNPACK-2024.11
		dev-libs/pthreadpool
	)
	mkl? ( sci-libs/mkl )
	openblas? ( sci-libs/openblas )
"

DEPEND="
	${RDEPEND}
	dev-cpp/nlohmann_json
	dev-libs/flatbuffers
	dev-libs/FXdiv
	dev-libs/pocketfft
	dev-libs/psimd
	sci-ml/FP16
	$(python_gen_cond_dep '
		dev-python/pybind11[${PYTHON_USEDEP}]
		dev-python/pyyaml[${PYTHON_USEDEP}]
		dev-python/typing-extensions[${PYTHON_USEDEP}]
	')
	cuda? ( >=dev-libs/cutlass-3.9.2[tools(+)] )
	onednn? ( sci-ml/ideep )
	rocm? (
		>=sci-libs/hipCUB-6.3:=    <sci-libs/hipCUB-7.2:=
		>=sci-libs/rocPRIM-6.3:=   <sci-libs/rocPRIM-7.2:=
		>=sci-libs/rocThrust-6.3:= <sci-libs/rocThrust-7.2:=
	)
	qnnpack? ( dev-libs/clog )
"

PATCHES=(
	"${FILESDIR}"/${PN}-2.5.1-unbundle_fmt.patch
	"${FILESDIR}"/${PN}-2.5.1-unbundle_kineto.patch
	"${FILESDIR}"/${PN}-2.8.0-unbundle_pocketfft.patch
	"${FILESDIR}"/${PN}-2.5.1-cudnn_include_fix.patch
	"${FILESDIR}"/${PN}-2.4.0-cpp-httplib.patch
	"${FILESDIR}"/${PN}-2.5.1-glog-0.6.0.patch
	"${FILESDIR}"/${PN}-2.6.0-rocm-fix-std-cpp17.patch
	"${FILESDIR}"/${PN}-2.7.0-glog-0.7.1.patch
	"${FILESDIR}"/${PN}-2.7.1-aotriton-fixes.patch
	"${FILESDIR}"/${PN}-2.8.0-rocm-minus-flash.patch
	"${FILESDIR}"/${PN}-2.9.0-cmake.patch
	"${FILESDIR}"/${PN}-2.9.0-rocm-distributed-link.patch
	"${FILESDIR}"/${PN}-2.9.1-torch_cpu.patch
	"${FILESDIR}"/${P}-gentoo.patch
)

src_prepare() {
	if use cuda && ( use flash || use memefficient ); then
		mv "${WORKDIR}"/${FLASH_P}/* third_party/${FLASH_PN}/ || die
	fi
	filter-lto #bug 862672

	# Unbundle fmt
	sed -i \
		-e 's|::fmt-header-only||' \
		c10/CMakeLists.txt \
		cmake/Dependencies.cmake \
		torch/CMakeLists.txt \
		|| die

	# tensorpipe is in system, not a build target of caffe2
	sed -e '/target_compile_options_if_supported(tensorpipe/d' -i cmake/Dependencies.cmake || die

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

	# Change libaotriton path
	sed -i \
		-e "s|}/lib|}/$(get_libdir)|g" \
		cmake/External/aotriton.cmake \
		|| die

	# Noisy warnings from Logging.h
	sed -i 's/-Wextra-semi//' cmake/public/utils.cmake || die

	cmake_src_prepare
	pushd torch/csrc/jit/serialization > /dev/null || die
	flatc --cpp --gen-mutable --scoped-enums mobile_bytecode.fbs || die
	popd > /dev/null || die

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
			-i cmake/public/LoadHIP.cmake || die

		# TODO: delete, when caffe2 depends on systemwide composable_kernel
		sed -e "s:third_party/composable_kernel:../composable_kernel-${CK_COMMIT}:g" \
			-i aten/src/ATen/CMakeLists.txt || die

		# Bug 959808: fix for gfx101x targets
		pushd "${WORKDIR}/composable_kernel-${CK_COMMIT}" > /dev/null || die
		eapply "${FILESDIR}"/composable-kernel-7fe50dc-expand-isa.patch
		popd > /dev/null || die

		if tc-is-clang; then
			# Systemwide gcc (for absl and at::TensorBase) + hipcc (llvm>=18) need abi-compat=17.
			# But systemwide clang>=18 + hipcc (>=llvm-18) need opposite!
			# See also: https://github.com/llvm/llvm-project/issues/102443#issuecomment-2329726287
			sed -e '/-fclang-abi-compat=17/d' -i cmake/Dependencies.cmake || die
		fi

		# Workaround for libc++ issue https://github.com/llvm/llvm-project/issues/100802
		sed -e 's/std::memcpy/memcpy/g' -i torch/headeronly/util/Half.h || die

		# Typo: https://github.com/pytorch/pytorch/pull/166502
		sed -e 's/gloo_hiop/gloo_hip/' -i cmake/Modules/FindGloo.cmake || die

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
		-DBUILD_TEST=OFF
		-DLIBSHM_INSTALL_LIB_SUBDIR="${EPREFIX}"/usr/$(get_libdir)
		-DPython_EXECUTABLE="${PYTHON}"
		-DTORCH_INSTALL_LIB_DIR="${EPREFIX}"/usr/$(get_libdir)
		-DUSE_CCACHE=OFF
		-DUSE_CUDA=$(usex cuda)
		-DUSE_DISTRIBUTED=$(usex distributed)
		-DUSE_FBGEMM=$(usex fbgemm)
		-DUSE_FLASH_ATTENTION=$(usex flash)
		-DUSE_GFLAGS=ON
		-DUSE_GLOG=ON
		-DUSE_GLOO=$(usex gloo)
		-DUSE_ITT=OFF
		-DUSE_KINETO=ON
		-DUSE_KLEIDIAI=OFF # TODO
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
		-DUSE_SYSTEM_NVTX=ON
		-DUSE_SYSTEM_ONNX=ON
		-DUSE_SYSTEM_PSIMD=ON
		-DUSE_SYSTEM_PTHREADPOOL=ON
		-DUSE_SYSTEM_PYBIND11=ON
		-DUSE_SYSTEM_SLEEF=ON
		-DUSE_SYSTEM_XNNPACK=$(usex xnnpack)
		-DUSE_TENSORPIPE=$(use distributed && use !rocm && echo ON || echo OFF)
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
			-DUSE_CUSPARSELT=$(usex cusparselt)
		)
	elif use rocm; then
		export PYTORCH_ROCM_ARCH="$(get_amdgpu_flags)"

		if use memefficient; then
			export AOTRITON_INSTALLED_PREFIX="${ESYSROOT}/usr"
		fi

		mycmakeargs+=(
			-DUSE_NCCL=$(usex nccl)
			-DUSE_SYSTEM_NCCL=ON
			-DCMAKE_REQUIRE_FIND_PACKAGE_HIP=ON
	        -DUSE_ROCM_CK_SDPA=OFF # requires flash + aiter, works only on gfx90a/gfx942/gfx950
		)

		# ROCm libraries produce too much warnings
		append-cxxflags -Wno-deprecated-declarations -Wno-unused-result -Wno-unused-value
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

	rm -rf python
	mkdir -p python/torch || die
	cp torch/version.py python/torch/ || die
	python_install
}
