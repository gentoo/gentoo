# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_OPTIONAL=1
PYTHON_COMPAT=( python3_{10..11} )
MY_PV=${PV/_rc/-rc}
MY_P=${PN}-${MY_PV}
DEP_VER="$(ver_cut 1-2)"

inherit bazel check-reqs cuda distutils-r1 flag-o-matic prefix toolchain-funcs

DESCRIPTION="Computation framework using data flow graphs for scalable machine learning"
HOMEPAGE="https://www.tensorflow.org/"

RESTRICT="test" # Tests need GPU access
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="cuda mpi +python xla"
CPU_USE_FLAGS_X86="sse sse2 sse3 sse4_1 sse4_2 avx avx2 fma3 fma4"
for i in $CPU_USE_FLAGS_X86; do
	IUSE+=" cpu_flags_x86_${i}"
done

# distfiles that bazel uses for the workspace, will be copied to basel-distdir
# pkgcheck complains but do NOT change the .zip to .tar.gz, bazel requires the exact tarball (basename and sha256).
# the build will fail if different archives are used.
bazel_external_uris="
	https://github.com/Maratyszcza/FP16/archive/4dfe081cf6bcd15db339cf2680b9281b8451eeb3.zip -> FP16-4dfe081cf6bcd15db339cf2680b9281b8451eeb3.zip
	https://github.com/Maratyszcza/FXdiv/archive/63058eff77e11aa15bf531df5dd34395ec3017c8.zip -> FXdiv-63058eff77e11aa15bf531df5dd34395ec3017c8.zip
	https://github.com/Maratyszcza/pthreadpool/archive/b8374f80e42010941bda6c85b0e3f1a1bd77a1e0.zip -> pthreadpool-b8374f80e42010941bda6c85b0e3f1a1bd77a1e0.zip
	https://github.com/bazelbuild/apple_support/releases/download/1.1.0/apple_support.1.1.0.tar.gz
	https://github.com/bazelbuild/bazel-skylib/releases/download/1.3.0/bazel-skylib-1.3.0.tar.gz
	https://github.com/bazelbuild/bazel-toolchains/archive/8c717f8258cd5f6c7a45b97d974292755852b658.tar.gz -> bazel-toolchains-8c717f8258cd5f6c7a45b97d974292755852b658.tar.gz
	https://github.com/bazelbuild/platforms/releases/download/0.0.6/platforms-0.0.6.tar.gz -> bazelbuild-platforms-0.0.6.tar.gz
	https://github.com/bazelbuild/rules_android/archive/v0.1.1.zip -> bazelbuild-rules_android-v0.1.1.zip
	https://github.com/bazelbuild/rules_apple/releases/download/1.0.1/rules_apple.1.0.1.tar.gz
	https://github.com/bazelbuild/rules_cc/archive/081771d4a0e9d7d3aa0eed2ef389fa4700dfb23e.tar.gz -> bazelbuild-rules_cc-081771d4a0e9d7d3aa0eed2ef389fa4700dfb23e.tar.gz
	https://github.com/bazelbuild/rules_closure/archive/308b05b2419edb5c8ee0471b67a40403df940149.tar.gz -> bazelbuild-rules_closure-308b05b2419edb5c8ee0471b67a40403df940149.tar.gz
	https://github.com/bazelbuild/rules_docker/releases/download/v0.10.0/rules_docker-v0.10.0.tar.gz -> bazelbuild-rules_docker-v0.10.0.tar.gz
	https://github.com/bazelbuild/rules_foreign_cc/archive/0.7.1.tar.gz -> bazelbuild-rules_foreign_cc-0.7.1.tar.gz
	https://github.com/bazelbuild/rules_java/archive/7cf3cefd652008d0a64a419c34c13bdca6c8f178.zip -> bazelbuild-rules_java-7cf3cefd652008d0a64a419c34c13bdca6c8f178.zip
	https://github.com/bazelbuild/rules_java/releases/download/5.5.1/rules_java-5.5.1.tar.gz -> bazelbuild-rules_java-5.5.1.tar.gz
	https://github.com/bazelbuild/rules_jvm_external/archive/4.3.zip -> bazelbuild-rules_jvm_external-4.3.zip
	https://github.com/bazelbuild/rules_pkg/releases/download/0.7.1/rules_pkg-0.7.1.tar.gz -> bazelbuild-rules_pkg-0.7.1.tar.gz
	https://github.com/bazelbuild/rules_proto/archive/11bf7c25e666dd7ddacbcd4d4c4a9de7a25175f8.tar.gz -> bazelbuild-rules_proto-11bf7c25e666dd7ddacbcd4d4c4a9de7a25175f8.tar.gz
	https://github.com/bazelbuild/rules_python/releases/download/0.0.1/rules_python-0.0.1.tar.gz -> bazelbuild-rules_python-0.0.1.tar.gz
	https://github.com/bazelbuild/rules_swift/releases/download/1.0.0/rules_swift.1.0.0.tar.gz -> bazelbuild-rules_swift.1.0.0.tar.gz
	https://github.com/dmlc/dlpack/archive/9351cf542ab478499294864ff3acfdab5c8c5f3d.tar.gz -> dlpack-9351cf542ab478499294864ff3acfdab5c8c5f3d.tar.gz
	https://github.com/google/XNNPACK/archive/b9d4073a6913891ce9cbd8965c8d506075d2a45a.zip -> XNNPACK-b9d4073a6913891ce9cbd8965c8d506075d2a45a.zip
	https://github.com/google/benchmark/archive/f7547e29ccaed7b64ef4f7495ecfff1c9f6f3d03.tar.gz -> benchmark-f7547e29ccaed7b64ef4f7495ecfff1c9f6f3d03.tar.gz
	https://github.com/google/farmhash/archive/0d859a811870d10f53a594927d0d0b97573ad06d.tar.gz -> farmhash-0d859a811870d10f53a594927d0d0b97573ad06d.tar.gz
	https://github.com/google/gemmlowp/archive/e844ffd17118c1e17d94e1ba4354c075a4577b88.zip -> gemmlowp-e844ffd17118c1e17d94e1ba4354c075a4577b88.zip
	https://github.com/google/highwayhash/archive/c13d28517a4db259d738ea4886b1f00352a3cc33.tar.gz -> highwayhash-c13d28517a4db259d738ea4886b1f00352a3cc33.tar.gz
	https://github.com/google/re2/archive/a276a8c738735a0fe45a6ee590fe2df69bcf4502.tar.gz -> re2-a276a8c738735a0fe45a6ee590fe2df69bcf4502.tar.gz
	https://github.com/google/ruy/archive/3286a34cc8de6149ac6844107dfdffac91531e72.zip -> ruy-3286a34cc8de6149ac6844107dfdffac91531e72.zip
	https://github.com/googleapis/googleapis/archive/6b3fdcea8bc5398be4e7e9930c693f0ea09316a0.tar.gz -> googleapis-6b3fdcea8bc5398be4e7e9930c693f0ea09316a0.tar.gz
	https://github.com/joe-kuo/sobol_data/archive/835a7d7b1ee3bc83e575e302a985c66ec4b65249.tar.gz -> sobol_data-835a7d7b1ee3bc83e575e302a985c66ec4b65249.tar.gz
	https://github.com/llvm/llvm-project/archive/dc275fd03254d67d29cc70a5a0569acf24d2280d.tar.gz -> llvm-project-dc275fd03254d67d29cc70a5a0569acf24d2280d.tar.gz
	https://github.com/llvm/llvm-project/releases/download/llvmorg-10.0.1/openmp-10.0.1.src.tar.xz -> llvmorg-10.0.1-openmp-10.0.1.src.tar.xz
	https://github.com/mborgerding/kissfft/archive/131.1.0.tar.gz -> kissfft-131.1.0.tar.gz
	https://github.com/oneapi-src/oneDNN/archive/refs/tags/v2.7.3.tar.gz -> oneDNN-v2.7.3.tar.gz
	https://github.com/oneapi-src/oneDNN/archive/refs/tags/v3.1.tar.gz -> oneDNN-v3.1.tar.gz
	https://github.com/openxla/stablehlo/archive/43d81c6883ade82052920bd367c61f9e52f09954.zip -> openxla-stablehlo-43d81c6883ade82052920bd367c61f9e52f09954.zip
	https://github.com/openxla/triton/archive/1627e0c27869b4098e5fa720717645c1baaf5972.tar.gz -> openxla-triton-1627e0c27869b4098e5fa720717645c1baaf5972.tar.gz
	https://github.com/petewarden/OouraFFT/archive/v1.0.tar.gz -> OouraFFT-v1.0.tar.gz
	https://github.com/protocolbuffers/protobuf/archive/v3.21.9.zip -> protobuf-3.21.9.zip
	https://github.com/pybind/pybind11_abseil/archive/2c4932ed6f6204f1656e245838f4f5eae69d2e29.tar.gz -> pybind11_abseil-2c4932ed6f6204f1656e245838f4f5eae69d2e29.tar.gz
	https://github.com/pybind/pybind11_bazel/archive/72cbbf1fbc830e487e3012862b7b720001b70672.tar.gz -> pybind11_bazel-72cbbf1fbc830e487e3012862b7b720001b70672.tar.gz
	https://github.com/pybind/pybind11_protobuf/archive/80f3440cd8fee124e077e2e47a8a17b78b451363.zip -> pybind11_protobuf-80f3440cd8fee124e077e2e47a8a17b78b451363.zip
	https://github.com/pytorch/cpuinfo/archive/3dc310302210c1891ffcfb12ae67b11a3ad3a150.tar.gz -> pytorch-cpuinfo-3dc310302210c1891ffcfb12ae67b11a3ad3a150.tar.gz
	https://github.com/pytorch/cpuinfo/archive/3dc310302210c1891ffcfb12ae67b11a3ad3a150.zip -> pytorch-cpuinfo-3dc310302210c1891ffcfb12ae67b11a3ad3a150.zip
	https://github.com/tensorflow/runtime/archive/7d879c8b161085a4374ea481b93a52adb19c0529.tar.gz -> tensorflow-runtime-7d879c8b161085a4374ea481b93a52adb19c0529.tar.gz
	https://gitlab.com/libeigen/eigen/-/archive/b0f877f8e01e90a5b0f3a79d46ea234899f8b499/eigen-b0f877f8e01e90a5b0f3a79d46ea234899f8b499.tar.gz
	cuda? (
		https://github.com/NVIDIA/cudnn-frontend/archive/refs/tags/v0.9.zip -> cudnn-frontend-v0.9.zip
		https://github.com/NVlabs/cub/archive/1.9.9.zip -> cub-1.9.9.zip
		https://github.com/nvidia/nccl/archive/v2.16.5-1.tar.gz -> nvidia-nccl-v2.16.5-1.tar.gz
	)
	python? (
		https://github.com/intel/ARM_NEON_2_x86_SSE/archive/a15b489e1222b2087007546b4912e21293ea86ff.tar.gz -> ARM_NEON_2_x86_SSE-a15b489e1222b2087007546b4912e21293ea86ff.tar.gz
		https://storage.googleapis.com/mirror.tensorflow.org/docs.python.org/2.7/_sources/license.rst.txt -> tensorflow-1.15.0-python-license.rst.txt
	)"

