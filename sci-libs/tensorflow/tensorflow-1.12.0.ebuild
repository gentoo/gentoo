# Copyright 1999-2018 Jason Zaman
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_OPTIONAL=1
PYTHON_COMPAT=( python2_7 python{3_5,3_6} )
MY_PV=${PV/_rc/-rc}
MY_P=${PN}-${MY_PV}

inherit bazel check-reqs cuda distutils-r1 flag-o-matic toolchain-funcs

DESCRIPTION="Computation framework using data flow graphs for scalable machine learning"
HOMEPAGE="https://www.tensorflow.org/"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="cuda mpi +python"
CPU_USE_FLAGS_X86="sse sse2 sse3 sse4_1 sse4_2 avx avx2 fma3 fma4"
for i in $CPU_USE_FLAGS_X86; do
	IUSE+=" cpu_flags_x86_$i"
done

# distfiles that bazel uses for the workspace, will be copied to basel-distdir
bazel_external_uris="
	http://www.kurims.kyoto-u.ac.jp/~ooura/fft.tgz -> oourafft-20061228.tgz
	https://bitbucket.org/eigen/eigen/get/fd6845384b86.tar.gz -> eigen-fd6845384b86.tar.gz
	https://github.com/abseil/abseil-cpp/archive/48cd2c3f351ff188bc85684b84a91b6e6d17d896.tar.gz -> abseil-cpp-48cd2c3f351ff188bc85684b84a91b6e6d17d896.tar.gz
	https://github.com/bazelbuild/rules_closure/archive/dbb96841cc0a5fb2664c37822803b06dab20c7d1.tar.gz -> bazelbuild-rules_closure-dbb96841cc0a5fb2664c37822803b06dab20c7d1.tar.gz
	https://github.com/google/double-conversion/archive/3992066a95b823efc8ccc1baf82a1cfc73f6e9b8.zip -> double-conversion-3992066a95b823efc8ccc1baf82a1cfc73f6e9b8.zip
	https://github.com/google/farmhash/archive/816a4ae622e964763ca0862d9dbd19324a1eaf45.tar.gz -> farmhash-816a4ae622e964763ca0862d9dbd19324a1eaf45.tar.gz
	https://github.com/google/gemmlowp/archive/38ebac7b059e84692f53e5938f97a9943c120d98.zip -> gemmlowp-38ebac7b059e84692f53e5938f97a9943c120d98.zip
	https://github.com/google/highwayhash/archive/fd3d9af80465e4383162e4a7c5e2f406e82dd968.tar.gz -> highwayhash-fd3d9af80465e4383162e4a7c5e2f406e82dd968.tar.gz
	cuda? (
		https://github.com/nvidia/nccl/archive/03d856977ecbaac87e598c0c4bafca96761b9ac7.tar.gz -> nvidia-nccl-03d856977ecbaac87e598c0c4bafca96761b9ac7.tar.gz
		https://github.com/NVlabs/cub/archive/1.8.0.zip -> cub-1.8.0.zip
	)
	python? (
		https://github.com/intel/ARM_NEON_2_x86_SSE/archive/0f77d9d182265259b135dad949230ecbf1a2633d.tar.gz -> ARM_NEON_2_x86_SSE-0f77d9d182265259b135dad949230ecbf1a2633d.tar.gz
		https://mirror.bazel.build/docs.python.org/2.7/_sources/license.txt -> tensorflow-python-license.txt
		https://pypi.python.org/packages/bc/cc/3cdb0a02e7e96f6c70bd971bc8a90b8463fda83e264fa9c5c1c98ceabd81/backports.weakref-1.0rc1.tar.gz
	)"

SRC_URI="https://github.com/${PN}/${PN}/archive/v${MY_PV}.tar.gz -> ${P}.tar.gz
		https://dev.gentoo.org/~perfinion/patches/tensorflow-patches-${PV}.tar.bz2
		${bazel_external_uris}"

