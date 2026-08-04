# Copyright 2022-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..14} )
DISTUTILS_SINGLE_IMPL=1
DISTUTILS_EXT=1

ROCM_VERSION=6.1
inherit distutils-r1 prefix cuda flag-o-matic rocm multiprocessing

# pytorch-2.13.0 depends on future version of composable kernel
# TODO: replace it with DEPEND in the future
CK_COMMIT=7fe50dc3da2069d6645d9deb8c017a876472a977
CK_P=composable_kernel-${CK_COMMIT:0:8}

# Starting from 2.7.0 pytorch moved flash attention out-of-tree,
# but hardcoded it as third_party subproject
# TODO: unbundle
FLASH_PV=2.7.4
FLASH_PN=flash-attention
FLASH_P=${FLASH_PN}-${FLASH_PV}
FLASH_ATT_URI="https://github.com/Dao-AILab/${FLASH_PN}/archive/refs/tags/v${FLASH_PV}.tar.gz -> ${FLASH_P}.gh.tar.gz"

DESCRIPTION="Tensors and Dynamic neural networks in Python with strong GPU acceleration"
HOMEPAGE="https://pytorch.org/"
SRC_URI="https://github.com/pytorch/${PN}/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
	rocm? (
		https://github.com/ROCm/composable_kernel/archive/${CK_COMMIT}.tar.gz
		-> ${CK_P}.tar.gz
	)
	cuda? (
		flash? ( ${FLASH_ATT_URI} )
		memefficient? ( ${FLASH_ATT_URI} )
	)
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE="cuda cusparselt distributed fbgemm flash gloo kineto memefficient
	mimalloc mkl mpi nccl nnpack +numpy onednn openblas opencl openmp qnnpack
	rocm xnnpack"
RESTRICT="test"

REQUIRED_USE="
	${PYTHON_REQUIRED_USE}
	mpi? ( distributed )
	gloo? ( distributed )
	?? ( cuda rocm )
	rocm? (
		|| ( ${ROCM_REQUIRED_USE} )
		memefficient? ( flash )
	)
	cusparselt? ( || ( cuda rocm ) )
	flash? ( || ( cuda rocm ) )
	memefficient? ( || ( cuda rocm ) )
	nccl? ( rocm )
"

