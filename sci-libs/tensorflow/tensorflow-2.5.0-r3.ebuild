# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_OPTIONAL=1
PYTHON_COMPAT=( python3_{7,8,9} )
DISTUTILS_USE_SETUPTOOLS=rdepend
MY_PV=${PV/_rc/-rc}
MY_P=${PN}-${MY_PV}

inherit bazel check-reqs cuda distutils-r1 flag-o-matic prefix toolchain-funcs

DESCRIPTION="Computation framework using data flow graphs for scalable machine learning"
HOMEPAGE="https://www.tensorflow.org/"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="cuda mpi +python xla"
CPU_USE_FLAGS_X86="sse sse2 sse3 sse4_1 sse4_2 avx avx2 fma3 fma4"
for i in $CPU_USE_FLAGS_X86; do
	IUSE+=" cpu_flags_x86_${i}"
done

# distfiles that bazel uses for the workspace, will be copied to basel-distdir
bazel_external_uris="
	https://github.com/abseil/abseil-cpp/archive/6f9d96a1f41439ac172ee2ef7ccd8edf0e5d068c.tar.gz -> abseil-cpp-6f9d96a1f41439ac172ee2ef7ccd8edf0e5d068c.tar.gz
	https://github.com/bazelbuild/bazel-skylib/releases/download/1.0.3/bazel-skylib-1.0.3.tar.gz
	https://github.com/bazelbuild/bazel-toolchains/archive/92dd8a7a518a2fb7ba992d47c8b38299fe0be825.tar.gz -> bazel-toolchains-92dd8a7a518a2fb7ba992d47c8b38299fe0be825.tar.gz
	https://github.com/bazelbuild/rules_android/archive/v0.1.1.zip -> bazelbuild-rules_android-v0.1.1.zip
	https://github.com/bazelbuild/rules_cc/archive/01d4a48911d5e7591ecb1c06d3b8af47fe872371.zip -> bazelbuild-rules_cc-01d4a48911d5e7591ecb1c06d3b8af47fe872371.zip
	https://github.com/bazelbuild/rules_closure/archive/308b05b2419edb5c8ee0471b67a40403df940149.tar.gz -> bazelbuild-rules_closure-308b05b2419edb5c8ee0471b67a40403df940149.tar.gz
	https://github.com/bazelbuild/rules_docker/releases/download/v0.10.0/rules_docker-v0.10.0.tar.gz -> bazelbuild-rules_docker-v0.10.0.tar.gz
	https://github.com/bazelbuild/rules_java/archive/7cf3cefd652008d0a64a419c34c13bdca6c8f178.zip -> bazelbuild-rules_java-7cf3cefd652008d0a64a419c34c13bdca6c8f178.zip
	https://github.com/bazelbuild/rules_proto/archive/97d8af4dc474595af3900dd85cb3a29ad28cc313.tar.gz -> bazelbuild-rules_proto-97d8af4dc474595af3900dd85cb3a29ad28cc313.tar.gz
	https://github.com/bazelbuild/rules_python/releases/download/0.0.1/rules_python-0.0.1.tar.gz -> bazelbuild-rules_python-0.0.1.tar.gz
	https://github.com/bazelbuild/rules_swift/archive/3eeeb53cebda55b349d64c9fc144e18c5f7c0eb8.tar.gz -> bazelbuild-rules_swift-3eeeb53cebda55b349d64c9fc144e18c5f7c0eb8.tar.gz
	https://github.com/dmlc/dlpack/archive/3efc489b55385936531a06ff83425b719387ec63.tar.gz -> dlpack-3efc489b55385936531a06ff83425b719387ec63.tar.gz
	https://github.com/google/farmhash/archive/816a4ae622e964763ca0862d9dbd19324a1eaf45.tar.gz -> farmhash-816a4ae622e964763ca0862d9dbd19324a1eaf45.tar.gz
	https://github.com/google/gemmlowp/archive/fda83bdc38b118cc6b56753bd540caa49e570745.zip -> gemmlowp-fda83bdc38b118cc6b56753bd540caa49e570745.zip
	https://github.com/google/highwayhash/archive/fd3d9af80465e4383162e4a7c5e2f406e82dd968.tar.gz -> highwayhash-fd3d9af80465e4383162e4a7c5e2f406e82dd968.tar.gz
	https://github.com/google/re2/archive/506cfa4bffd060c06ec338ce50ea3468daa6c814.tar.gz -> re2-506cfa4bffd060c06ec338ce50ea3468daa6c814.tar.gz
	https://github.com/google/ruy/archive/54774a7a2cf85963777289193629d4bd42de4a59.zip -> ruy-54774a7a2cf85963777289193629d4bd42de4a59.zip
	https://github.com/joe-kuo/sobol_data/archive/835a7d7b1ee3bc83e575e302a985c66ec4b65249.tar.gz -> sobol_data-835a7d7b1ee3bc83e575e302a985c66ec4b65249.tar.gz
	https://github.com/llvm/llvm-project/archive/1f6a57c1a0fad922e04a2b1f414b092d4b0cd8b0.tar.gz -> llvm-1f6a57c1a0fad922e04a2b1f414b092d4b0cd8b0.tar.gz
	https://github.com/llvm/llvm-project/releases/download/llvmorg-10.0.1/openmp-10.0.1.src.tar.xz -> llvmorg-10.0.1-openmp-10.0.1.src.tar.xz
	https://github.com/mborgerding/kissfft/archive/36dbc057604f00aacfc0288ddad57e3b21cfc1b8.tar.gz -> kissfft-36dbc057604f00aacfc0288ddad57e3b21cfc1b8.tar.gz
	https://github.com/oneapi-src/oneDNN/archive/v2.2.tar.gz -> oneDNN-v2.2.tar.gz
	https://github.com/petewarden/OouraFFT/archive/v1.0.tar.gz -> OouraFFT-v1.0.tar.gz
	https://github.com/pytorch/cpuinfo/archive/5916273f79a21551890fd3d56fc5375a78d1598d.zip -> pytorch-cpuinfo-5916273f79a21551890fd3d56fc5375a78d1598d.zip
	https://github.com/pytorch/cpuinfo/archive/d5e37adf1406cf899d7d9ec1d317c47506ccb970.tar.gz -> pytorch-cpuinfo-d5e37adf1406cf899d7d9ec1d317c47506ccb970.tar.gz
	https://github.com/tensorflow/toolchains/archive/v1.1.10.tar.gz -> tensorflow-toolchains-v1.1.10.tar.gz
	https://gitlab.com/libeigen/eigen/-/archive/f612df273689a19d25b45ca4f8269463207c4fee/eigen-f612df273689a19d25b45ca4f8269463207c4fee.tar.gz
	cuda? (
		https://github.com/NVIDIA/cudnn-frontend/archive/360d6e7164dfb7c802493fd1c0464f0d815b852a.zip -> cudnn-frontend-360d6e7164dfb7c802493fd1c0464f0d815b852a.zip
		https://github.com/NVlabs/cub/archive/1.9.9.zip -> cub-1.9.9.zip
		https://github.com/nvidia/nccl/archive/v2.8.3-1.tar.gz -> nvidia-nccl-v2.8.3-1.tar.gz
	)
	python? (
		https://github.com/intel/ARM_NEON_2_x86_SSE/archive/1200fe90bb174a6224a525ee60148671a786a71f.tar.gz -> ARM_NEON_2_x86_SSE-1200fe90bb174a6224a525ee60148671a786a71f.tar.gz
		https://storage.googleapis.com/mirror.tensorflow.org/docs.python.org/2.7/_sources/license.rst.txt -> tensorflow-1.15.0-python-license.rst.txt
		https://pypi.python.org/packages/bc/cc/3cdb0a02e7e96f6c70bd971bc8a90b8463fda83e264fa9c5c1c98ceabd81/backports.weakref-1.0rc1.tar.gz
	)"

