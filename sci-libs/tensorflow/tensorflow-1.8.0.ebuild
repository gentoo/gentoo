# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_{5,6} )
MY_PV=${PV/_rc/-rc}
MY_P=${PN}-${MY_PV}

inherit distutils-r1 multiprocessing toolchain-funcs

DESCRIPTION="Computation framework using data flow graphs for scalable machine learning"
HOMEPAGE="https://www.tensorflow.org/"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="cuda jemalloc mpi"
CPU_USE_FLAGS_X86="sse sse2 sse3 sse4_1 sse4_2 avx avx2 fma3 fma4"
for i in $CPU_USE_FLAGS_X86; do
	IUSE+=" cpu_flags_x86_$i"
done

# distfiles that bazel uses for the workspace, will be copied to basel-distdir
bazel_external_uris="https://github.com/abseil/abseil-py/archive/acec853355ef987eae48a8d87a79351c15dff593.tar.gz -> abseil_py-acec853355ef987eae48a8d87a79351c15dff593.tar.gz
	http://ftp.exim.org/pub/pcre/pcre-8.39.tar.gz
	http://pilotfiber.dl.sourceforge.net/project/giflib/giflib-5.1.4.tar.gz
	http://pkgs.fedoraproject.org/repo/pkgs/nasm/nasm-2.12.02.tar.bz2/d15843c3fb7db39af80571ee27ec6fad/nasm-2.12.02.tar.bz2
	http://ufpr.dl.sourceforge.net/project/swig/swig/swig-3.0.8/swig-3.0.8.tar.gz
	http://www.kurims.kyoto-u.ac.jp/~ooura/fft.tgz
	http://www.sqlite.org/2017/sqlite-amalgamation-3200000.zip
	https://bitbucket.org/eigen/eigen/get/6913f0cf7d06.tar.gz -> eigen-6913f0cf7d06.tar.gz
	https://curl.haxx.se/download/curl-7.49.1.tar.gz
	https://github.com/LMDB/lmdb/archive/LMDB_0.9.19.tar.gz
	https://github.com/NVlabs/cub/archive/1.8.0.zip -> cub-1.8.0.zip
	https://github.com/abseil/abseil-cpp/archive/720c017e30339fd1786ce4aac68bc8559736e53f.tar.gz -> abseil_cpp-720c017e30339fd1786ce4aac68bc8559736e53f.tar.gz
	https://github.com/aws/aws-sdk-cpp/archive/1.3.15.tar.gz -> aws_sdk_cpp-1.3.15.tar.gz
	https://github.com/bazelbuild/rules_closure/archive/08039ba8ca59f64248bb3b6ae016460fe9c9914f.tar.gz
	https://github.com/cython/cython/archive/3732784c45cfb040a5b0936951d196f83a12ea17.tar.gz -> cython-3732784c45cfb040a5b0936951d196f83a12ea17.tar.gz
	https://github.com/edenhill/librdkafka/archive/v0.11.1.tar.gz -> librdkafka-v0.11.1.tar.gz
	https://github.com/glennrp/libpng/archive/v1.6.34.tar.gz -> libpng-v1.6.34.tar.gz
	https://github.com/google/boringssl/archive/a0fb951d2a26a8ee746b52f3ba81ab011a0af778.tar.gz -> boringssl-a0fb951d2a26a8ee746b52f3ba81ab011a0af778.tar.gz
	https://github.com/google/farmhash/archive/816a4ae622e964763ca0862d9dbd19324a1eaf45.tar.gz -> farmhash-816a4ae622e964763ca0862d9dbd19324a1eaf45.tar.gz
	https://github.com/google/flatbuffers/archive/971a68110e4fc1bace10fcb6deeb189e7e1a34ce.tar.gz -> flatbuffers-971a68110e4fc1bace10fcb6deeb189e7e1a34ce.tar.gz
	https://github.com/google/gemmlowp/archive/7c7c744640ddc3d0af18fb245b4d23228813a71b.zip -> gemmlowp-7c7c744640ddc3d0af18fb245b4d23228813a71b.zip
	https://github.com/google/highwayhash/archive/dfcb97ca4fe9277bf9dc1802dd979b071896453b.tar.gz -> highwayhash-dfcb97ca4fe9277bf9dc1802dd979b071896453b.tar.gz
	https://github.com/google/nsync/archive/0559ce013feac8db639ee1bf776aca0325d28777.tar.gz -> nsync-0559ce013feac8db639ee1bf776aca0325d28777.tar.gz
	https://github.com/google/protobuf/archive/396336eb961b75f03b25824fe86cf6490fb75e3a.tar.gz -> protobuf-396336eb961b75f03b25824fe86cf6490fb75e3a.tar.gz
	https://github.com/google/re2/archive/26cd968b735e227361c9703683266f01e5df7857.tar.gz -> re2-26cd968b735e227361c9703683266f01e5df7857.tar.gz
	https://github.com/google/snappy/archive/1.1.7.tar.gz -> snappy-1.1.7.tar.gz
	https://github.com/grpc/grpc/archive/bd6bdf93279a39a8cd92978fd7c9d14eccd98fc2.tar.gz -> grpc-bd6bdf93279a39a8cd92978fd7c9d14eccd98fc2.tar.gz
	https://github.com/hfp/libxsmm/archive/1.8.1.tar.gz -> libxsmm-1.8.1.tar.gz
	https://github.com/intel/ARM_NEON_2_x86_SSE/archive/0f77d9d182265259b135dad949230ecbf1a2633d.tar.gz -> ARM_NEON_2_x86_SSE-0f77d9d182265259b135dad949230ecbf1a2633d.tar.gz
	https://github.com/intel/mkl-dnn/archive/v0.12.tar.gz -> mkl_dnn-v0.12.tar.gz
	https://github.com/jemalloc/jemalloc/archive/4.4.0.tar.gz -> jemalloc-4.4.0.tar.gz
	https://github.com/libjpeg-turbo/libjpeg-turbo/archive/1.5.1.tar.gz -> libjpeg_turbo-1.5.1.tar.gz
	https://github.com/llvm-mirror/llvm/archive/7e78daafdd22f3f17720a103d29d89590534004e.tar.gz -> llvm-7e78daafdd22f3f17720a103d29d89590534004e.tar.gz
	https://github.com/open-source-parsers/jsoncpp/archive/11086dd6a7eba04289944367ca82cea71299ed70.tar.gz -> jsoncpp-11086dd6a7eba04289944367ca82cea71299ed70.tar.gz
	https://mirror.bazel.build/docs.python.org/2.7/_sources/license.txt -> tensorflow-python-license.txt
	https://pypi.python.org/packages/5c/78/ff794fcae2ce8aa6323e789d1f8b3b7765f601e7702726f430e814822b96/gast-0.2.0.tar.gz
	https://pypi.python.org/packages/8a/48/a76be51647d0eb9f10e2a4511bf3ffb8cc1e6b14e9e4fab46173aa79f981/termcolor-1.1.0.tar.gz
	https://pypi.python.org/packages/bc/cc/3cdb0a02e7e96f6c70bd971bc8a90b8463fda83e264fa9c5c1c98ceabd81/backports.weakref-1.0rc1.tar.gz
	https://pypi.python.org/packages/d8/be/c4276b3199ec3feee2a88bc64810fbea8f26d961e0a4cd9c68387a9f35de/astor-0.6.2.tar.gz
	https://pypi.python.org/packages/source/s/six/six-1.10.0.tar.gz
	https://zlib.net/zlib-1.2.11.tar.gz