RDEPEND="
	${PYTHON_DEPS}
	!sci-ml/caffe2
	dev-cpp/abseil-cpp:=
	dev-cpp/gflags:=
	>=dev-cpp/glog-0.5.0:=
	>=dev-libs/cpuinfo-2025.11.14
	dev-libs/libfmt:=
	dev-libs/protobuf:=
	dev-libs/sleef
	sci-ml/onnx
	$(python_gen_cond_dep '
		dev-python/sympy[${PYTHON_USEDEP}]
		dev-python/typing-extensions[${PYTHON_USEDEP}]
	')
	cuda? (
		dev-libs/cudnn
		>=sci-ml/cudnn-frontend-1.12.0:=
		>=dev-util/nvidia-cuda-toolkit-12.9:=[profiler]
		cusparselt? ( dev-libs/cusparselt )
	)
	distributed? (
		!rocm? ( sci-ml/tensorpipe[cuda?] )
		dev-cpp/cpp-httplib:=
	)
	fbgemm? ( >=sci-ml/FBGEMM-1.4 )
	gloo? ( >=sci-ml/gloo-2025.06.04[cuda?,rocm?] )
	kineto? ( ~sci-ml/kineto-0.4.0_p20260603 )
	mimalloc? ( dev-libs/mimalloc )
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
		nccl? ( >=dev-libs/rccl-6.3:= <dev-libs/rccl-7.3:= )
		>=dev-util/hip-6.3:=       <dev-util/hip-7.3:=
		>=dev-util/roctracer-6.3:= <dev-util/roctracer-7.3:=
		>=sci-libs/hipBLAS-6.3:=   <sci-libs/hipBLAS-7.3:=[rocsolver(+)]
		>=sci-libs/hipBLASLt-6.3:= <sci-libs/hipBLASLt-7.3:=
		>=sci-libs/hipFFT-6.3:=    <sci-libs/hipFFT-7.3:=
		>=sci-libs/hipRAND-6.3:=   <sci-libs/hipRAND-7.3:=
		>=sci-libs/hipSOLVER-6.3:= <sci-libs/hipSOLVER-7.3:=
		>=sci-libs/hipSPARSE-6.3:= <sci-libs/hipSPARSE-7.3:=
		>=sci-libs/miopen-6.3:=    <sci-libs/miopen-7.3:=
		>=sci-libs/rocBLAS-6.3:=   <sci-libs/rocBLAS-7.3:=
		>=sci-libs/rocRAND-6.3:=   <sci-libs/rocRAND-7.3:=
		>=sci-libs/rocSOLVER-6.3:= <sci-libs/rocSOLVER-7.3:=
		memefficient? ( =sci-libs/aotriton-bin-0.11*:= )
		distributed? (
			>=dev-util/rocm-smi-6.3:= <dev-util/rocm-smi-7.3:=
			>=dev-util/amdsmi-6.3:= <dev-util/amdsmi-7.3:=
		)
		cusparselt? ( >=sci-libs/hipsparselt-6.3:= <sci-libs/hipsparselt-7.3:= )
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
		<dev-python/pybind11-3.0.5[${PYTHON_USEDEP}]
		dev-python/pyyaml[${PYTHON_USEDEP}]
		dev-python/typing-extensions[${PYTHON_USEDEP}]
	')
	cuda? ( ~dev-libs/cutlass-4.4.2[tools(+)] )
	onednn? ( sci-ml/ideep )
	rocm? (
		>=sci-libs/hipCUB-6.3:=    <sci-libs/hipCUB-7.3:=
		>=sci-libs/rocPRIM-6.3:=   <sci-libs/rocPRIM-7.3:=
		>=sci-libs/rocThrust-6.3:= <sci-libs/rocThrust-7.3:=
	)
	qnnpack? ( dev-libs/clog )
"

BDEPEND="dev-build/cmake"

PATCHES=(
	"${FILESDIR}"/${PN}-2.10.0-cpp-extension-multilib.patch
	"${FILESDIR}"/${P}-removekineto-pr178960.patch
	"${FILESDIR}"/${P}-unbundle_fbgemm.patch
	"${FILESDIR}"/${P}-unbundle_flatbuffers.patch
	"${FILESDIR}"/${P}-unbundle_fmt.patch
	"${FILESDIR}"/${P}-unbundle_kineto.patch
	"${FILESDIR}"/${P}-unbundle_mkldnn.patch
	"${FILESDIR}"/${P}-unbundle_nnpack.patch
	"${FILESDIR}"/${P}-unbundle_pocketfft.patch
	"${FILESDIR}"/${P}-xnnpack.patch
)

src_prepare() {
	if use cuda && ( use flash || use memefficient ); then
		mv "${WORKDIR}"/${FLASH_P}/* third_party/${FLASH_PN}/ || die
	fi
	filter-lto #bug 862672

	# Replace placeholders added by cpp-extension.patch
	sed -e "s|%LIB_DIR%|$(get_libdir)|g" \
		-i torch/utils/cpp_extension.py || die

	# Drop legacy from pyproject.toml
	sed -e "/build-backend/s|:__legacy__||" \
		-i pyproject.toml || die

	# Unbundle fmt
	sed -i \
		-e 's|::fmt-header-only||' \
		c10/CMakeLists.txt \
		cmake/Dependencies.cmake \
		torch/CMakeLists.txt \
		|| die

	# tensorpipe is in system, not a build target of pytorch
	sed -e '/target_compile_options_if_supported(tensorpipe/d' -i cmake/Dependencies.cmake || die

	# Drop third_party from CMake tree
	sed -i \
		-e '/add_subdirectory.*third_party/d' \
		CMakeLists.txt \
		cmake/Dependencies.cmake \
		cmake/ProtoBuf.cmake \
		aten/src/ATen/CMakeLists.txt \
		|| die

	# Change libaotriton path
	sed -i \
		-e "s|}/lib|}/\${CMAKE_INSTALL_LIBDIR}|g" \
		-e "/set(__AOTRITON_LIB/s|lib/|\${CMAKE_INSTALL_LIBDIR}/|g" \
		cmake/External/aotriton.cmake \
		|| die

	# Add needed file for cutlass as symbolic link
	ln -sf /usr/share/cutlass/examples third_party/cutlass/examples || die

	distutils-r1_src_prepare

	# Noisy warnings from Logging.h
	sed -i 's/-Wextra-semi//' cmake/public/utils.cmake || die

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
		tools/setup_helpers/env.py \
		torch/CMakeLists.txt \
		CMakeLists.txt

	if use rocm; then
		# TODO: delete, when caffe2 depends on systemwide composable_kernel
		sed -e "s:third_party/composable_kernel:../composable_kernel-${CK_COMMIT}:g" \
			-i aten/src/ATen/CMakeLists.txt || die

		# Bug 959808: fix for gfx101x targets
		pushd "${WORKDIR}/composable_kernel-${CK_COMMIT}" > /dev/null || die
		eapply "${FILESDIR}"/composable-kernel-7fe50dc-expand-isa.patch
		popd > /dev/null || die

		# Workaround for libc++ issue https://github.com/llvm/llvm-project/issues/100802
		sed -e 's/std::memcpy/memcpy/g' -i torch/headeronly/util/Half.h || die

		ebegin "HIPifying cuda sources"
		FBCODE_BUILD_TOOL="buck" ${EPYTHON} tools/amd_build/build_amd.py || die
		eend $?
	fi
}

src_configure() {
	if use cuda && [[ -z ${TORCH_CUDA_ARCH_LIST} ]]; then
		ewarn "WARNING: pytorch is being built with its default CUDA compute capabilities: 3.5 and 7.0."
		ewarn "These may not be optimal for your GPU."
		ewarn ""
		ewarn "To configure pytorch with the CUDA compute capability that is optimal for your GPU,"
		ewarn "set TORCH_CUDA_ARCH_LIST in your make.conf, and re-emerge pytorch."
		ewarn "For example, to use CUDA capability 7.5 & 3.5, add: TORCH_CUDA_ARCH_LIST=7.5 3.5"
		ewarn "For a Maxwell model GPU, an example value would be: TORCH_CUDA_ARCH_LIST=Maxwell"
		ewarn ""
		ewarn "You can look up your GPU's CUDA compute capability at https://developer.nvidia.com/cuda-gpus"
		ewarn "or by running /opt/cuda/extras/demo_suite/deviceQuery | grep 'CUDA Capability'"
	fi
}

python_compile() {
	local -x BUILD_TEST=OFF
	local -x CMAKE_BUILD_DIR="${BUILD_DIR}"
	local -x MAX_JOBS=$(makeopts_jobs)
	local -x PYTORCH_BUILD_VERSION=${PV}
	local -x PYTORCH_BUILD_NUMBER=0
	local -x USE_CCACHE=OFF
	local -x USE_CUDA=$(usex cuda)
	local -x USE_DISTRIBUTED=$(usex distributed)
	local -x USE_FBGEMM=$(usex fbgemm)
	local -x USE_FLASH_ATTENTION=$(usex flash)
	local -x USE_GFLAGS=ON
	local -x USE_GLOG=ON
	local -x USE_GLOO=$(usex gloo)
	local -x USE_ITT=OFF
	local -x USE_KINETO=$(usex kineto)
	local -x USE_KLEIDIAI=OFF # TODO
	local -x USE_MAGMA=OFF # TODO: In GURU as sci-libs/magma
	local -x USE_MEM_EFF_ATTENTION=$(usex memefficient)
	local -x USE_MIMALLOC=$(usex mimalloc)
	local -x USE_MKLDNN=$(usex onednn)
	local -x USE_MPI=$(usex mpi)
	local -x USE_NNPACK=$(usex nnpack)
	local -x USE_NUMA=OFF
	local -x USE_NUMPY=$(usex numpy)
	local -x USE_OPENCL=$(usex opencl)
	local -x USE_OPENMP=$(usex openmp)
	local -x USE_PYTORCH_QNNPACK=$(usex qnnpack)
	local -x USE_PYTORCH_METAL=OFF
	local -x USE_ROCM=$(usex rocm)
	local -x USE_SYSTEM_LIBS=ON
	local -x USE_SYSTEM_XNNPACK=$(usex xnnpack)
	local -x USE_TENSORPIPE=$(usex distributed $(usex !rocm))
	local -x DUSE_UCC=OFF
	local -x USE_VALGRIND=OFF
	local -x USE_XNNPACK=$(usex xnnpack)
	local -x USE_XPU=OFF

	if use cuda; then
		# bug 867706 926116
		cuda_add_sandbox
		addpredict "/dev/char/"

		local -x CMAKE_CUDA_FLAGS="$(cuda_gccdir -f | tr -d \")"
		local -x TORCH_CUDA_ARCH_LIST="${TORCH_CUDA_ARCH_LIST:7.0}"
		local -x USE_CUDNN=ON
		local -x USE_FLASH_ATTENTION=OFF
		local -x USE_MEM_EFF_ATTENTION=OFF
		local -x USE_NCCL=OFF # TODO: NVIDIA Collective Communication Library

	elif use rocm; then
		export PYTORCH_ROCM_ARCH="$(get_amdgpu_flags)"

		if use memefficient; then
			export AOTRITON_INSTALLED_PREFIX="${ESYSROOT}/usr"
		fi

		local -x CMAKE_REQUIRE_FIND_PACKAGE_HIP=ON
		local -x USE_NCCL=$(usex nccl)
		local -x CMAKE_DISABLE_FIND_PACKAGE_hipsparselt=$(usex !cusparselt) # disable automagic
		local -x USE_ROCM_CK_SDPA=OFF # requires flash + aiter, works only on gfx90a/gfx942/gfx950
		local -x ROCM_PATH=/usr
		local -x HIP_CLANG_PATH=$(hipconfig --hipclangpath)

		# ROCm libraries produce too much warnings
		append-cxxflags -Wno-deprecated-declarations -Wno-unused-result -Wno-unused-value
	else
		local -x USE_NCCL=OFF
	fi

	distutils-r1_python_compile develop sdist
}
