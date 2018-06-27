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
IUSE="cuda jemalloc mpi +python system-libs"
CPU_USE_FLAGS_X86="sse sse2 sse3 sse4_1 sse4_2 avx avx2 fma3 fma4"
for i in $CPU_USE_FLAGS_X86; do
	IUSE+=" cpu_flags_x86_$i"
done

# distfiles that bazel uses for the workspace, will be copied to basel-distdir
bazel_external_uris="
	http://www.kurims.kyoto-u.ac.jp/~ooura/fft.tgz -> oourafft-20061228.tgz
	https://bitbucket.org/eigen/eigen/get/6913f0cf7d06.tar.gz -> eigen-6913f0cf7d06.tar.gz
	https://github.com/abseil/abseil-cpp/archive/9613678332c976568272c8f4a78631a29159271d.tar.gz -> abseil-cpp-9613678332c976568272c8f4a78631a29159271d.tar.gz
	https://github.com/bazelbuild/rules_closure/archive/dbb96841cc0a5fb2664c37822803b06dab20c7d1.tar.gz -> bazelbuild-rules_closure-dbb96841cc0a5fb2664c37822803b06dab20c7d1.tar.gz
	https://github.com/google/double-conversion/archive/3992066a95b823efc8ccc1baf82a1cfc73f6e9b8.zip -> double-conversion-3992066a95b823efc8ccc1baf82a1cfc73f6e9b8.zip
	https://github.com/google/farmhash/archive/816a4ae622e964763ca0862d9dbd19324a1eaf45.tar.gz -> farmhash-816a4ae622e964763ca0862d9dbd19324a1eaf45.tar.gz
	https://github.com/google/gemmlowp/archive/38ebac7b059e84692f53e5938f97a9943c120d98.zip -> gemmlowp-38ebac7b059e84692f53e5938f97a9943c120d98.zip
	https://github.com/google/highwayhash/archive/fd3d9af80465e4383162e4a7c5e2f406e82dd968.tar.gz -> highwayhash-fd3d9af80465e4383162e4a7c5e2f406e82dd968.tar.gz
	https://github.com/google/nsync/archive/0559ce013feac8db639ee1bf776aca0325d28777.tar.gz -> nsync-0559ce013feac8db639ee1bf776aca0325d28777.tar.gz
	https://github.com/google/protobuf/archive/396336eb961b75f03b25824fe86cf6490fb75e3a.tar.gz -> protobuf-396336eb961b75f03b25824fe86cf6490fb75e3a.tar.gz
	https://github.com/open-source-parsers/jsoncpp/archive/11086dd6a7eba04289944367ca82cea71299ed70.tar.gz -> jsoncpp-11086dd6a7eba04289944367ca82cea71299ed70.tar.gz
	https://github.com/jemalloc/jemalloc/archive/4.4.0.tar.gz -> jemalloc-4.4.0.tar.gz
	cuda? ( https://github.com/nvidia/nccl/archive/03d856977ecbaac87e598c0c4bafca96761b9ac7.tar.gz -> nvidia-nccl-03d856977ecbaac87e598c0c4bafca96761b9ac7.tar.gz )
	python? (
		https://github.com/NVlabs/cub/archive/1.8.0.zip -> cub-1.8.0.zip
		https://github.com/abseil/abseil-py/archive/ea8c4d2ddbf3fba610c4d613260561699b776db8.tar.gz -> abseil-py-ea8c4d2ddbf3fba610c4d613260561699b776db8.tar.gz
		https://github.com/aws/aws-sdk-cpp/archive/1.3.15.tar.gz -> aws_sdk_cpp-1.3.15.tar.gz
		https://github.com/edenhill/librdkafka/archive/v0.11.1.tar.gz -> librdkafka-v0.11.1.tar.gz
		https://github.com/google/boringssl/archive/a0fb951d2a26a8ee746b52f3ba81ab011a0af778.tar.gz -> boringssl-a0fb951d2a26a8ee746b52f3ba81ab011a0af778.tar.gz
		https://github.com/hfp/libxsmm/archive/1.8.1.tar.gz -> libxsmm-1.8.1.tar.gz
		https://github.com/intel/ARM_NEON_2_x86_SSE/archive/0f77d9d182265259b135dad949230ecbf1a2633d.tar.gz -> ARM_NEON_2_x86_SSE-0f77d9d182265259b135dad949230ecbf1a2633d.tar.gz
		https://github.com/intel/mkl-dnn/archive/v0.12.tar.gz -> mkl_dnn-v0.12.tar.gz
		https://github.com/llvm-mirror/llvm/archive/7e78daafdd22f3f17720a103d29d89590534004e.tar.gz -> llvm-7e78daafdd22f3f17720a103d29d89590534004e.tar.gz
		https://mirror.bazel.build/docs.python.org/2.7/_sources/license.txt -> tensorflow-python-license.txt
		https://pypi.python.org/packages/5c/78/ff794fcae2ce8aa6323e789d1f8b3b7765f601e7702726f430e814822b96/gast-0.2.0.tar.gz
		https://pypi.python.org/packages/bc/cc/3cdb0a02e7e96f6c70bd971bc8a90b8463fda83e264fa9c5c1c98ceabd81/backports.weakref-1.0rc1.tar.gz
		!system-libs? (
			http://ftp.exim.org/pub/pcre/pcre-8.39.tar.gz
			http://ufpr.dl.sourceforge.net/project/swig/swig/swig-3.0.8/swig-3.0.8.tar.gz
			https://curl.haxx.se/download/curl-7.49.1.tar.gz
			https://pypi.python.org/packages/8a/48/a76be51647d0eb9f10e2a4511bf3ffb8cc1e6b14e9e4fab46173aa79f981/termcolor-1.1.0.tar.gz
			https://pypi.python.org/packages/d8/be/c4276b3199ec3feee2a88bc64810fbea8f26d961e0a4cd9c68387a9f35de/astor-0.6.2.tar.gz
			https://pypi.python.org/packages/source/s/six/six-1.10.0.tar.gz
			https://github.com/google/flatbuffers/archive/971a68110e4fc1bace10fcb6deeb189e7e1a34ce.tar.gz -> flatbuffers-971a68110e4fc1bace10fcb6deeb189e7e1a34ce.tar.gz
			https://github.com/cython/cython/archive/3732784c45cfb040a5b0936951d196f83a12ea17.tar.gz -> cython-3732784c45cfb040a5b0936951d196f83a12ea17.tar.gz
		)
	)
	!system-libs? (
		http://pilotfiber.dl.sourceforge.net/project/giflib/giflib-5.1.4.tar.gz
		http://pkgs.fedoraproject.org/repo/pkgs/nasm/nasm-2.12.02.tar.bz2/d15843c3fb7db39af80571ee27ec6fad/nasm-2.12.02.tar.bz2
		https://github.com/LMDB/lmdb/archive/LMDB_0.9.19.tar.gz
		https://github.com/glennrp/libpng/archive/v1.6.34.tar.gz -> libpng-v1.6.34.tar.gz
		https://github.com/google/re2/archive/26cd968b735e227361c9703683266f01e5df7857.tar.gz -> re2-26cd968b735e227361c9703683266f01e5df7857.tar.gz
		https://github.com/google/snappy/archive/1.1.7.tar.gz -> snappy-1.1.7.tar.gz
		https://github.com/grpc/grpc/archive/d184fa229d75d336aedea0041bd59cb93e7e267f.tar.gz -> grpc-d184fa229d75d336aedea0041bd59cb93e7e267f.tar.gz
		https://github.com/libjpeg-turbo/libjpeg-turbo/archive/1.5.3.tar.gz -> libjpeg_turbo-1.5.3.tar.gz
		https://www.sqlite.org/2018/sqlite-amalgamation-3230100.zip
		https://zlib.net/zlib-1.2.11.tar.gz
	)"

SRC_URI="https://github.com/${PN}/${PN}/archive/v${MY_PV}.tar.gz -> ${P}.tar.gz
		https://dev.gentoo.org/~perfinion/patches/tensorflow-patches-${PVR}.tar.bz2
		${bazel_external_uris}"

RDEPEND="
	cuda? (
		>=dev-util/nvidia-cuda-toolkit-9.0[profiler]
		>=dev-libs/cudnn-6.0
	)
	mpi? ( virtual/mpi )
	system-libs? (
		app-arch/snappy
		dev-db/lmdb
		dev-db/sqlite
		>=dev-libs/flatbuffers-1.8.0
		>=dev-libs/jsoncpp-1.8.4
		dev-libs/libpcre
		dev-libs/protobuf
		dev-libs/protobuf-c
		>=dev-libs/re2-0.2018.04.01
		media-libs/giflib
		media-libs/libjpeg-turbo
		media-libs/libpng:0
		>=net-libs/grpc-1.12.1[${PYTHON_USEDEP}]
		net-misc/curl
		sys-libs/zlib
		jemalloc? ( >=dev-libs/jemalloc-4.4.0 )
		python? (
			${PYTHON_DEPS}
			dev-python/absl-py[${PYTHON_USEDEP}]
			dev-python/astor[${PYTHON_USEDEP}]
			dev-python/numpy[${PYTHON_USEDEP}]
			dev-python/protobuf-python[${PYTHON_USEDEP}]
			dev-python/six[${PYTHON_USEDEP}]
			dev-python/termcolor[${PYTHON_USEDEP}]
		)
	)"
DEPEND="${RDEPEND}
	!python? ( dev-lang/python )
	app-arch/unzip
	>=dev-util/bazel-0.14.0
	dev-java/java-config
	dev-python/mock
	system-libs? (
		dev-lang/nasm
		dev-lang/swig
		dev-python/cython
	)"
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

	cat > "${T}/bazelrc" <<-EOF
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
	fetch --repository_cache=${T}/bazel-cache/ --experimental_distdir=${T}/bazel-distdir/
	build --repository_cache=${T}/bazel-cache/ --experimental_distdir=${T}/bazel-distdir/
	EOF
}