"

SRC_URI="https://github.com/${PN}/${PN}/archive/v${MY_PV}.tar.gz -> ${P}.tar.gz
		${bazel_external_uris}"

RDEPEND="
	app-arch/snappy
	dev-db/lmdb
	dev-db/sqlite
	dev-libs/libpcre
	dev-libs/protobuf
	dev-libs/protobuf-c
	dev-libs/re2
	dev-python/absl-py[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/protobuf-python[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
	dev-python/termcolor[${PYTHON_USEDEP}]
	media-libs/giflib
	media-libs/libpng:0
	net-libs/grpc[${PYTHON_USEDEP}]
	net-misc/curl
	sys-libs/zlib
	virtual/jpeg:0
	cuda? ( >=dev-util/nvidia-cuda-toolkit-8.0.61[profiler] >=dev-libs/cudnn-6.0 )
	jemalloc? ( >=dev-libs/jemalloc-4.4.0 )
	mpi? ( virtual/mpi )"
DEPEND="${RDEPEND}
	>=dev-util/bazel-0.13.0
	dev-java/java-config
	dev-lang/nasm
	dev-lang/swig"

S="${WORKDIR}/${MY_P}"

DOCS=( AUTHORS CONTRIBUTING.md ISSUE_TEMPLATE.md README.md RELEASE.md )
PATCHES=(
	"${FILESDIR}/0001-pip_package-modularize-build-script-to-allow-distros.patch"
)

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

	echo "startup --batch" > "${T}/bazelrc" || die

	# make bazel respect $MAKEOPTS
	echo "build --jobs=$(makeopts_jobs)" >> "${T}/bazelrc" || die

	# Use standalone strategy to deactivate the bazel sandbox, since it
	# conflicts with FEATURES=sandbox.
	echo "build --verbose_failures --spawn_strategy=standalone --genrule_strategy=standalone" >> "${T}/bazelrc" || die
	echo "build --noshow_loading_progress" >> "${T}/bazelrc" || die
	echo "test --verbose_failures --spawn_strategy=standalone --genrule_strategy=standalone" >> "${T}/bazelrc" || die
	echo "test --verbose_test_summary --noshow_loading_progress" >> "${T}/bazelrc" || die

	# make bazel only fetch distfiles from the cache
	mkdir -p "${T}/bazel-cache" || die
	mkdir -p "${T}/bazel-distdir" || die
	echo "fetch --repository_cache=${T}/bazel-cache/ --experimental_distdir=${T}/bazel-distdir/" >> "${T}/bazelrc" || die
	echo "build --repository_cache=${T}/bazel-cache/ --experimental_distdir=${T}/bazel-distdir/" >> "${T}/bazelrc" || die
}

bazel_multibuild_wrapper() {
	BAZEL_OUTPUT_BASE="${WORKDIR}/bazel-base-${MULTIBUILD_VARIANT}"
	mkdir -p "${BAZEL_OUTPUT_BASE}" || die

	run_in_build_dir $@
}

ebazel() {
	setup_bazelrc

	echo Running: bazel --bazelrc="${T}/bazelrc" --output_base="${BAZEL_OUTPUT_BASE}" "$@"
	bazel --bazelrc="${T}/bazelrc" --output_base="${BAZEL_OUTPUT_BASE}" $@ || die
}

load_distfiles() {
	# populate the bazel distdir to fetch from since it cannot use the network
	local s d uri rename

	while read uri rename d; do
		[[ -z "$uri" ]] && continue
		if [[ "$rename" == "->" ]]; then
			s="${uri##*/}"
			einfo "Copying $d to bazel distdir $s ..."
		else
			s="${uri##*/}"
			d="${s}"
			einfo "Copying $d to bazel distdir ..."
		fi
		cp "${DISTDIR}/${d}" "${T}/bazel-distdir/${s}" || die
	done <<< "${bazel_external_uris}"
}

pkg_setup() {
	export JAVA_HOME=$(java-config --jre-home)
}

src_unpack() {
	# only unpack the main distfile
	unpack "${P}.tar.gz"
}

src_prepare() {
	BAZEL_OUTPUT_BASE="${WORKDIR}/bazel-base"
	mkdir -p "${BAZEL_OUTPUT_BASE}" || die
	setup_bazelrc
	load_distfiles

	default
	python_copy_sources
}

src_configure() {
	do_configure() {
		local cc_opt_flags=( ${CFLAGS} )

		# Keep this list in sync with tensorflow/core/platform/cpu_feature_guard.cc.
		for i in sse sse2 sse3 sse4_1 sse4_2 avx avx2 fma4; do
			use cpu_flags_x86_${i} && cc_opt_flags+=( -m${i/_/.} )
		done
		use cpu_flags_x86_fma3 && cc_opt_flags+=( -mfma )

		python_export PYTHON_SITEDIR
		export CC_OPT_FLAGS="${cc_opt_flags[*]}"
		export GCC_HOST_COMPILER_PATH=$(tc-getCC)
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
		export TF_DOWNLOAD_CLANG=0
		export TF_NEED_CUDA=$(usex cuda 1 0)
		export TF_SET_ANDROID_WORKSPACE=0
		export PYTHON_BIN_PATH="${PYTHON}"
		export PYTHON_LIB_PATH="${PYTHON_SITEDIR}"

		# this is not autoconf
		./configure || die
	}
	python_foreach_impl bazel_multibuild_wrapper do_configure
}

src_compile() {
	python_setup
	local MULTIBUILD_VARIANT="${EPYTHON/./_}"
	cd "${S}-${MULTIBUILD_VARIANT}" || die
	BAZEL_OUTPUT_BASE="${WORKDIR}/bazel-base-${MULTIBUILD_VARIANT}"

	ebazel build \
		--config=opt $(usex cuda --config=cuda '') \
		//tensorflow:libtensorflow_framework.so \
		//tensorflow:libtensorflow.so \
		//tensorflow:libtensorflow_cc.so

	do_compile() {
		cd "${S}-${MULTIBUILD_VARIANT}" || die
		ebazel build \
			--config=opt $(usex cuda --config=cuda '') \
			//tensorflow/tools/pip_package:build_pip_package
	}
	python_foreach_impl bazel_multibuild_wrapper do_compile
}

src_install() {
	do_install() {
		einfo "Installing ${EPYTHON} files"
		local srcdir="${T}/src-${EPYTHON/./_}"
		mkdir -p "${srcdir}" || die
		bazel-bin/tensorflow/tools/pip_package/build_pip_package --src "${srcdir}" || die
		cd "${srcdir}" || die
		esetup.py install

		# it installs site-packages/external but shouldnt
		python_export PYTHON_SITEDIR
		rm -rf "${D}/${PYTHON_SITEDIR}/external" || die
		sed -i '/^external/d' "${D}/${PYTHON_SITEDIR}"/${P}-*.egg-info/{SOURCES,top_level}.txt || die

		# symlink to the main .so file
		rm -rf "${D}/${PYTHON_SITEDIR}/${PN}/lib${PN}_framework.so" || die
		dosym "../../../lib${PN}_framework.so" "${PYTHON_SITEDIR}/${PN}/lib${PN}_framework.so" || die

		python_optimize
	}
	python_foreach_impl bazel_multibuild_wrapper do_install

	# symlink to python-exec scripts
	for i in "${D}"/usr/lib/python-exec/*/*; do
		n="${i##*/}"
		[[ -e "${D}/usr/bin/${n}" ]] || dosym ../lib/python-exec/python-exec2 "/usr/bin/$n"
	done

	python_setup
	local MULTIBUILD_VARIANT="${EPYTHON/./_}"
	cd "${S}-${MULTIBUILD_VARIANT}" || die
	BAZEL_OUTPUT_BASE="${WORKDIR}/bazel-base-${MULTIBUILD_VARIANT}"

	einfo "Installing headers"
	# install c c++ and core header files
	for i in $(find ${PN}/{c,cc,core} -name "*.h"); do
		insinto /usr/include/${PN}/${i%/*}
		doins ${i}
	done

	# eigen headers
	insinto /usr/include/${PN}/third_party/eigen3/Eigen/
	doins third_party/eigen3/Eigen/*

	einfo "Installing libs"
	# generate pkg-config file
	${PN}/c/generate-pc.sh --prefix=/usr --version=${MY_PV} || die
	insinto /usr/$(get_libdir)/pkgconfig
	doins ${PN}.pc

	dolib.so bazel-bin/tensorflow/lib${PN}_framework.so
	dolib.so bazel-bin/tensorflow/lib${PN}.so
	dolib.so bazel-bin/tensorflow/lib${PN}_cc.so

	einstalldocs
}