SRC_URI="https://github.com/${PN}/${PN}/archive/v${MY_PV}.tar.gz -> ${P}.tar.gz
		https://dev.gentoo.org/~perfinion/patches/tensorflow-patches-${PVR}.tar.bz2
		${bazel_external_uris}"

RDEPEND="
	app-arch/snappy
	dev-db/lmdb
	dev-db/sqlite
	dev-libs/double-conversion
	dev-libs/icu:=
	>=dev-libs/jsoncpp-1.9.2:=
	dev-libs/libpcre
	dev-libs/nsync
	dev-libs/openssl:0=
	<dev-libs/protobuf-3.19.1:=
	>=dev-libs/re2-0.2019.06.01:=
	media-libs/giflib
	media-libs/libjpeg-turbo
	media-libs/libpng:0
	<net-libs/grpc-1.39:=
	net-misc/curl
	sys-libs/zlib
	>=sys-apps/hwloc-2:=
	cuda? (
		|| (
			=dev-util/nvidia-cuda-toolkit-10*[profiler]
			=dev-util/nvidia-cuda-toolkit-11.4*[profiler]
		)
		=dev-libs/cudnn-8*
	)
	mpi? ( virtual/mpi )
	python? (
		${PYTHON_DEPS}
		>=dev-libs/flatbuffers-1.12.0:=
		dev-python/absl-py[${PYTHON_USEDEP}]
		>=dev-python/astor-0.7.1[${PYTHON_USEDEP}]
		dev-python/astunparse[${PYTHON_USEDEP}]
		dev-python/dill[${PYTHON_USEDEP}]
		dev-python/flatbuffers[${PYTHON_USEDEP}]
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
		>=sci-libs/keras-applications-1.0.8[${PYTHON_USEDEP}]
		>=sci-libs/keras-preprocessing-1.1.2[${PYTHON_USEDEP}]
		>=sci-visualization/tensorboard-2.5.0[${PYTHON_USEDEP}]
	)"
