# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_OPTIONAL=1
PYTHON_COMPAT=( python{3_5,3_6,3_7} )
MY_PV=${PV/_rc/-rc}
MY_P=${PN}-${MY_PV}

inherit bazel check-reqs cuda distutils-r1 flag-o-matic toolchain-funcs

DESCRIPTION="Computation framework using data flow graphs for scalable machine learning"
HOMEPAGE="https://www.tensorflow.org/"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="cuda mpi +python xla"
CPU_USE_FLAGS_X86="sse sse2 sse3 sse4_1 sse4_2 avx avx2 fma3 fma4"
for i in $CPU_USE_FLAGS_X86; do
	IUSE+=" cpu_flags_x86_$i"
done

# distfiles that bazel uses for the workspace, will be copied to basel-distdir
bazel_external_uris="
	http://www.kurims.kyoto-u.ac.jp/~ooura/fft2d.tgz -> oourafft2d-20061228.tgz
	https://bitbucket.org/eigen/eigen/get/49177915a14a.tar.gz -> eigen-49177915a14a.tar.gz
	https://github.com/abseil/abseil-cpp/archive/43ef2148c0936ebf7cb4be6b19927a9d9d145b8f.tar.gz -> abseil-cpp-43ef2148c0936ebf7cb4be6b19927a9d9d145b8f.tar.gz
	https://github.com/bazelbuild/bazel-skylib/releases/download/0.8.0/bazel-skylib.0.8.0.tar.gz
	https://github.com/bazelbuild/bazel-toolchains/archive/92dd8a7a518a2fb7ba992d47c8b38299fe0be825.tar.gz -> bazel-toolchains-92dd8a7a518a2fb7ba992d47c8b38299fe0be825.tar.gz
	https://github.com/bazelbuild/rules_closure/archive/308b05b2419edb5c8ee0471b67a40403df940149.tar.gz -> bazelbuild-rules_closure-308b05b2419edb5c8ee0471b67a40403df940149.tar.gz
	https://github.com/bazelbuild/rules_docker/releases/download/v0.10.0/rules_docker-v0.10.0.tar.gz -> bazelbuild-rules_docker-v0.10.0.tar.gz
	https://github.com/bazelbuild/rules_swift/releases/download/0.11.1/rules_swift.0.11.1.tar.gz -> bazelbuild-rules_swift.0.11.1.tar.gz
	https://github.com/google/farmhash/archive/816a4ae622e964763ca0862d9dbd19324a1eaf45.tar.gz -> farmhash-816a4ae622e964763ca0862d9dbd19324a1eaf45.tar.gz
	https://github.com/google/gemmlowp/archive/12fed0cd7cfcd9e169bf1925bc3a7a58725fdcc3.zip -> gemmlowp-12fed0cd7cfcd9e169bf1925bc3a7a58725fdcc3.zip
	https://github.com/google/highwayhash/archive/fd3d9af80465e4383162e4a7c5e2f406e82dd968.tar.gz -> highwayhash-fd3d9af80465e4383162e4a7c5e2f406e82dd968.tar.gz
	https://github.com/mborgerding/kissfft/archive/36dbc057604f00aacfc0288ddad57e3b21cfc1b8.tar.gz -> kissfft-36dbc057604f00aacfc0288ddad57e3b21cfc1b8.tar.gz
	https://github.com/nlopezgi/bazel-toolchains/archive/94d31935a2c94fe7e7c7379a0f3393e181928ff7.tar.gz -> bazel-toolchains-94d31935a2c94fe7e7c7379a0f3393e181928ff7.tar.gz
	https://github.com/pybind/pybind11/archive/v2.3.0.tar.gz -> pybind11-v2.3.0.tar.gz
	https://github.com/llvm-mirror/llvm/archive/7a7e03f906aada0cf4b749b51213fe5784eeff84.tar.gz -> llvm-7a7e03f906aada0cf4b749b51213fe5784eeff84.tar.gz
	cuda? (
		https://github.com/nvidia/nccl/archive/0ceaec9cee96ae7658aa45686853286651f36384.tar.gz -> nvidia-nccl-0ceaec9cee96ae7658aa45686853286651f36384.tar.gz
		https://github.com/NVlabs/cub/archive/1.8.0.zip -> cub-1.8.0.zip
	)
	python? (
		https://github.com/intel/ARM_NEON_2_x86_SSE/archive/1200fe90bb174a6224a525ee60148671a786a71f.tar.gz -> ARM_NEON_2_x86_SSE-1200fe90bb174a6224a525ee60148671a786a71f.tar.gz
		https://storage.googleapis.com/mirror.tensorflow.org/docs.python.org/2.7/_sources/license.rst.txt -> tensorflow-1.15.0-python-license.rst.txt
		https://pypi.python.org/packages/bc/cc/3cdb0a02e7e96f6c70bd971bc8a90b8463fda83e264fa9c5c1c98ceabd81/backports.weakref-1.0rc1.tar.gz
	)"