SRC_URI="https://github.com/${PN}/${PN}/archive/v${MY_PV}.tar.gz -> ${P}.tar.gz
		${bazel_external_uris}"

# absl/log/check.h is needed in tensorflow-2.13.1, see
# https://github.com/tensorflow/tensorflow/blob/v2.13.1/tensorflow/compiler/jit/xla_compile_on_demand_op.cc
# which requires abseil-cpp>=20230125, see
# https://github.com/abseil/abseil-cpp/commit/92fdbfb301f8b301b28ab5c99e7361e775c2fb8a

# abseil-cpp need to compile with C++17
# abseil-cpp>=20230125.3 in repo are built with C++14

# check flatbuffers version in tensorflow/lite/schema/schema_generated.h

# BDEPEND: >=dev-libs/protobuf-3.8.0
		#>=dev-cpp/abseil-cpp-20230125.0:=
RDEPEND="
	app-arch/snappy
	=dev-cpp/abseil-cpp-20230125.2*:=
	dev-db/sqlite
	dev-libs/double-conversion
	dev-libs/icu:=
	>=dev-libs/jsoncpp-1.9.2:=
	>=dev-libs/nsync-1.25.0
	dev-libs/openssl:0=
	>=dev-libs/protobuf-3.13.0:=
	>=dev-libs/re2-0.2019.06.01:=
	media-libs/giflib
	media-libs/libjpeg-turbo
	media-libs/libpng:0
	>=net-libs/grpc-1.28:=
	net-misc/curl
	sys-libs/zlib
	>=sys-apps/hwloc-2:=
	cuda? (
		dev-util/nvidia-cuda-toolkit:=[profiler]
		=dev-libs/cudnn-8*
	)
	mpi? ( virtual/mpi )
	python? (
		${PYTHON_DEPS}
		~dev-libs/flatbuffers-23.1.21:=
		dev-python/absl-py[${PYTHON_USEDEP}]
		>=dev-python/astor-0.7.1[${PYTHON_USEDEP}]
		dev-python/astunparse[${PYTHON_USEDEP}]
		dev-python/clang-python[${PYTHON_USEDEP}]
		dev-python/dill[${PYTHON_USEDEP}]
		~dev-python/flatbuffers-23.1.21[${PYTHON_USEDEP}]
		>=dev-python/gast-0.3.3[${PYTHON_USEDEP}]
		dev-python/h5py[${PYTHON_USEDEP}]
		>=dev-python/numpy-1.19[${PYTHON_USEDEP}]
		>=dev-python/google-pasta-0.1.8[${PYTHON_USEDEP}]
		>=dev-python/opt-einsum-3.3.0[${PYTHON_USEDEP}]
		>=dev-python/protobuf-python-3.13.0[${PYTHON_USEDEP}]
		dev-python/pybind11[${PYTHON_USEDEP}]
		dev-python/six[${PYTHON_USEDEP}]
		dev-python/tblib[${PYTHON_USEDEP}]
		dev-python/termcolor[${PYTHON_USEDEP}]
		dev-python/typing-extensions[${PYTHON_USEDEP}]
		>=dev-python/grpcio-1.28[${PYTHON_USEDEP}]
		>=dev-python/wrapt-1.11.1[${PYTHON_USEDEP}]
		>=net-libs/google-cloud-cpp-0.10.0
		=sci-visualization/tensorboard-${DEP_VER}*[${PYTHON_USEDEP}]
	)"