DEPEND="${RDEPEND}
	python? (
		dev-python/mock
		dev-python/setuptools
	)"
PDEPEND="python? (
		>=sci-libs/tensorflow-estimator-2.5.0[${PYTHON_USEDEP}]
	)"
BDEPEND="
	app-arch/unzip
	>=dev-libs/protobuf-3.8.0
	dev-java/java-config
	>=dev-util/bazel-3.7.2
	cuda? (
		>=dev-util/nvidia-cuda-toolkit-9.1[profiler]
	)
	!python? ( dev-lang/python )
	python? (
		dev-python/cython
		dev-python/mock
		>=dev-python/grpcio-tools-1.28
	)"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

S="${WORKDIR}/${MY_P}"

DOCS=( AUTHORS CONTRIBUTING.md ISSUE_TEMPLATE.md README.md RELEASE.md )
CHECKREQS_MEMORY="5G"
CHECKREQS_DISK_BUILD="10G"

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
	ewarn "TensorFlow 2.0 is a major release that contains some incompatibilities"
	ewarn "with TensorFlow 1.x. For more information about migrating to TF2.0 see:"
	ewarn "https://www.tensorflow.org/guide/migrate"

	local num_pythons_enabled
	num_pythons_enabled=0
	count_impls() {
		num_pythons_enabled=$((${num_pythons_enabled} + 1))
	}
	use python && python_foreach_impl count_impls

	# 10G to build C/C++ libs, 5G per python impl
	CHECKREQS_DISK_BUILD="$((10 + 6 * ${num_pythons_enabled}))G"
	check-reqs_pkg_setup
}

src_unpack() {
	# Only unpack the main distfile
	unpack "${P}.tar.gz"
	unpack tensorflow-patches-${PVR}.tar.bz2
	bazel_load_distfiles "${bazel_external_uris}"
}

src_prepare() {
	export JAVA_HOME=$(java-config --jre-home) # so keepwork works

	append-flags $(get-cpu-flags)
	append-cxxflags -std=c++14 # bug 787938
	filter-flags '-fvtable-verify=@(std|preinit)'
	bazel_setup_bazelrc

	eapply "${WORKDIR}"/patches/*.patch

	# Relax version checks in setup.py
	sed -i "/^    '/s/==/>=/g" tensorflow/tools/pip_package/setup.py || die
	sed -i "/config_googleapis/d" tensorflow/workspace0.bzl || die

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
		export TF_NEED_TENSORRT=0
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
		#com_github_googleapis_googleapis
		local SYSLIBS=(
			absl_py
			astor_archive
			astunparse_archive
			boringssl
			com_github_googlecloudplatform_google_cloud_cpp
			com_github_grpc_grpc
			com_google_protobuf
			curl
			cython
			dill_archive
			double_conversion
			enum34_archive
			flatbuffers
			functools32_archive
			gast_archive
			gif
			hwloc
			icu
			jsoncpp_git
			libjpeg_turbo
			lmdb
			nasm
			nsync
			opt_einsum_archive
			org_sqlite
			pasta
			pcre
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

		echo 'build --config=noaws --config=nohdfs' >> .bazelrc || die
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
		cd "${BUILD_DIR}"
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

	do_compile() {
		ebazel build //tensorflow/tools/pip_package:build_pip_package
	}
	BUILD_DIR="${S}"
	cd "${BUILD_DIR}"
	use python && python_foreach_impl run_in_build_dir do_compile
	ebazel shutdown
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

		# libtensorflow_framework.so is in /usr/lib already
		rm -f "${D}/$(python_get_sitedir)"/${PN}/lib${PN}_framework.so* || die
		rm -f "${D}/$(python_get_sitedir)"/${PN}_core/lib${PN}_framework.so* || die
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
	ebazel build //tensorflow:install_headers
	ebazel shutdown
	insinto /usr/include/${PN}/
	doins -r bazel-bin/tensorflow/include/*

	einfo "Installing libs"
	# Generate $(tc-getPKG_CONFIG) file
	${PN}/c/generate-pc.sh --prefix="${EPREFIX}"/usr --libdir=$(get_libdir) --version=${MY_PV} || die
	insinto /usr/$(get_libdir)/pkgconfig
	doins ${PN}.pc ${PN}_cc.pc

	for l in libtensorflow{,_framework,_cc}.so; do
		dolib.so bazel-bin/tensorflow/${l}
		dolib.so bazel-bin/tensorflow/${l}.$(ver_cut 1)
		dolib.so bazel-bin/tensorflow/${l}.$(ver_cut 1-3)
	done

	einstalldocs
}
