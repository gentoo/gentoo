# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DISTUTILS_OPTIONAL=1
PYTHON_COMPAT=( python2_7 python3_{5,6} )
MY_PV=${PV/_rc/-rc}
MY_P=${PN}-${MY_PV}

inherit check-reqs cuda distutils-r1 eapi7-ver multiprocessing toolchain-funcs

DESCRIPTION="Computation framework using data flow graphs for scalable machine learning"
HOMEPAGE="https://www.tensorflow.org/"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="cuda jemalloc mpi +python +system-libs"
CPU_USE_FLAGS_X86="sse sse2 sse3 sse4_1 sse4_2 avx avx2 fma3 fma4"
for i in $CPU_USE_FLAGS_X86; do
	IUSE+=" cpu_flags_x86_$i"
done

# distfiles that bazel uses for the workspace, will be copied to basel-distdir
bazel_external_uris="
	http://www.kurims.kyoto-u.ac.jp/~ooura/fft.tgz -> oourafft-20061228.tgz
	https://bitbucket.org/eigen/eigen/get/fd6845384b86.tar.gz -> eigen-fd6845384b86.tar.gz
	https://github.com/abseil/abseil-cpp/archive/9613678332c976568272c8f4a78631a29159271d.tar.gz -> abseil-cpp-9613678332c976568272c8f4a78631a29159271d.tar.gz
	https://github.com/bazelbuild/rules_closure/archive/dbb96841cc0a5fb2664c37822803b06dab20c7d1.tar.gz -> bazelbuild-rules_closure-dbb96841cc0a5fb2664c37822803b06dab20c7d1.tar.gz
	https://github.com/google/double-conversion/archive/3992066a95b823efc8ccc1baf82a1cfc73f6e9b8.zip -> double-conversion-3992066a95b823efc8ccc1baf82a1cfc73f6e9b8.zip
	https://github.com/google/farmhash/archive/816a4ae622e964763ca0862d9dbd19324a1eaf45.tar.gz -> farmhash-816a4ae622e964763ca0862d9dbd19324a1eaf45.tar.gz
	https://github.com/google/gemmlowp/archive/38ebac7b059e84692f53e5938f97a9943c120d98.zip -> gemmlowp-38ebac7b059e84692f53e5938f97a9943c120d98.zip
	https://github.com/google/highwayhash/archive/fd3d9af80465e4383162e4a7c5e2f406e82dd968.tar.gz -> highwayhash-fd3d9af80465e4383162e4a7c5e2f406e82dd968.tar.gz
	https://github.com/google/protobuf/archive/v3.6.0.tar.gz -> protobuf-3.6.0.tar.gz
	jemalloc? ( https://github.com/jemalloc/jemalloc/archive/4.4.0.tar.gz -> jemalloc-4.4.0.tar.gz )
	cuda? (
		https://github.com/nvidia/nccl/archive/03d856977ecbaac87e598c0c4bafca96761b9ac7.tar.gz -> nvidia-nccl-03d856977ecbaac87e598c0c4bafca96761b9ac7.tar.gz
		https://github.com/NVlabs/cub/archive/1.8.0.zip -> cub-1.8.0.zip
	)
	python? (
		https://github.com/abseil/abseil-py/archive/pypi-v0.2.2.tar.gz -> abseil-py-0.2.2.tar.gz
		https://github.com/googleapis/googleapis/archive/f81082ea1e2f85c43649bee26e0d9871d4b41cdb.zip -> googleapis-f81082ea1e2f85c43649bee26e0d9871d4b41cdb.zip
		https://github.com/GoogleCloudPlatform/google-cloud-cpp/archive/f875700a023bdd706333cde45aee8758b272c357.tar.gz -> google-cloud-cpp-f875700a023bdd706333cde45aee8758b272c357.tar.gz
		https://github.com/google/boringssl/archive/a0fb951d2a26a8ee746b52f3ba81ab011a0af778.tar.gz -> boringssl-a0fb951d2a26a8ee746b52f3ba81ab011a0af778.tar.gz
		https://github.com/intel/ARM_NEON_2_x86_SSE/archive/0f77d9d182265259b135dad949230ecbf1a2633d.tar.gz -> ARM_NEON_2_x86_SSE-0f77d9d182265259b135dad949230ecbf1a2633d.tar.gz
		https://github.com/llvm-mirror/llvm/archive/bd8c8d759852871609ba2e4e79868420f751949d.tar.gz -> llvm-bd8c8d759852871609ba2e4e79868420f751949d.tar.gz
		https://mirror.bazel.build/docs.python.org/2.7/_sources/license.txt -> tensorflow-python-license.txt
		https://pypi.python.org/packages/5c/78/ff794fcae2ce8aa6323e789d1f8b3b7765f601e7702726f430e814822b96/gast-0.2.0.tar.gz
		https://pypi.python.org/packages/bc/cc/3cdb0a02e7e96f6c70bd971bc8a90b8463fda83e264fa9c5c1c98ceabd81/backports.weakref-1.0rc1.tar.gz
		!system-libs? (
			https://github.com/google/flatbuffers/archive/v1.9.0.tar.gz -> flatbuffers-1.9.0.tar.gz
		)
	)
	!system-libs? (
		https://github.com/google/nsync/archive/1.20.1.tar.gz -> nsync-1.20.1.tar.gz
		https://github.com/grpc/grpc/archive/v1.13.0.tar.gz -> grpc-1.13.0.tar.gz
	)"

SRC_URI="https://github.com/${PN}/${PN}/archive/v${MY_PV}.tar.gz -> ${P}.tar.gz
		https://dev.gentoo.org/~perfinion/patches/tensorflow-patches-${PVR}.tar.bz2
		${bazel_external_uris}"

RDEPEND="
	app-arch/snappy
	dev-db/lmdb
	dev-db/sqlite
	>=dev-libs/jsoncpp-1.8.4
	dev-libs/libpcre
	>=dev-libs/protobuf-3.6.0
	>=dev-libs/re2-0.2018.04.01
	media-libs/giflib
	media-libs/libjpeg-turbo
	media-libs/libpng:0
	net-misc/curl
	sys-libs/zlib
	cuda? (
		>=dev-util/nvidia-cuda-toolkit-8.0[profiler]
		>=dev-libs/cudnn-6.0
	)
	jemalloc? ( >=dev-libs/jemalloc-4.4.0 )
	mpi? ( virtual/mpi )
	python? (
		${PYTHON_DEPS}
		dev-python/absl-py[${PYTHON_USEDEP}]
		dev-python/astor[${PYTHON_USEDEP}]
		dev-python/numpy[${PYTHON_USEDEP}]
		>=dev-python/protobuf-python-3.6.0[${PYTHON_USEDEP}]
		dev-python/six[${PYTHON_USEDEP}]
		dev-python/termcolor[${PYTHON_USEDEP}]
		virtual/python-enum34[${PYTHON_USEDEP}]
		system-libs? (
			>=dev-libs/flatbuffers-1.8.0
		)
	)
	system-libs? (
		dev-libs/nsync
		>=net-libs/grpc-1.13.0[${PYTHON_USEDEP}]
	)"
DEPEND="${RDEPEND}
	!python? ( dev-lang/python )
	app-arch/unzip
	>=dev-util/bazel-0.16.0
	dev-java/java-config
	dev-python/mock
	dev-lang/nasm
	dev-lang/swig
	dev-python/cython"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

S="${WORKDIR}/${MY_P}"

DOCS=( AUTHORS CONTRIBUTING.md ISSUE_TEMPLATE.md README.md RELEASE.md )
CHECKREQS_MEMORY="5G"
CHECKREQS_DISK_BUILD="5G"

bazel-get-cpu-flags() {
	local i f=()
	# Keep this list in sync with tensorflow/core/platform/cpu_feature_guard.cc.
	for i in sse sse2 sse3 sse4_1 sse4_2 avx avx2 fma4; do
		use cpu_flags_x86_${i} && f+=( -m${i/_/.} )
	done
	use cpu_flags_x86_fma3 && f+=( -mfma )
	echo "${f[*]}"
}

bazel-get-flags() {
	local i fs=()
	for i in ${CFLAGS} $(bazel-get-cpu-flags); do
		fs+=( "--copt=${i}" "--host_copt=${i}" )
	done
	for i in ${CXXFLAGS} $(bazel-get-cpu-flags); do
		fs+=( "--cxxopt=${i}" "--host_cxxopt=${i}" )
	done
	for i in ${CPPFLAGS}; do
		fs+=( "--copt=${i}" "--host_copt=${i}" )
		fs+=( "--cxxopt=${i}" "--host_cxxopt=${i}" )
	done
	for i in ${LDFLAGS}; do
		fs+=( "--linkopt=${i}" "--host_linkopt=${i}" )
	done
	echo "${fs[*]}"
}

setup_bazelrc() {
	if [[ -f "${T}/bazelrc" ]]; then
		return
	fi

	# F: fopen_wr
	# P: /proc/self/setgroups
	# Even with standalone enabled, the Bazel sandbox binary is run for feature test:
	# https://github.com/bazelbuild/bazel/blob/7b091c1397a82258e26ab5336df6c8dae1d97384/src/main/java/com/google/devtools/build/lib/sandbox/LinuxSandboxedSpawnRunner.java#L61
	# https://github.com/bazelbuild/bazel/blob/76555482873ffcf1d32fb40106f89231b37f850a/src/main/tools/linux-sandbox-pid1.cc#L113
	addpredict /proc

	mkdir -p "${T}/bazel-cache" || die
	mkdir -p "${T}/bazel-distdir" || die

	cat > "${T}/bazelrc" <<-EOF || die
	startup --batch

	# dont strip HOME, portage sets a temp per-package dir
	build --action_env HOME

	# make bazel respect MAKEOPTS
	build --jobs=$(makeopts_jobs) $(bazel-get-flags)
	build --compilation_mode=opt --host_compilation_mode=opt

	# Use standalone strategy to deactivate the bazel sandbox, since it
	# conflicts with FEATURES=sandbox.
	build --spawn_strategy=standalone --genrule_strategy=standalone
	test --spawn_strategy=standalone --genrule_strategy=standalone

	build --strip=never
	build --verbose_failures --noshow_loading_progress
	test --verbose_test_summary --verbose_failures --noshow_loading_progress

	# make bazel only fetch distfiles from the cache
	fetch --repository_cache=${T}/bazel-cache/ --distdir=${T}/bazel-distdir/
	build --repository_cache=${T}/bazel-cache/ --distdir=${T}/bazel-distdir/
	EOF
}

ebazel() {
	# Use different build folders for each multibuild variant.
	local base_suffix="${MULTIBUILD_VARIANT+-}${MULTIBUILD_VARIANT}"
	local output_base="${WORKDIR}/bazel-base${base_suffix}"
	mkdir -p "${output_base}" || die

	einfo Running: bazel --output_base="${output_base}" "$@"
	bazel --output_base="${output_base}" $@ || die
}

load_distfiles() {
	# Populate the bazel distdir to fetch from since it cannot use the network
	# Bazel looks in distdir but will only look for the original filename, not
	# the possibly renamed one that portage downloaded. If the line has -> we
	# need to rename it back, otherwise a simple copy is fine.

	local src dst uri rename

	while read uri rename dst; do
		src="${uri##*/}"
		[[ -z $src ]] && continue
		if [[ "$rename" != "->" ]]; then
			dst="${src}"
		fi

		[[ ${A} =~ ${dst} ]] || continue

		if [[ "$dst" == "$src" ]]; then
			einfo "Copying $dst to bazel distdir $src ..."
		else
			einfo "Copying $dst to bazel distdir ..."
		fi
		ln -s "${DISTDIR}/${dst}" "${T}/bazel-distdir/${src}" || die
	done <<< "$(sed -re 's/!?[A-Za-z]+\?\s+\(\s*//g; s/\s+\)//g' <<< "${bazel_external_uris}")"
}

pkg_setup() {
	check-reqs_pkg_setup
}

src_unpack() {
	# Only unpack the main distfile
	unpack "${P}.tar.gz"
	unpack tensorflow-patches-${PVR}.tar.bz2
}

src_prepare() {
	export JAVA_HOME=$(java-config --jre-home) # so keepwork works

	setup_bazelrc
	load_distfiles

	eapply "${WORKDIR}"/patches/*.patch

	default
	use python && python_copy_sources

	if use cuda; then
		for i in /dev/nvidia*; do
			addpredict $i
		done
	fi
}

src_configure() {
	export JAVA_HOME=$(java-config --jre-home) # so keepwork works

	do_configure() {
		export BAZEL_STRIP=0
		export CC_OPT_FLAGS=" "
		export TF_NEED_JEMALLOC=$(usex jemalloc 1 0)
		export TF_NEED_GCP=0
		export TF_NEED_HDFS=0
		export TF_NEED_S3=0
		export TF_NEED_AWS=0
		export TF_NEED_KAFKA=0
		export TF_ENABLE_XLA=0
		export TF_NEED_GDR=0
		export TF_NEED_VERBS=0
		export TF_NEED_OPENCL_SYCL=0
		export TF_NEED_OPENCL=0
		export TF_NEED_COMPUTECPP=0
		export TF_NEED_MKL=0
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

			TF_CUDA_VERSION="$(best_version dev-util/nvidia-cuda-toolkit)"
			TF_CUDA_VERSION="${TF_CUDA_VERSION##*cuda-toolkit-}"
			export TF_CUDA_VERSION="$(ver_cut 1-2 ${TF_CUDA_VERSION})"
			einfo "Setting CUDA version: $TF_CUDA_VERSION"

			TF_CUDNN_VERSION="$(best_version dev-libs/cudnn)"
			TF_CUDNN_VERSION="${TF_CUDNN_VERSION##*cudnn-}"
			export TF_CUDNN_VERSION="$(ver_cut 1-2 ${TF_CUDNN_VERSION})"
			einfo "Setting CUDNN version: $TF_CUDNN_VERSION"
		fi

		local SYSLIBS=(
			astor_archive
			com_googlesource_code_re2
			curl
			cython
			gif_archive
			jemalloc
			jpeg
			jsoncpp_git
			lmdb
			nasm
			org_sqlite
			pcre
			png_archive
			six_archive
			snappy
			swig
			termcolor_archive
			zlib_archive
		)
		if use system-libs; then
			SYSLIBS+=( flatbuffers grpc nsync )
		fi

		SYSLIBS="${SYSLIBS[@]}"
		export TF_SYSTEM_LIBS="${SYSLIBS// /,}"

		# Only one bazelrc is read, import our one before configure sets its options
		echo "import ${T}/bazelrc" >> ./.bazelrc

		# This is not autoconf
		./configure || die
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
		local MULTIBUILD_VARIANT="${EPYTHON/./_}"
		cd "${S}-${MULTIBUILD_VARIANT}" || die
	fi

	ebazel build \
		//tensorflow:libtensorflow_framework.so \
		//tensorflow:libtensorflow.so
	ebazel build //tensorflow:libtensorflow_cc.so

	do_compile() {
		ebazel build //tensorflow/tools/pip_package:build_pip_package
	}
	use python && python_foreach_impl run_in_build_dir do_compile
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

		# Symlink to the main .so file
		python_export PYTHON_SITEDIR
		rm -rf "${D}/${PYTHON_SITEDIR}/${PN}/lib${PN}_framework.so" || die
		dosym "../../../lib${PN}_framework.so" "${PYTHON_SITEDIR#${EPREFIX%/}}/${PN}/lib${PN}_framework.so" || die

		python_optimize
	}

	if use python; then
		python_foreach_impl run_in_build_dir do_install

		rm -f "${ED}"/usr/lib/python-exec/*/tensorboard || die "failed to remove tensorboard"

		# Symlink to python-exec scripts
		for i in "${ED}"/usr/lib/python-exec/*/*; do
			n="${i##*/}"
			[[ -e "${ED}/usr/bin/${n}" ]] || dosym ../lib/python-exec/python-exec2 "/usr/bin/$n"
		done

		python_setup
		local MULTIBUILD_VARIANT="${EPYTHON/./_}"
		cd "${S}-${MULTIBUILD_VARIANT}" || die
	fi

	einfo "Installing headers"
	# Install c c++ and core header files
	for i in $(find ${PN}/{c,cc,core} -name "*.h"); do
		insinto /usr/include/${PN}/${i%/*}
		doins ${i}
	done

	einfo "Installing generated headers"
	for i in $(find bazel-genfiles/${PN}/{cc,core} -name "*.h"); do
		j=${i#bazel-genfiles/}
		insinto /usr/include/${PN}/${j%/*}
		doins ${i}
	done

	einfo "Installing Eigen headers"
	ebazel build //third_party/eigen3:install_eigen_headers
	insinto /usr/include/${PN}/
	doins -r bazel-genfiles/third_party/eigen3/include/*

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