DEPEND="${RDEPEND}
	python? (
		dev-python/mock
		dev-python/setuptools
	)"
PDEPEND="python? (
		=sci-libs/keras-${DEP_VER}*[${PYTHON_USEDEP}]
		=sci-libs/tensorflow-estimator-${DEP_VER}*[${PYTHON_USEDEP}]
	)"
BDEPEND="
	app-arch/unzip
	=dev-build/bazel-5*
	dev-java/java-config
	cuda? (
		>=dev-util/nvidia-cuda-toolkit-9.1[profiler]
	)
	!python? ( dev-lang/python )
	python? (
		dev-python/cython
		dev-python/mock
		>=dev-python/grpcio-tools-1.28
	)
	dev-util/patchelf"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

S="${WORKDIR}/${MY_P}"

DOCS=( AUTHORS CONTRIBUTING.md ISSUE_TEMPLATE.md README.md RELEASE.md )
CHECKREQS_MEMORY="5G"
CHECKREQS_DISK_BUILD="10G"

PATCHES=(
	"${FILESDIR}/tensorflow-2.13.0-0001-WORKSPACE-add-rules-docker-http_archive-bazel-toolch.patch"
	"${FILESDIR}/tensorflow-2.13.0-0002-systemlib-Latest-absl-LTS-has-split-cord-libs.patch"
	"${FILESDIR}/tensorflow-2.13.0-0003-mkl_dnn-Must-link-against-libm-for-round-and-log2.patch"
	"${FILESDIR}/tensorflow-2.13.0-0004-tensorflow_cc-Add-systemlib-nsync-linkopts.patch"
	"${FILESDIR}/tensorflow-2.13.0-0005-systemlib-Updates-for-Abseil-20220623-LTS.patch"
	"${FILESDIR}/tensorflow-2.13.0-0006-systemlib-Update-targets-for-absl_py.patch"
	"${FILESDIR}/tensorflow-2.13.0-0007-systemlibs-Add-well_known_types_py_pb2-target.patch"
	"${FILESDIR}/tensorflow-2.13.0-0008-Relax-setup.py-version-requirements.patch"
	"${FILESDIR}/tensorflow-2.13.0-0009-fix-sparse-transpose-op2.patch"
	"${FILESDIR}/tensorflow-2.13.0-0010-systemlibs-update-targets-for-absl.patch"
	"${FILESDIR}/tensorflow-2.13.0-0011-systemlibs-update-targets-for-google_cloud_cpp.patch"
	"${FILESDIR}/tensorflow-2.13.0-0012-bump-cudnn-frontend-to-v0.9.patch"
	"${FILESDIR}/tensorflow-2.13.0-0013-Fixing-build-issue-with-Clang-16-and-GCC-13.patch"
)