RDEPEND="
	app-arch/snappy
	dev-db/lmdb
	dev-db/sqlite
	dev-libs/icu
	>=dev-libs/jsoncpp-1.8.4
	dev-libs/libpcre
	dev-libs/nsync
	dev-libs/openssl:0
	>=dev-libs/protobuf-3.6.0
	>=dev-libs/re2-0.2018.04.01
	media-libs/giflib
	media-libs/libjpeg-turbo
	media-libs/libpng:0
	>=net-libs/grpc-1.16.0
	net-misc/curl
	sys-libs/zlib
	cuda? (
		>=dev-util/nvidia-cuda-toolkit-8.0[profiler]
		>=dev-libs/cudnn-6.0
	)
	mpi? ( virtual/mpi )
	python? (
		${PYTHON_DEPS}
		>=dev-libs/flatbuffers-1.8.0
		dev-python/absl-py[${PYTHON_USEDEP}]
		dev-python/astor[${PYTHON_USEDEP}]
		dev-python/gast[${PYTHON_USEDEP}]
		dev-python/numpy[${PYTHON_USEDEP}]
		>=dev-python/protobuf-python-3.6.0[${PYTHON_USEDEP}]
		dev-python/six[${PYTHON_USEDEP}]
		dev-python/termcolor[${PYTHON_USEDEP}]
		dev-python/grpcio[${PYTHON_USEDEP}]
		net-libs/google-cloud-cpp
		>=sci-libs/keras-applications-1.0.6[${PYTHON_USEDEP}]
		>=sci-libs/keras-preprocessing-1.0.5[${PYTHON_USEDEP}]
		>=sci-visualization/tensorboard-${PV}[${PYTHON_USEDEP}]
		virtual/python-enum34[${PYTHON_USEDEP}]
	)"
DEPEND="${RDEPEND}
	dev-python/mock"
BDEPEND="
	app-arch/unzip
	>=dev-libs/protobuf-3.6.0
	dev-java/java-config
	dev-python/mock
	dev-lang/swig
	dev-python/cython
	cuda? (
		>=dev-util/nvidia-cuda-toolkit-8.0[profiler]
	)
	!python? ( dev-lang/python )
	python? (
		dev-python/grpcio-tools
	)"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

S="${WORKDIR}/${MY_P}"

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

	# for bazel-0.19.0
	echo 'import %workspace%/tools/bazel.rc' >> .bazelrc || die

	append-flags $(get-cpu-flags)
	bazel_setup_bazelrc

	eapply "${WORKDIR}"/patches/*.patch

	default
	use python && python_copy_sources

	use cuda && cuda_add_sandbox
}

src_configure() {
	export JAVA_HOME=$(java-config --jre-home) # so keepwork works

	do_configure() {
		export CC_OPT_FLAGS=" "
		export TF_ENABLE_XLA=0
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
			export CUDA_TOOLKIT_PATH="${EPREFIX%/}/opt/cuda"
			export CUDNN_INSTALL_PATH="${EPREFIX%/}/opt/cuda"
			export GCC_HOST_COMPILER_PATH="$(cuda_gccdir)/$(tc-getCC)"
			export TF_NCCL_VERSION="1"
			export TF_CUDA_VERSION="$(cuda_toolkit_version)"
			export TF_CUDNN_VERSION="$(cuda_cudnn_version)"
			einfo "Setting CUDA version: $TF_CUDA_VERSION"
			einfo "Setting CUDNN version: $TF_CUDNN_VERSION"
		fi

		local SYSLIBS=(
			absl_py
			astor_archive
			boringssl
			com_github_googleapis_googleapis
			com_github_googlecloudplatform_google_cloud_cpp
			com_google_protobuf
			com_google_protobuf_cc
			com_googlesource_code_re2
			curl
			cython
			flatbuffers
			gast_archive
			gif_archive
			grpc
			icu
			jpeg
			jsoncpp_git
			lmdb
			nasm
			nsync
			org_sqlite
			pcre
			png_archive
			protobuf_archive
			six_archive
			snappy
			swig
			termcolor_archive
			zlib_archive
		)

		export TF_SYSTEM_LIBS="${SYSLIBS[@]}"

		# This is not autoconf
		./configure || die

		echo 'build --config=noaws --config=nohdfs --config=noignite --config=nokafka' >> .bazelrc || die
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
		rm -f "${D}/${PYTHON_SITEDIR}/${PN}/lib${PN}_framework.so" || die
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
	doins ${PN}.pc

	dolib.so bazel-bin/tensorflow/lib${PN}_framework.so
	dolib.so bazel-bin/tensorflow/lib${PN}.so
	dolib.so bazel-bin/tensorflow/lib${PN}_cc.so

	einstalldocs
}