ebazel() {
	setup_bazelrc

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
		cp "${DISTDIR}/${dst}" "${T}/bazel-distdir/${src}" || die
	done <<< "$(sed -re 's/!?[A-Za-z]+\?\s+\(\s*//g; s/\s+\)//g' <<< "${bazel_external_uris}")"
}

pkg_setup() {
	export JAVA_HOME=$(java-config --jre-home)
	check-reqs_pkg_setup
}

src_unpack() {
	# Only unpack the main distfile
	unpack "${P}.tar.gz"
	unpack tensorflow-patches-${PVR}.tar.bz2
}

src_prepare() {
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
	do_configure() {
		export CC_OPT_FLAGS=""
		export TF_NEED_JEMALLOC=$(usex jemalloc 1 0)
		export TF_NEED_GCP=0
		export TF_NEED_HDFS=0
		export TF_NEED_S3=0
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
			export CUDA_TOOLKIT_PATH="${EROOT%/}/opt/cuda"
			export CUDNN_INSTALL_PATH="${EROOT%/}/opt/cuda"
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

		# Only one bazelrc is read, import our one before configure sets its options
		echo "import ${T}/bazelrc" >> ./.bazelrc

		# This is not autoconf
		./configure || die

		sed -i '/strip=always/d' .tf_configure.bazelrc || die

		if use system-libs; then
			echo 'build --action_env TF_SYSTEM_LIBS="com_googlesource_code_re2,nasm,jpeg,png_archive,org_sqlite,gif_archive,six_archive,astor_archive,termcolor_archive,pcre,swig,curl,grpc,lmdb,zlib_archive,snappy,flatbuffers,cython,jemalloc"' >> .tf_configure.bazelrc || die
		fi
	}
	if use python; then
		python_foreach_impl run_in_build_dir do_configure
	else
		do_configure
	fi
}