get-cpu-flags() {
	local i f=()
	# Keep this list in sync with tensorflow/core/platform/cpu_feature_guard.cc.
	for i in sse sse2 sse3 sse4_1 sse4_2 avx avx2 fma4; do
		use cpu_flags_x86_${i} && f+=( -m${i/_/.} )
	done
	use cpu_flags_x86_fma3 && f+=( -mfma )
	echo "${f[*]}"
}

pkg_setup() {
	local num_pythons_enabled
	num_pythons_enabled=0
	count_impls() {
		num_pythons_enabled=$((${num_pythons_enabled} + 1))
	}
	use python && python_foreach_impl count_impls

	# 10G to build C/C++ libs, 6G per python impl
	CHECKREQS_DISK_BUILD="$((10 + 6 * ${num_pythons_enabled}))G"
	check-reqs_pkg_setup
}

src_unpack() {
	# Only unpack the main distfile
	unpack "${P}.tar.gz"
	bazel_load_distfiles "${bazel_external_uris}"
}

src_prepare() {
	export JAVA_HOME=$(java-config --jre-home) # so keepwork works

	append-flags $(get-cpu-flags)
	append-cxxflags -std=c++17
	export BUILD_CXXFLAGS+=" -std=c++17"
	filter-flags '-fvtable-verify=@(std|preinit)'
	bazel_setup_bazelrc

	# Relax version checks in setup.py
	sed -i "/^    '/s/==/>=/g" tensorflow/tools/pip_package/setup.py || die
	# sed -i "/config_googleapis/d" tensorflow/workspace0.bzl || die

	# Prefixify hard-coded command locations
	hprefixify -w /host_compiler_prefix/ third_party/gpus/cuda_configure.bzl

	default
	use python && python_copy_sources

	use cuda && cuda_add_sandbox
}