SRC_URI="https://github.com/${PN}/${PN}/archive/v${MY_PV}.tar.gz -> ${P}.tar.gz
		${bazel_external_uris}"

RDEPEND="
	app-arch/snappy
	dev-db/lmdb
	dev-db/sqlite
	dev-libs/double-conversion
	dev-libs/icu
	~dev-libs/jsoncpp-1.9.1
	dev-libs/libpcre
	dev-libs/nsync
	dev-libs/openssl:0=
	>=dev-libs/protobuf-3.6.1:=
	>=dev-libs/re2-0.2018.04.01
	media-libs/giflib
	media-libs/libjpeg-turbo
	media-libs/libpng:0
	>=net-libs/grpc-1.22.0
	net-misc/curl
	sys-libs/zlib
	>=sys-apps/hwloc-2
	cuda? (
		>=dev-util/nvidia-cuda-toolkit-9.1[profiler]
		dev-libs/cudnn
	)
	mpi? ( virtual/mpi )
	python? (
		${PYTHON_DEPS}
		>=dev-libs/flatbuffers-1.8.0
		dev-python/absl-py[${PYTHON_USEDEP}]
		>=dev-python/astor-0.7.1[${PYTHON_USEDEP}]
		dev-python/gast[${PYTHON_USEDEP}]
		>=dev-python/numpy-1.16[${PYTHON_USEDEP}]
		dev-python/google-pasta[${PYTHON_USEDEP}]
		dev-python/opt-einsum[${PYTHON_USEDEP}]
		>=dev-python/protobuf-python-3.6.1[${PYTHON_USEDEP}]
		dev-python/six[${PYTHON_USEDEP}]
		dev-python/termcolor[${PYTHON_USEDEP}]
		>=dev-python/grpcio-1.22.0[${PYTHON_USEDEP}]
		>=dev-python/wrapt-1.11.1[${PYTHON_USEDEP}]
		>=net-libs/google-cloud-cpp-0.10.0
		>=sci-libs/keras-applications-1.0.8[${PYTHON_USEDEP}]
		>=sci-libs/keras-preprocessing-1.0.5[${PYTHON_USEDEP}]
		=sci-visualization/tensorboard-1*[${PYTHON_USEDEP}]
	)"
DEPEND="${RDEPEND}
	dev-python/mock"
PDEPEND="python? (
		=sci-libs/tensorflow-estimator-1*[${PYTHON_USEDEP}]
	)"
BDEPEND="
	>=dev-libs/protobuf-3.6.0
	dev-java/java-config
	dev-python/mock
	dev-lang/swig
	dev-python/cython
	|| (
		=dev-util/bazel-0.24*
		=dev-util/bazel-0.27*
	)
	cuda? (
		>=dev-util/nvidia-cuda-toolkit-9.1[profiler]
	)
	!python? ( dev-lang/python )
	python? (
		>=dev-python/grpcio-tools-1.22.0
	)"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

S="${WORKDIR}/${MY_P}"

PATCHES=(
	"${FILESDIR}/tensorflow-1.15.0_rc0-0001-WORKSPACE-add-rules-docker-http_archive-bazel-toolch.patch"
	"${FILESDIR}/tensorflow-1.15.0_rc0-0002-systemlibs-unbundle-functools32.patch"
)
DOCS=( AUTHORS CONTRIBUTING.md ISSUE_TEMPLATE.md README.md RELEASE.md )
CHECKREQS_MEMORY="5G"
CHECKREQS_DISK_BUILD="5G"

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
	count_impls(){
		num_pythons_enabled=$((${num_pythons_enabled} + 1))
	}
	use python && python_foreach_impl count_impls

	# 5 G to build C/C++ libs, 5G per python impl
	CHECKREQS_DISK_BUILD="$((5 + 5 * $num_pythons_enabled))G"
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
	bazel_setup_bazelrc

	if ver_test "$(cuda_toolkit_version)" -ge "10.2"; then
		eapply "${FILESDIR}/tensorflow-2.1.0-cuda_10.2_support_bin2c.patch"
	fi

	default
	use python && python_copy_sources

	use cuda && cuda_add_sandbox
}