src_compile() {
	if use python; then
		python_setup
		local MULTIBUILD_VARIANT="${EPYTHON/./_}"
		cd "${S}-${MULTIBUILD_VARIANT}" || die
	fi

	ebazel build \
		//tensorflow:libtensorflow_framework.so \
		//tensorflow:libtensorflow.so \
		//tensorflow:libtensorflow_cc.so

	do_compile() {
		ebazel build //tensorflow/tools/pip_package:build_pip_package
	}
	use python && python_foreach_impl run_in_build_dir do_compile
}

src_install() {
	local i j
	do_install() {
		einfo "Installing ${EPYTHON} files"
		local srcdir="${T}/src-${MULTIBUILD_VARIANT}"
		mkdir -p "${srcdir}" || die
		bazel-bin/tensorflow/tools/pip_package/build_pip_package --src "${srcdir}" || die
		cd "${srcdir}" || die
		esetup.py install

		# Symlink to the main .so file
		rm -rf "${D}/${PYTHON_SITEDIR}/${PN}/lib${PN}_framework.so" || die
		dosym "../../../lib${PN}_framework.so" "${PYTHON_SITEDIR}/${PN}/lib${PN}_framework.so" || die

		python_optimize
	}

	if use python; then
		python_foreach_impl run_in_build_dir do_install

		# Symlink to python-exec scripts
		for i in "${D}"/usr/lib/python-exec/*/*; do
			n="${i##*/}"
			[[ -e "${D}/usr/bin/${n}" ]] || dosym ../lib/python-exec/python-exec2 "/usr/bin/$n"
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
	${PN}/c/generate-pc.sh --prefix=/usr --libdir=$(get_libdir) --version=${MY_PV} || die
	insinto /usr/$(get_libdir)/pkgconfig
	doins ${PN}.pc

	dolib.so bazel-bin/tensorflow/lib${PN}_framework.so
	dolib.so bazel-bin/tensorflow/lib${PN}.so
	dolib.so bazel-bin/tensorflow/lib${PN}_cc.so

	einstalldocs
}