src_configure() {
	export JAVA_HOME=$(java-config --jre-home) # so keepwork works
	export KERAS_HOME="${T}/.keras" # otherwise sandbox violation writing ~/.keras

	do_configure() {
		export CC_OPT_FLAGS=" "
		export TF_ENABLE_XLA=$(usex xla 1 0)
		export TF_NEED_OPENCL_SYCL=0
		export TF_NEED_OPENCL=0
		export TF_NEED_COMPUTECPP=0
		export TF_NEED_ROCM=0
		export TF_NEED_MPI=$(usex mpi 1 0)
		export TF_SET_ANDROID_WORKSPACE=0

		if use python; then
			export PYTHON_BIN_PATH="${PYTHON}"
			export PYTHON_LIB_PATH="$(python_get_sitedir)"
		else
			export PYTHON_BIN_PATH="$(which python)"
			export PYTHON_LIB_PATH="$(python -c 'from distutils.sysconfig import *; print(get_python_lib())')"
		fi

		export TF_NEED_CUDA=$(usex cuda 1 0)
		export TF_DOWNLOAD_CLANG=0
		export TF_CUDA_CLANG=0
		export TF_NEED_TENSORRT=0	# $(usex cuda 1 0)
		if use cuda; then
			export TF_CUDA_PATHS="${EPREFIX}/opt/cuda"
			export GCC_HOST_COMPILER_PATH="$(cuda_gccdir)/$(tc-getCC)"
			export TF_CUDA_VERSION="$(cuda_toolkit_version)"
			export TF_CUDNN_VERSION="$(cuda_cudnn_version)"
			einfo "Setting CUDA version: $TF_CUDA_VERSION"
			einfo "Setting CUDNN version: $TF_CUDNN_VERSION"

			if [[ $(cuda-config -s) != *$(gcc-version)* ]]; then
				ewarn "TensorFlow is being built with Nvidia CUDA support. Your default compiler"
				ewarn "version is not supported by the currently installed CUDA. TensorFlow will"
				ewarn "instead be compiled using: ${GCC_HOST_COMPILER_PATH}."
				ewarn "If the build fails with linker errors try rebuilding the relevant"
				ewarn "dependencies using the same compiler version."
			fi

			if [[ -z "$TF_CUDA_COMPUTE_CAPABILITIES" ]]; then
				ewarn "WARNING: TensorFlow is being built with its default CUDA compute capabilities: 3.5 and 7.0."
				ewarn "These may not be optimal for your GPU."
				ewarn ""
				ewarn "To configure TensorFlow with the CUDA compute capability that is optimal for your GPU,"
				ewarn "set TF_CUDA_COMPUTE_CAPABILITIES in your make.conf, and re-emerge tensorflow."
				ewarn "For example, to use CUDA capability 7.5 & 3.5, add: TF_CUDA_COMPUTE_CAPABILITIES=7.5,3.5"
				ewarn ""
				ewarn "You can look up your GPU's CUDA compute capability at https://developer.nvidia.com/cuda-gpus"
				ewarn "or by running /opt/cuda/extras/demo_suite/deviceQuery | grep 'CUDA Capability'"
			fi
		fi

		# com_googlesource_code_re2 weird branch using absl, doesnt work with released re2
		# com_github_googleapis_googleapis
		# com_google_protobuf is disabled due to https://github.com/tensorflow/tensorflow/issues/61593
		local SYSLIBS=(
			absl_py
			astor_archive
			astunparse_archive
			boringssl
			com_github_googlecloudplatform_google_cloud_cpp
			com_github_grpc_grpc
			com_google_absl
			# com_google_protobuf
			curl
			cython
			dill_archive
			double_conversion
			flatbuffers
			functools32_archive
			gast_archive
			gif
			hwloc
			icu
			jsoncpp_git
			libjpeg_turbo
			nasm
			nsync
			opt_einsum_archive
			org_sqlite
			pasta
			png
			pybind11
			six_archive
			snappy
			tblib_archive
			termcolor_archive
			typing_extensions_archive
			wrapt
			zlib
		)

		export TF_SYSTEM_LIBS="${SYSLIBS[@]}"
		export TF_IGNORE_MAX_BAZEL_VERSION=1

		# This is not autoconf
		./configure || die

		echo 'build --config=noaws --config=nohdfs --config=nonccl' >> .bazelrc || die
		echo 'build --define tensorflow_mkldnn_contraction_kernel=0' >> .bazelrc || die
		echo "build --action_env=KERAS_HOME=\"${T}/.keras\"" >> .bazelrc || die
		echo "build --host_action_env=KERAS_HOME=\"${T}/.keras\"" >> .bazelrc || die

		for cflag in $($(tc-getPKG_CONFIG) jsoncpp --cflags)
		do
			echo "build --copt=\"${cflag}\"" >> .bazelrc || die
			echo "build --host_copt=\"${cflag}\"" >> .bazelrc || die
		done
	}
	if use python; then
		python_foreach_impl run_in_build_dir do_configure
	else
		do_configure
	fi
}