src_configure() {
	export JAVA_HOME=$(java-config --jre-home) # so keepwork works

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
			python_export PYTHON_SITEDIR
			export PYTHON_BIN_PATH="${PYTHON}"
			export PYTHON_LIB_PATH="${PYTHON_SITEDIR}"
		else
			export PYTHON_BIN_PATH="$(which python)"
			export PYTHON_LIB_PATH="$(python -c 'from distutils.sysconfig import *; print(get_python_lib())')"
		fi

		export TF_NEED_CUDA=$(usex cuda 1 0)
		export TF_DOWNLOAD_CLANG=0
		export TF_CUDA_CLANG=0
		export TF_NEED_TENSORRT=0
		if use cuda; then
			export TF_CUDA_PATHS="${EPREFIX%/}/opt/cuda"
			export GCC_HOST_COMPILER_PATH="$(cuda_gccdir)/$(tc-getCC)"
			export TF_CUDA_VERSION="$(cuda_toolkit_version)"
			export TF_CUDNN_VERSION="$(cuda_cudnn_version)"
			einfo "Setting CUDA version: $TF_CUDA_VERSION"
			einfo "Setting CUDNN version: $TF_CUDNN_VERSION"

			if [[ -z "$TF_CUDA_COMPUTE_CAPABILITIES" ]]; then
				ewarn "WARNING: Tensorflow is being built with its default CUDA compute capabilities: 3.5 and 7.0."
				ewarn "These may not be optimal for your GPU."
				ewarn ""
				ewarn "To configure Tensorflow with the CUDA compute capability that is optimal for your GPU,"
				ewarn "set TF_CUDA_COMPUTE_CAPABILITIES in your make.conf, and re-emerge tensorflow."
				ewarn "For example, to use CUDA capability 7.5 & 3.5, add: TF_CUDA_COMPUTE_CAPABILITIES=7.5,3.5"
				ewarn ""
				ewarn "You can look up your GPU's CUDA compute capability at https://developer.nvidia.com/cuda-gpus"
				ewarn "or by running /opt/cuda/extras/demo_suite/deviceQuery | grep 'CUDA Capability'"
			fi
		fi

		local SYSLIBS=(
			absl_py
			astor_archive
			boringssl
			com_github_googleapis_googleapis
			com_github_googlecloudplatform_google_cloud_cpp
			com_google_protobuf
			com_googlesource_code_re2
			curl
			cython
			double_conversion
			enum34_archive
			flatbuffers
			functools32_archive
			gast_archive
			gif_archive
			grpc
			hwloc
			icu
			jpeg
			jsoncpp_git
			keras_applications_archive
			lmdb
			nasm
			nsync
			opt_einsum_archive
			org_sqlite
			pasta
			pcre
			png_archive
			six_archive
			snappy
			swig
			termcolor_archive
			wrapt
			zlib_archive
		)

		export TF_SYSTEM_LIBS="${SYSLIBS[@]}"
		export TF_IGNORE_MAX_BAZEL_VERSION=1

		# This is not autoconf
		./configure || die

		echo 'build --config=noaws --config=nohdfs --config=noignite --config=nokafka' >> .bazelrc || die
		echo 'build --define tensorflow_mkldnn_contraction_kernel=0' >> .bazelrc || die
		echo 'build --incompatible_no_support_tools_in_action_inputs=false' >> .bazelrc || die
	}
	if use python; then
		python_foreach_impl run_in_build_dir do_configure
	else
		do_configure
	fi
}

src_compile() {
	export JAVA_HOME=$(java-config --jre-home) # so keepwork works

	if use python; then
		python_setup
		BUILD_DIR="${S}-${EPYTHON/./_}"
		cd "${BUILD_DIR}"
	fi

	# fail early if any deps are missing
	ebazel build --nobuild \
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
	local i j
	export JAVA_HOME=$(java-config --jre-home) # so keepwork works

	do_install() {
		einfo "Installing ${EPYTHON} files"
		local srcdir="${T}/src-${MULTIBUILD_VARIANT}"
		mkdir -p "${srcdir}" || die
		bazel-bin/tensorflow/tools/pip_package/build_pip_package --src "${srcdir}" || die
		cd "${srcdir}" || die
		esetup.py install

		# libtensorflow_framework.so is in /usr/lib already
		python_export PYTHON_SITEDIR PYTHON_SCRIPTDIR
		rm -f "${D}/${PYTHON_SITEDIR}"/${PN}/lib${PN}_framework.so* || die
		rm -f "${D}/${PYTHON_SITEDIR}"/${PN}_core/lib${PN}_framework.so* || die
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
	doins -r bazel-genfiles/tensorflow/include/*

	einfo "Installing libs"
	# Generate pkg-config file
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