src_compile() {
	export JAVA_HOME=$(java-config --jre-home) # so keepwork works
	export KERAS_HOME="${T}/.keras" # otherwise sandbox violation writing ~/.keras

	if use python; then
		python_setup
		BUILD_DIR="${S}-${EPYTHON/./_}"
		cd "${BUILD_DIR}" || die
	fi

	# fail early if any deps are missing
	ebazel build -k --nobuild \
		//tensorflow:libtensorflow_framework.so \
		//tensorflow:libtensorflow.so \
		//tensorflow:libtensorflow_cc.so \
		$(usex python '//tensorflow/tools/pip_package:build_pip_package' '')

	ebazel build \
		//tensorflow:libtensorflow_framework.so \
		//tensorflow:libtensorflow.so
	ebazel build //tensorflow:libtensorflow_cc.so
	ebazel build //tensorflow:install_headers
	ebazel shutdown

	do_compile() {
		ebazel build //tensorflow/tools/pip_package:build_pip_package
		ebazel shutdown
	}
	BUILD_DIR="${S}"
	cd "${BUILD_DIR}" || die
	use python && python_foreach_impl run_in_build_dir do_compile
}

src_install() {
	local i l
	export JAVA_HOME=$(java-config --jre-home) # so keepwork works
	export KERAS_HOME="${T}/.keras" # otherwise sandbox violation writing ~/.keras

	do_install() {
		einfo "Installing ${EPYTHON} files"
		local srcdir="${T}/src-${MULTIBUILD_VARIANT}"
		mkdir -p "${srcdir}" || die
		bazel-bin/tensorflow/tools/pip_package/build_pip_package --src "${srcdir}" || die
		cd "${srcdir}" || die
		esetup.py install

		# libtensorflow_framework.so and libtensorflow_cc.so is in /usr/lib already
		rm -f "${D}/$(python_get_sitedir)"/${PN}/lib${PN}_framework.so* || die
		rm -f "${D}/$(python_get_sitedir)"/${PN}/lib${PN}_cc.so* || die
		python_optimize
	}

	if use python; then
		python_foreach_impl run_in_build_dir do_install

		# Symlink to python-exec scripts
		for i in "${ED}"/usr/lib/python-exec/*/*; do
			n="${i##*/}"
			[[ -e "${ED}/usr/bin/${n}" ]] || dosym ../lib/python-exec/python-exec2 "/usr/bin/${n}"
		done

		python_setup
		local BUILD_DIR="${S}-${EPYTHON/./_}"
		cd "${BUILD_DIR}" || die
	fi

	einfo "Installing headers"
	insinto /usr/include/${PN}/
	doins -r bazel-bin/tensorflow/include/*

	einfo "Installing libs"
	# Generate pkg-config file
	${PN}/c/generate-pc.sh --prefix="${EPREFIX}"/usr --libdir=$(get_libdir) --version=${MY_PV} || die
	insinto /usr/$(get_libdir)/pkgconfig
	doins ${PN}.pc ${PN}_cc.pc

	for l in libtensorflow{,_framework,_cc}.so; do
		patchelf --add-rpath '/opt/cuda/lib64' bazel-bin/tensorflow/${l}
		dolib.so bazel-bin/tensorflow/${l}
		dolib.so bazel-bin/tensorflow/${l}.$(ver_cut 1)
		dolib.so bazel-bin/tensorflow/${l}.$(ver_cut 1-3)
	done

	einstalldocs

	# Workaround for https://bugs.gentoo.org/831927
	export MAKEOPTS="-j1"
}
