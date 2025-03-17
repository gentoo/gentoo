# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..13} )
inherit cuda java-pkg-opt-2 cmake-multilib flag-o-matic multilib multiprocessing python-r1 toolchain-funcs virtualx

DESCRIPTION="A collection of algorithms and sample code for various computer vision problems"
HOMEPAGE="https://opencv.org"

# TODO
# - dnn: move module from opencv_contrib
#   https://github.com/opencv/opencv/commit/93729784bb1c4e544e07ec27a43ef57c4f456cec

if [[ ${PV} = *9999* ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/${PN}/${PN}.git"
else
	# branch master
	ADE_PV="0.1.2d"
	# branch wechat_qrcode_20210119
	QRCODE_COMMIT="a8b69ccc738421293254aec5ddb38bd523503252"
	# branch dnn_samples_face_detector_20170830
	DNN_SAMPLES_FACE_DETECTOR_COMMIT="b2bfc75f6aea5b1f834ff0f0b865a7c18ff1459f"
	# branch contrib_xfeatures2d_boostdesc_20161012
	XFEATURES2D_BOOSTDESC_COMMIT="34e4206aef44d50e6bbcd0ab06354b52e7466d26"
	# branch contrib_xfeatures2d_vgg_20160317
	XFEATURES2D_VGG_COMMIT="fccf7cd6a4b12079f73bbfb21745f9babcd4eb1d"
	# branch contrib_face_alignment_20170818
	FACE_ALIGNMENT_COMMIT="8afa57abc8229d611c4937165d20e2a2d9fc5a12"
	# branch nvof_2_0_bsd
	NVIDIA_OPTICAL_FLOW_COMMIT="edb50da3cf849840d680249aa6dbef248ebce2ca"

	SRC_URI="
		https://github.com/${PN}/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz
		https://github.com/opencv/ade/archive/v${ADE_PV}.tar.gz -> ade-${ADE_PV}.tar.gz
		contrib? (
			https://github.com/${PN}/${PN}_contrib/archive/${PV}.tar.gz -> ${PN}_contrib-${PV}.tar.gz
			dnnsamples? (
				https://github.com/${PN}/${PN}_3rdparty/archive/${QRCODE_COMMIT}.tar.gz -> ${PN}_3rdparty-${QRCODE_COMMIT}.tar.gz
				https://github.com/${PN}/${PN}_3rdparty/archive/${DNN_SAMPLES_FACE_DETECTOR_COMMIT}.tar.gz
					-> ${PN}_3rdparty-${DNN_SAMPLES_FACE_DETECTOR_COMMIT}.tar.gz
			)
			contribxfeatures2d? (
				https://github.com/${PN}/${PN}_3rdparty/archive/${XFEATURES2D_BOOSTDESC_COMMIT}.tar.gz
					-> ${PN}_3rdparty-${XFEATURES2D_BOOSTDESC_COMMIT}.tar.gz
				https://github.com/${PN}/${PN}_3rdparty/archive/${XFEATURES2D_VGG_COMMIT}.tar.gz
					-> ${PN}_3rdparty-${XFEATURES2D_VGG_COMMIT}.tar.gz
			)
			contribdnn? (
				https://github.com/${PN}/${PN}_3rdparty/archive/${FACE_ALIGNMENT_COMMIT}.tar.gz
					-> ${PN}_3rdparty-${FACE_ALIGNMENT_COMMIT}.tar.gz
			)
			cuda? (
				https://github.com/NVIDIA/NVIDIAOpticalFlowSDK/archive/${NVIDIA_OPTICAL_FLOW_COMMIT}.tar.gz
					-> NVIDIAOpticalFlowSDK-${NVIDIA_OPTICAL_FLOW_COMMIT}.tar.gz
			)
			https://github.com/${PN}/${PN}_contrib/commit/667a66ee0e99f3f3263c1ef2de1b90d9244b7bd4.patch
			-> ${PN}_contrib-4.10.0-3607.patch
		)
		test? (
			https://github.com/${PN}/${PN}_extra/archive/refs/tags/${PV}.tar.gz -> ${PN}_extra-${PV}.tar.gz
		)
	"
	KEYWORDS="amd64 ~arm arm64 ~loong ~ppc ~ppc64 ~riscv x86"
fi

LICENSE="Apache-2.0"
SLOT="0/${PV}" # subslot = libopencv* soname version

# general options
IUSE="debug doc +eigen gflags glog java non-free opencvapps python test testprograms"

# modules
IUSE+=" contrib contribcvv contribdnn contribfreetype contribhdf contribovis contribsfm contribxfeatures2d dnnsamples examples +features2d"
# hardware
IUSE+=" cuda cudnn opencl video_cards_intel"
# video
IUSE+=" +ffmpeg gstreamer xine vaapi v4l gphoto2 ieee1394"
# image
IUSE+=" avif gdal jasper jpeg jpeg2k openexr png quirc tesseract tiff webp"
# gui
IUSE+=" gtk3 qt6 opengl truetype vtk"
# parallel
IUSE+=" openmp tbb"
# lapack options
IUSE+=" atlas lapack mkl"

# from cmake/OpenCVCompilerOptimizations.cmake
# TODO make this only relevant for binhost
CPU_FEATURES_MAP=(
	cpu_flags_arm_neon:NEON
	cpu_flags_arm_vfpv3:VFPV3

	# cpu_flags_arm_fp:FP16

	cpu_flags_arm_asimddp:NEON_DOTPROD
	# cpu_flags_arm_neon_fp16:NEON_FP16
	# cpu_flags_arm_neon_bf16:NEON_BF16

	# cpu_flags_loong_lsx:LSX
	# cpu_flags_loong_lasx:LASX

	# cpu_flags_mips_msa:MSA

	cpu_flags_ppc_vsx:VSX   # (always available on Power8)
	cpu_flags_ppc_vsx3:VSX3 # (always available on Power9)

	# cpu_flags_riscv_rvv:RVV

	cpu_flags_x86_sse:SSE   # (always available on 64-bit CPUs)
	cpu_flags_x86_sse2:SSE2 # (always available on 64-bit CPUs)

	cpu_flags_x86_sse3:SSE3
	cpu_flags_x86_ssse3:SSSE3

	cpu_flags_x86_sse4_1:SSE4_1
	cpu_flags_x86_popcnt:POPCNT
	cpu_flags_x86_sse4_2:SSE4_2

	cpu_flags_x86_f16c:FP16
	cpu_flags_x86_fma3:FMA3
	cpu_flags_x86_avx:AVX
	cpu_flags_x86_avx2:AVX2
	cpu_flags_x86_avx512_bitalg:AVX_512BITALG
	cpu_flags_x86_avx512_vbmi2:AVX_512VBMI2
	cpu_flags_x86_avx512_vnni:AVX_512VNNI
	cpu_flags_x86_avx512_vpopcntdq:AVX_512VPOPCNTDQ
	cpu_flags_x86_avx512bw:AVX_512BW
	cpu_flags_x86_avx512cd:AVX_512CD
	cpu_flags_x86_avx512dq:AVX_512DQ
	cpu_flags_x86_avx512f:AVX_512F
	cpu_flags_x86_avx512ifma:AVX_512IFMA
	cpu_flags_x86_avx512vbmi:AVX_512VBMI
	cpu_flags_x86_avx512vl:AVX_512VL

	# AVX512_KNL_EXTRA
	cpu_flags_x86_avx512er:AVX_512ER
	cpu_flags_x86_avx512pf:AVX_512PF
	# AVX512_KNM_EXTRA
	cpu_flags_x86_avx512_4fmaps:AVX_5124FMAPS
	cpu_flags_x86_avx512_4vnniw:AVX_5124VNNIW

)
IUSE+=" ${CPU_FEATURES_MAP[*]%:*}"

REQUIRED_USE="
	amd64? (
		cpu_flags_x86_sse
		cpu_flags_x86_sse2
		cpu_flags_x86_avx2? ( cpu_flags_x86_f16c )
		cpu_flags_x86_f16c? ( cpu_flags_x86_avx )
		cpu_flags_x86_avx512er? ( cpu_flags_x86_avx512pf )
		cpu_flags_x86_avx512pf? ( cpu_flags_x86_avx512er )
		cpu_flags_x86_avx512_4fmaps? ( cpu_flags_x86_avx512_4fmaps )
		cpu_flags_x86_avx512_4vnniw? ( cpu_flags_x86_avx512_4vnniw )
	)
	cuda? (
		contrib
	)
	cudnn? ( cuda )
	dnnsamples? ( examples )
	gflags? ( contrib )
	glog? ( contrib )
	contribcvv? ( contrib qt6 )
	contribdnn? ( contrib )
	contribfreetype? ( contrib )
	contribhdf? ( contrib )
	contribovis? ( contrib )
	contribsfm? ( contrib eigen gflags glog )
	contribxfeatures2d? ( contrib )
	java? ( python )
	opengl? ( qt6 )
	jasper? ( !abi_x86_32 )
	python? ( ${PYTHON_REQUIRED_USE} )
	tesseract? ( contrib )
	?? ( gtk3 qt6 )
	testprograms? ( test )
	test? ( || ( ffmpeg gstreamer ) jpeg png tiff features2d )
"

RESTRICT="!test? ( test )"

COMMON_DEPEND="
	app-arch/bzip2[${MULTILIB_USEDEP}]
	dev-libs/protobuf:=[${MULTILIB_USEDEP}]
	sys-libs/zlib[${MULTILIB_USEDEP}]
	avif? ( media-libs/libavif:=[${MULTILIB_USEDEP}] )
	cuda? ( dev-util/nvidia-cuda-toolkit:= )
	cudnn? (
		dev-cpp/abseil-cpp:=
		dev-libs/cudnn:=
	)
	contribdnn? ( dev-libs/flatbuffers:= )
	contribhdf? ( sci-libs/hdf5:= )
	contribfreetype? (
		media-libs/freetype:2[${MULTILIB_USEDEP}]
		media-libs/harfbuzz:=[${MULTILIB_USEDEP}]
	)
	contribovis? ( >=dev-games/ogre-1.12:= )
	ffmpeg? ( media-video/ffmpeg:0=[${MULTILIB_USEDEP}] )
	truetype? ( media-libs/freetype:2[${MULTILIB_USEDEP}] )
	gdal? ( sci-libs/gdal:= )
	gflags? ( dev-cpp/gflags:=[${MULTILIB_USEDEP}] )
	glog? ( dev-cpp/glog:=[${MULTILIB_USEDEP}] )
	gphoto2? ( media-libs/libgphoto2:=[${MULTILIB_USEDEP}] )
	gstreamer? (
		media-libs/gstreamer:1.0[${MULTILIB_USEDEP}]
		media-libs/gst-plugins-base:1.0[${MULTILIB_USEDEP}]
	)
	gtk3? (
		dev-libs/glib:2[${MULTILIB_USEDEP}]
		x11-libs/gtk+:3[${MULTILIB_USEDEP}]
	)
	ieee1394? (
		media-libs/libdc1394:=[${MULTILIB_USEDEP}]
		sys-libs/libraw1394[${MULTILIB_USEDEP}]
	)
	jpeg? ( media-libs/libjpeg-turbo:=[${MULTILIB_USEDEP}] )
	jpeg2k? (
		jasper? ( media-libs/jasper:= )
		!jasper? ( media-libs/openjpeg:2=[${MULTILIB_USEDEP}] )
	)
	lapack? (
		atlas? ( sci-libs/atlas )
		mkl? ( sci-libs/mkl )
		!atlas? (
			!mkl? (
				virtual/cblas
				>=virtual/lapack-3.10
				virtual/lapacke
			)
		)
	)
	opencl? (
		virtual/opencl[${MULTILIB_USEDEP}]
		dev-util/opencl-headers
	)
	openexr? (
		dev-libs/imath:=
		media-libs/openexr:=
	)
	opengl? (
		virtual/opengl[${MULTILIB_USEDEP}]
		virtual/glu[${MULTILIB_USEDEP}]
	)
	png? ( media-libs/libpng:0=[${MULTILIB_USEDEP}] )
	python? (
		${PYTHON_DEPS}
		dev-python/numpy:=[${PYTHON_USEDEP}]
	)
	qt6? (
		dev-qt/qtbase:6[gui,widgets,concurrent,opengl?]
	)
	quirc? ( media-libs/quirc )
	tesseract? ( app-text/tesseract[${MULTILIB_USEDEP}] )
	tbb? ( dev-cpp/tbb:=[${MULTILIB_USEDEP}] )
	tiff? ( media-libs/tiff:=[${MULTILIB_USEDEP}] )
	v4l? ( >=media-libs/libv4l-0.8.3[${MULTILIB_USEDEP}] )
	vaapi? ( media-libs/libva[${MULTILIB_USEDEP}] )
	vtk? (
		sci-libs/vtk:=[rendering,cuda=]
		|| (
			(
				sci-libs/vtk[opencascade(+)]
				sci-libs/opencascade[-ffmpeg]
			)
			sci-libs/vtk[-opencascade(-)]
		)
	)
	webp? ( media-libs/libwebp:=[${MULTILIB_USEDEP}] )
	xine? ( media-libs/xine-lib )
"
GST_TEST_DEPEND="
	media-plugins/gst-plugins-aom[${MULTILIB_USEDEP}]
	media-plugins/gst-plugins-mpeg2enc[${MULTILIB_USEDEP}]
	media-plugins/gst-plugins-openh264[${MULTILIB_USEDEP}]
"
DEPEND="
	${COMMON_DEPEND}
	eigen? ( >=dev-cpp/eigen-3.3.8-r1:3 )
	java? ( >=virtual/jdk-1.8:* )
	test? (
		gstreamer? (
			amd64? ( ${GST_TEST_DEPEND} )
			arm64? ( ${GST_TEST_DEPEND} )
			x86? ( ${GST_TEST_DEPEND} )
			arm? ( media-plugins/gst-plugins-openh264[${MULTILIB_USEDEP}] )
			media-plugins/gst-plugins-jpeg[${MULTILIB_USEDEP}]
			media-plugins/gst-plugins-libav[${MULTILIB_USEDEP}]
			media-plugins/gst-plugins-mpeg2dec[${MULTILIB_USEDEP}]
			media-plugins/gst-plugins-mpg123[${MULTILIB_USEDEP}]
			media-plugins/gst-plugins-x264[${MULTILIB_USEDEP}]
			!ppc? ( !ppc64? (
				media-plugins/gst-plugins-vpx[${MULTILIB_USEDEP}]
			) )
		)
	)
"
RDEPEND="
	${COMMON_DEPEND}
	java? ( >=virtual/jre-1.8:* )
"
unset COMMON_DEPEND

BDEPEND="
	dev-util/patchelf
	virtual/pkgconfig
	cuda? ( dev-util/nvidia-cuda-toolkit:= )
	doc? (
		app-text/doxygen[dot]
		python? (
			dev-python/beautifulsoup4[${PYTHON_USEDEP}]
		)
	)
	java? ( >=dev-java/ant-1.10.14-r3 )
"

PATCHES=(
	"${FILESDIR}/${PN}-3.4.1-cuda-add-relaxed-constexpr.patch"
	"${FILESDIR}/${PN}-4.1.2-opencl-license.patch"
	"${FILESDIR}/${PN}-4.4.0-disable-native-cpuflag-detect.patch"
	"${FILESDIR}/${PN}-4.5.0-link-with-cblas-for-lapack.patch"

	"${FILESDIR}/${PN}-4.8.1-use-system-flatbuffers.patch"
	"${FILESDIR}/${PN}-4.8.1-use-system-opencl.patch"

	"${FILESDIR}/${PN}-4.9.0-drop-python2-detection.patch"
	"${FILESDIR}/${PN}-4.9.0-ade-0.1.2d.tar.gz.patch"
	"${FILESDIR}/${PN}-4.9.0-cmake-cleanup.patch"

	"${FILESDIR}/${PN}-4.10.0-dnn-explicitly-include-abseil-cpp.patch"
	"${FILESDIR}/${PN}-4.10.0-cudnn-9.patch" # 25841
	"${FILESDIR}/${PN}-4.10.0-cuda-fp16.patch" # 25880
	"${FILESDIR}/${PN}-4.10.0-26234.patch" # 26234
	"${FILESDIR}/${PN}-4.10.0-tbb-detection.patch"

	# TODO applied in src_prepare
	# "${FILESDIR}/${PN}_contrib-4.8.1-rgbd.patch"

	# "${FILESDIR}/${PN}_contrib-4.8.1-NVIDIAOpticalFlowSDK-2.0.tar.gz.patch"

	# "${FILESDIR}/${PN}_contrib-4.10.0-CUDA-12.6-tuple_size.patch" # 3785
)

cuda_get_host_compiler() {
	if [[ -n "${NVCC_CCBIN}" ]]; then
		echo "${NVCC_CCBIN}"
		return
	fi

	if [[ -n "${CUDAHOSTCXX}" ]]; then
		echo "${CUDAHOSTCXX}"
		return
	fi

	einfo "Trying to find working CUDA host compiler"

	if ! tc-is-gcc && ! tc-is-clang; then
		die "$(tc-get-compiler-type) compiler is not supported"
	fi

	local compiler compiler_type compiler_version
	local package package_version
	local -x NVCC_CCBIN
	local NVCC_CCBIN_default

	compiler_type="$(tc-get-compiler-type)"
	compiler_version="$("${compiler_type}-major-version")"

	# try the default compiler first
	NVCC_CCBIN="$(tc-getCXX)"
	NVCC_CCBIN_default="${NVCC_CCBIN}-${compiler_version}"

	compiler="${NVCC_CCBIN/%-${compiler_version}}"

	# store the package so we can re-use it later
	package="sys-devel/${compiler_type}"
	package_version="${package}"

	ebegin "testing ${NVCC_CCBIN_default} (default)"

	while ! nvcc -v -ccbin "${NVCC_CCBIN}" - -x cu <<<"int main(){}" &>> "${T}/cuda_get_host_compiler.log" ; do
		eend 1

		while true; do
			# prepare next version
			if ! package_version="<$(best_version "${package_version}")"; then
				die "could not find a supported version of ${compiler}"
			fi

			NVCC_CCBIN="${compiler}-$(ver_cut 1 "${package_version/#<${package}-/}")"

			[[ "${NVCC_CCBIN}" != "${NVCC_CCBIN_default}" ]] && break
		done
		ebegin "testing ${NVCC_CCBIN}"
	done
	eend $?

	echo "${NVCC_CCBIN}"
	export NVCC_CCBIN
}

cuda_get_host_native_arch() {
	[[ -n ${CUDAARCHS} ]] && echo "${CUDAARCHS}"

	__nvcc_device_query || die "failed to query the native device"
}

pkg_pretend() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp

	if use cuda && [[ -z "${CUDA_GENERATION}" ]] && [[ -z "${CUDA_ARCH_BIN}" ]]; then # TODO CUDAARCHS
		einfo "The target CUDA architecture can be set via one of:"
		einfo "  - CUDA_GENERATION set to one of Maxwell, Pascal, Volta, Turing, Ampere, Lovelace, Hopper, Auto"
		einfo "  - CUDA_ARCH_BIN, (and optionally CUDA_ARCH_PTX) in the form of x.y tuples."
		einfo "      You can specify multiple tuple separated by \";\"."
		einfo ""
		einfo "The CUDA architecture tuple for your device can be found at https://developer.nvidia.com/cuda-gpus."
	fi

	# When building binpkgs you probably want to include all targets
	if use cuda && [[ ${MERGE_TYPE} == "buildonly" ]] && [[ -n "${CUDA_GENERATION}" || -n "${CUDA_ARCH_BIN}" ]]; then
		local info_message="When building a binary package it's recommended to unset CUDA_GENERATION and CUDA_ARCH_BIN"
		einfo "$info_message so all available architectures are build."
	fi
}

pkg_setup() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp

	use java && java-pkg-opt-2_pkg_setup

	if use cuda && [[ ! -e /dev/nvidia-uvm ]]; then
		# NOTE We try to load nvidia-uvm and nvidia-modeset here,
		# so __nvcc_device_query does not fail later.

		nvidia-modprobe -m -u -c 0 || true
	fi
}

src_prepare() {
	cmake_src_prepare

	# remove bundled stuff
	rm -r 3rdparty || die "Removing 3rd party components failed"
	sed -e '/add_subdirectory(.*3rdparty.*)/ d' \
		-i CMakeLists.txt cmake/*cmake || die

	sed \
		-e 's:truetype/wqy:wqy-microhei:g' \
		-i \
			modules/gapi/test/render/gapi_render_tests_ocv.cpp \
			modules/gapi/test/render/ftp_render_test.cpp \
		|| die

	if use contrib; then
		cd "${WORKDIR}/${PN}_contrib-${PV}" || die
		eapply "${FILESDIR}/${PN}_contrib-4.8.1-rgbd.patch"
		eapply "${FILESDIR}/${PN}_contrib-4.8.1-NVIDIAOpticalFlowSDK-2.0.tar.gz.patch"
		if type -P nvcc &> /dev/null && ver_test "$(nvcc --version | tail -n 1 | cut -d '_' -f 2- | cut -d '.' -f 1-2)" -ge 12.4; then
			eapply "${DISTDIR}/${PN}_contrib-4.10.0-3607.patch"
			eapply "${FILESDIR}/${PN}_contrib-4.10.0-CUDA-12.6-tuple_size.patch" # 3785
		fi

		cd "${S}" || die

		! use contribcvv && { rm -R "${WORKDIR}/${PN}_contrib-${PV}/modules/cvv" || die; }
		! use contribdnn && { rm -R "${S}/modules/dnn" || die; }
		! use contribfreetype && { rm -R "${WORKDIR}/${PN}_contrib-${PV}/modules/freetype" || die; }
		! use contribhdf && { rm -R "${WORKDIR}/${PN}_contrib-${PV}/modules/hdf" || die; }
		! use contribovis && { rm -R "${WORKDIR}/${PN}_contrib-${PV}/modules/ovis" || die; }
		! use contribsfm && { rm -R "${WORKDIR}/${PN}_contrib-${PV}/modules/sfm" || die; }
		! use contribxfeatures2d && { rm -R "${WORKDIR}/${PN}_contrib-${PV}/modules/xfeatures2d" || die; }
	fi

	mkdir -p "${S}/.cache/ade" || die
	cp \
		"${DISTDIR}/ade-${ADE_PV}.tar.gz" \
		"${S}/.cache/ade/$(md5sum "${DISTDIR}/ade-${ADE_PV}.tar.gz" | cut -f 1 -d " ")-v${ADE_PV}.tar.gz" || die

	if use dnnsamples; then
		mkdir -p "${S}/.cache/wechat_qrcode" || die
		for file in "detect.caffemodel" "detect.prototxt" "sr.prototxt" "sr.caffemodel"; do
			mv \
				"${WORKDIR}/${PN}_3rdparty-${QRCODE_COMMIT}/${file}" \
				"${S}/.cache/wechat_qrcode/$( \
					md5sum "${WORKDIR}/${PN}_3rdparty-${QRCODE_COMMIT}/${file}" | cut -f 1 -d " " \
				)-${file}" || die
		done

		mv \
			"${WORKDIR}/${PN}_3rdparty-${DNN_SAMPLES_FACE_DETECTOR_COMMIT}/res10_300x300_ssd_iter_140000.caffemodel" \
			"${S}/samples/dnn/" || die
	fi

	if use contribxfeatures2d; then
		cp \
			"${WORKDIR}/${PN}_3rdparty-${XFEATURES2D_BOOSTDESC_COMMIT}/"*.i \
			"${WORKDIR}/${PN}_contrib-${PV}"/modules/xfeatures2d/src/ || die
		mkdir -p "${S}/.cache/xfeatures2d/boostdesc" || die
		for file in "${WORKDIR}/${PN}_3rdparty-${XFEATURES2D_BOOSTDESC_COMMIT}/"*.i; do
			mv \
				"${WORKDIR}/${PN}_3rdparty-${XFEATURES2D_BOOSTDESC_COMMIT}/$(basename "${file}")" \
				"${S}/.cache/xfeatures2d/boostdesc/$( \
					md5sum "${WORKDIR}/${PN}_3rdparty-${XFEATURES2D_BOOSTDESC_COMMIT}/$(basename "${file}")" | cut -f 1 -d " " \
				)-$(basename "${file}")" || die
		done

		cp \
			"${WORKDIR}/${PN}_3rdparty-${XFEATURES2D_VGG_COMMIT}/"*.i \
			"${WORKDIR}/${PN}_contrib-${PV}"/modules/xfeatures2d/src/ || die
		mkdir -p "${S}/.cache/xfeatures2d/vgg" || die
		for file in "${WORKDIR}/${PN}_3rdparty-${XFEATURES2D_VGG_COMMIT}/"*.i; do
			mv \
				"${WORKDIR}/${PN}_3rdparty-${XFEATURES2D_VGG_COMMIT}/$(basename "${file}")" \
				"${S}/.cache/xfeatures2d/vgg/$( \
					md5sum "${WORKDIR}/${PN}_3rdparty-${XFEATURES2D_VGG_COMMIT}/$(basename "${file}")" | cut -f 1 -d " " \
				)-$(basename "${file}")" || die
		done
	fi

	if use contribdnn; then
		mkdir -p "${S}/.cache/data" || die
		mkdir -p "${WORKDIR}/${PN}_extra-${PV}/testdata/cv/face/" || die
		file="face_landmark_model.dat"
		cp \
			"${WORKDIR}/${PN}_3rdparty-${FACE_ALIGNMENT_COMMIT}/${file}" \
			"${WORKDIR}/${PN}_extra-${PV}/testdata/cv/face/" \
			|| die
		mv \
			"${WORKDIR}/${PN}_3rdparty-${FACE_ALIGNMENT_COMMIT}/${file}" \
			"${S}/.cache/data/$( \
				md5sum "${WORKDIR}/${PN}_3rdparty-${FACE_ALIGNMENT_COMMIT}/${file}" | cut -f 1 -d " " \
			)-${file}" || die
	fi

	if use cuda; then
		mkdir -p "${S}/.cache/nvidia_optical_flow"
		cp \
			"${DISTDIR}/NVIDIAOpticalFlowSDK-${NVIDIA_OPTICAL_FLOW_COMMIT}.tar.gz" \
			"${S}/.cache/nvidia_optical_flow/$( \
				md5sum "${DISTDIR}/NVIDIAOpticalFlowSDK-${NVIDIA_OPTICAL_FLOW_COMMIT}.tar.gz" | cut -f 1 -d " " \
			)-${NVIDIA_OPTICAL_FLOW_COMMIT}.tar.gz" || die
	fi

	if use java; then
		java-pkg-opt-2_src_prepare

		# set encoding so even this cmake build will pick it up.
		ANT_OPTS+=" -Dfile.encoding=iso-8859-1"
		ANT_OPTS+=" -Dant.build.javac.source=$(java-pkg_get-source)"
		ANT_OPTS+=" -Dant.build.javac.target=$(java-pkg_get-target)"
	fi

	if multilib_native_use testprograms; then
		sed \
			-e 's:share/OpenCV/testdata:@OPENCV_TEST_DATA_INSTALL_PATH@:g' \
			-i  "${S}/cmake/templates/opencv_run_all_tests_unix.sh.in" || die
	fi
}

multilib_src_configure() {
	# bug #919101 and https://github.com/opencv/opencv/issues/19020
	filter-lto

	# please don't sort here, order is the same as in CMakeLists.txt
	local mycmakeargs=(
		-DMIN_VER_CMAKE=3.26

		-DCMAKE_POLICY_DEFAULT_CMP0148="OLD" # FindPythonInterp

		# for protobuf
		-DCMAKE_CXX_STANDARD=17

	# Optional 3rd party components
	# ===================================================
		-DOPENCV_ENABLE_NONFREE="$(usex non-free)"
		-DWITH_QUIRC="$(usex quirc)"
		-DWITH_FLATBUFFERS="$(multilib_native_usex contribdnn)"
		-DWITH_1394="$(usex ieee1394)"
		# -DWITH_AVFOUNDATION="no" # IOS
		-DWITH_VTK="$(multilib_native_usex vtk)"
		-DWITH_EIGEN="$(usex eigen)"
		-DWITH_VFW="no" # Video windows support
		-DWITH_FFMPEG="$(usex ffmpeg)"
		-DWITH_GSTREAMER="$(usex gstreamer)"
		-DWITH_GTK="$(usex gtk3)"
		-DWITH_GTK_2_X="no" # only want gtk3 nowadays
		-DWITH_IPP="no"
		-DWITH_JASPER="$(usex jpeg2k "$(multilib_native_usex jasper)")"
		-DWITH_JPEG="$(usex jpeg)"
		-DWITH_OPENJPEG="$(usex jpeg2k "$(multilib_native_usex !jasper)")"
		-DWITH_WEBP="$(usex webp)"
		-DWITH_OPENEXR="$(multilib_native_usex openexr)"
		-DWITH_OPENGL="$(usex opengl)"
		-DOpenGL_GL_PREFERENCE="GLVND"
		-DWITH_OPENVX="no"
		-DWITH_OPENNI="no"       # Not packaged
		-DWITH_OPENNI2="no"      # Not packaged
		-DWITH_PNG="$(usex png)"
		-DWITH_GDCM="no"
		-DWITH_PVAPI="no"
		-DWITH_GIGEAPI="no"
		-DWITH_ARAVIS="no"
		-DWITH_WIN32UI="no"              # Windows only
		# -DWITH_QUICKTIME="no"
		# -DWITH_QTKIT="no"
		-DWITH_TBB="$(usex tbb)"
		-DWITH_OPENMP="$(usex openmp)"
		-DWITH_PTHREADS_PF="yes"
		-DWITH_TIFF="$(usex tiff)"
		-DWITH_UNICAP="no"               # Not packaged
		-DWITH_V4L="$(usex v4l)"
		-DWITH_LIBV4L="$(usex v4l)"
		# -DWITH_DSHOW="yes"                 # direct show supp
		-DWITH_MSMF="no"
		-DWITH_XIMEA="no"        # Windows only
		-DWITH_XINE="$(multilib_native_usex xine)"
		-DWITH_CLP="no"
		-DWITH_OPENCL="$(usex opencl)"
		-DWITH_OPENCL_SVM="no" # "$(usex opencl)"
		-DWITH_DIRECTX="no"
		-DWITH_INTELPERC="no"
		-DWITH_IPP_A="no"
		-DWITH_MATLAB="no"
		-DWITH_VA="$(usex vaapi)"
		-DWITH_VA_INTEL="$(usex vaapi "$(usex video_cards_intel)")"
		-DWITH_GDAL="$(multilib_native_usex gdal)"
		-DWITH_GPHOTO2="$(usex gphoto2)"
		-DWITH_LAPACK="$(multilib_native_usex lapack)"
		-DWITH_ITT="no" # 3dparty libs itt_notify

		-DWITH_AVIF="$(usex avif)"
		-DWITH_FREETYPE="$(usex truetype)"
	# ===================================================
	# CUDA build components: nvidia-cuda-toolkit
	# ===================================================
		-DWITH_CUDA="$(multilib_native_usex cuda)"
		-DWITH_CUBLAS="$(multilib_native_usex cuda)"
		-DWITH_CUFFT="$(multilib_native_usex cuda)"
		-DWITH_CUDNN="$(multilib_native_usex cudnn)"
		# NOTE set this via MYCMAKEARGS if needed
		-DWITH_NVCUVID="no" # TODO needs NVIDIA Video Codec SDK
		-DWITH_NVCUVENC="no" # TODO needs NVIDIA Video Codec SDK
		-DCUDA_NPP_LIBRARY_ROOT_DIR="$(usex cuda "${CUDA_PATH:=${EPREFIX}/opt/cuda}" "")"
	# ===================================================
	# OpenCV build components
	# ===================================================
		-DBUILD_SHARED_LIBS="yes"
		-DBUILD_JAVA="$(multilib_native_usex java)" # Ant needed, no compile flag
		-DBUILD_ANDROID_EXAMPLES="no"
		-DBUILD_opencv_apps="$(usex opencvapps)"
		-DBUILD_DOCS="$(usex doc)" # Doesn't install anyways.
		-DBUILD_EXAMPLES="$(multilib_native_usex examples)"
		-DBUILD_TESTS="$(multilib_native_usex test "yes" "$(multilib_native_usex testprograms)")"
		-DBUILD_PERF_TESTS="no"

		# -DBUILD_WITH_STATIC_CRT="no"
		-DBUILD_WITH_DYNAMIC_IPP="no"
		-DBUILD_FAT_JAVA_LIB="no"
		# -DBUILD_ANDROID_SERVICE="no"
		-DBUILD_CUDA_STUBS="$(multilib_native_usex cuda)"
		-DOPENCV_EXTRA_MODULES_PATH="$(usex contrib "${WORKDIR}/${PN}_contrib-${PV}/modules" "")"
	# ===================================================
	# OpenCV installation options
	# ===================================================
		-DINSTALL_CREATE_DISTRIB="no"
		-DINSTALL_BIN_EXAMPLES="$(multilib_native_usex examples)"
		-DINSTALL_C_EXAMPLES="$(multilib_native_usex examples)"
		-DINSTALL_TESTS="$(multilib_native_usex testprograms)"
		# -DINSTALL_ANDROID_EXAMPLES="no"
		-DINSTALL_TO_MANGLED_PATHS="no"
		-DOPENCV_GENERATE_PKGCONFIG="yes"
		# opencv uses both ${CMAKE_INSTALL_LIBDIR} and ${LIB_SUFFIX}
		# to set its destination libdir
		-DLIB_SUFFIX=
	# ===================================================
	# OpenCV build options
	# ===================================================
		-DENABLE_CCACHE="no"
		# bug 733796, but PCH is a risky game in CMake anyway
		-DBUILD_USE_SYMLINKS="yes"
		-DENABLE_PRECOMPILED_HEADERS="no"
		-DENABLE_SOLUTION_FOLDERS="no"
		-DENABLE_PROFILING="no"
		-DENABLE_COVERAGE="no"
		-DOPENCV_DOWNLOAD_TRIES_LIST="0"

		-DHAVE_opencv_java="$(multilib_native_usex java)"

		-DBUILD_WITH_DEBUG_INFO="$(usex debug)"
		-DOPENCV_ENABLE_MEMORY_SANITIZER="$(usex debug)"
		-DCV_TRACE="$(usex debug)"
		-DENABLE_NOISY_WARNINGS="$(usex debug)"
		-DOPENCV_WARNINGS_ARE_ERRORS="no"
		-DENABLE_IMPL_COLLECTION="no"
		-DENABLE_INSTRUMENTATION="no"
		-DGENERATE_ABI_DESCRIPTOR="no"
	# ===================================================
	# things we want to be hard off or not yet figured out
	# ===================================================
		-DBUILD_PACKAGE="no"
	# ===================================================
	# Not building protobuf but update files bug #631418
	# ===================================================
		-DWITH_PROTOBUF="yes"
		-DBUILD_PROTOBUF="no"
		-DPROTOBUF_UPDATE_FILES="yes"
		-DProtobuf_MODULE_COMPATIBLE="yes"
	# ===================================================
	# things we want to be hard enabled not worth useflag
	# ===================================================
		-DOPENCV_DOC_INSTALL_PATH="share/doc/${PF}"
		-DOPENCV_SAMPLES_BIN_INSTALL_PATH="libexec/${PN}/bin/samples"

		-DBUILD_IPP_IW="no"
		-DBUILD_ITT="no"

	# ===================================================
	# configure modules to be build
	# ===================================================
		-DBUILD_opencv_gapi="$(usex ffmpeg yes "$(usex gstreamer)")"
		-DBUILD_opencv_features2d="$(usex features2d)"
		-DBUILD_opencv_java_bindings_generator="$(usex java)"
		-DBUILD_opencv_js="no"
		-DBUILD_opencv_js_bindings_generator="no"
		-DBUILD_opencv_objc_bindings_generator="no"
		-DBUILD_opencv_python2="no"
		-DBUILD_opencv_ts="$(usex test)"
		-DBUILD_opencv_video="$(usex ffmpeg yes "$(usex gstreamer)")"
		-DBUILD_opencv_videoio="$(usex ffmpeg yes "$(usex gstreamer)")"

		-DBUILD_opencv_cudalegacy="no"

		# -DBUILD_opencv_world="yes"

		-DOPENCV_PLUGIN_VERSION=".$(ver_rs 1-2 '' "$(ver_cut 1-2)")"
		-DOPENCV_PLUGIN_ARCH=".${ARCH}"

		-DDNN_PLUGIN_LIST="all"
		-DHIGHGUI_ENABLE_PLUGINS="no"
	)

	local VIDEOIO_PLUGIN_LIST=()
	if use ffmpeg; then
		VIDEOIO_PLUGIN_LIST+=("ffmpeg")
	fi
	if use gstreamer; then
		VIDEOIO_PLUGIN_LIST+=("gstreamer")
	fi

	mycmakeargs+=(
		-DVIDEOIO_PLUGIN_LIST="$(IFS=';'; echo "${VIDEOIO_PLUGIN_LIST[*]}")"
	)

	if use qt6; then
		mycmakeargs+=(
			-DWITH_QT="$(multilib_native_usex qt6)"
			-DCMAKE_DISABLE_FIND_PACKAGE_Qt5="yes"
		)
	else
		mycmakeargs+=(
			-DWITH_QT="no"
			-DCMAKE_DISABLE_FIND_PACKAGE_Qt5="yes"
			-DCMAKE_DISABLE_FIND_PACKAGE_Qt6="yes"
		)
	fi

	# ==================================================
	# cpu flags, should solve 633900
	#===================================================
	# TODO binhost https://github.com/opencv/opencv/wiki/CPU-optimizations-build-options

	local CPU_BASELINE=""
	for i in "${CPU_FEATURES_MAP[@]}" ; do
		if [[ ${ABI} != x86 || ${i%:*} != "cpu_flags_x86_avx2" ]]; then # workaround for Bug 747163
			local value
			# These are merged into one flag internally
			if [[ ${ABI} == amd64 ]]; then
				case "${i%:*}" in
					cpu_flags_x86_avx512er|cpu_flags_x86_avx512pf)
						value="AVX512_KNL_EXTRA"
						;;
					cpu_flags_x86_avx512_4fmaps|cpu_flags_x86_avx512_4vnniw)
						value="AVX512_KNM_EXTRA"
						;;
					*)
						value="${i#*:}"
						;;
				esac
			else
				value=${i#*:}
			fi

			use "${i%:*}" && CPU_BASELINE="${CPU_BASELINE}${value};"
		fi
	done
	unset CPU_FEATURES_MAP

	mycmakeargs+=(
		-DCPU_BASELINE="${CPU_BASELINE}"
	)
	if [[ ${MERGE_TYPE} != "buildonly" ]]; then
		mycmakeargs+=(
			-DOPENCV_CPU_OPT_IMPLIES_IGNORE="yes"
			-DCPU_DISPATCH=
		)
	fi

	# ===================================================
	# OpenCV Contrib Modules
	# ===================================================
	# NOTE
	# we remove unused modules,
	# so we shouldn't need to disable options for unused modules
	if use contrib; then
		mycmakeargs+=(
			-DBUILD_opencv_cvv="$(usex contribcvv)"
			-DBUILD_opencv_dnn="$(usex contribdnn)"
			-DOPENCV_DNN_OPENCL="$(usex opencl)"
			-DOPENCV_DNN_CUDA="$(multilib_native_usex cudnn)"

			-DBUILD_opencv_freetype="$(usex contribfreetype)"
			-DBUILD_opencv_hdf="$(multilib_native_usex contribhdf)"
			-DBUILD_opencv_ovis="$(usex contribovis)"
			-DBUILD_opencv_sfm="$(usex contribsfm)"
			-DBUILD_opencv_xfeatures2d="$(usex contribxfeatures2d)"
		)

		if ! multilib_native_use tesseract; then
			mycmakeargs+=(
				-DCMAKE_DISABLE_FIND_PACKAGE_Tesseract="yes"
			)
		fi
	fi

	# workaround for bug 413429
	tc-export CC CXX

	if multilib_native_use cuda; then
		cuda_add_sandbox -w
		addwrite "/proc/self/task"

		if ! test -w /dev/nvidiactl; then
			# eqawarn "Can't access the GPU at /dev/nvidiactl."
			# eqawarn "User $(id -nu) is not in the group \"video\"."
			if [[ -z "${CUDA_GENERATION}" ]] && [[ -z "${CUDA_ARCH_BIN}" ]]; then
				# build all targets
				mycmakeargs+=(
					-DCUDA_GENERATION=""
				)
			fi
		else
			local -x CUDAARCHS
			: "${CUDAARCHS:="$(cuda_get_host_native_arch)"}"
		fi

		local -x CUDAHOSTCXX CUDAHOSTLD
		CUDAHOSTCXX="$(cuda_get_host_compiler)"
		CUDAHOSTLD="$(tc-getCXX)"

		if tc-is-gcc; then
			# Filter out IMPLICIT_LINK_DIRECTORIES picked up by CMAKE_DETERMINE_COMPILER_ABI(CUDA)
			# See /usr/share/cmake/Help/variable/CMAKE_LANG_IMPLICIT_LINK_DIRECTORIES.rst
			CMAKE_CUDA_IMPLICIT_LINK_DIRECTORIES_EXCLUDE=$(
				"${CUDAHOSTLD}" -E -v - <<<"int main(){}" |& \
				grep LIBRARY_PATH | cut -d '=' -f 2 | cut -d ':' -f 1
			)
		fi

		mycmakeargs+=(
			-DENABLE_CUDA_FIRST_CLASS_LANGUAGE="yes"
		)
	fi

	if use ffmpeg; then
		mycmakeargs+=(
			-DOPENCV_GAPI_GSTREAMER="no"
			-DOPENCV_FFMPEG_DISABLE_MEDIASDK="yes"
		)
	fi

	# according to modules/java/jar/CMakeLists.txt:23-26
	if use java; then
		mycmakeargs+=(
			-DOPENCV_JAVA_SOURCE_VERSION="$(java-pkg_get-source)"
			-DOPENCV_JAVA_TARGET_VERSION="$(java-pkg_get-target)"
		)
	fi

	if use mkl; then
		mycmakeargs+=(
			-DLAPACK_IMPL="MKL"
			-DMKL_WITH_OPENMP="$(usex openmp)"
			-DMKL_WITH_TBB="$(usex tbb)"
		)
	fi

	# NOTE set this via MYCMAKEARGS if needed
	if use opencl; then
		if has_version sci-libs/clfft; then
			mycmakeargs+=( -DWITH_OPENCLAMDFFT="yes" )
		else
			mycmakeargs+=( -DWITH_OPENCLAMDFFT="no" )
		fi
		if has_version sci-libs/clblas; then
			mycmakeargs+=( -DWITH_OPENCLAMDBLAS="yes" )
		else
			mycmakeargs+=( -DWITH_OPENCLAMDBLAS="no" )
		fi
	else
		mycmakeargs+=(
			-DWITH_OPENCLAMDFFT="no"
			-DWITH_OPENCLAMDBLAS="no"
		)
	fi

	# NOTE due to multilib we can't do
	# if multilib_native_use test; then
	if use test; then
		# opencv tests assume to be build in Release mode
		local -x CMAKE_BUILD_TYPE="Release"
		mycmakeargs+=(
			-DOPENCV_TEST_DATA_PATH="${WORKDIR}/${PN}_extra-${PV}/testdata"
		)
		if use vtk; then
			mycmakeargs+=(
				-DVTK_MPI_NUMPROCS="$(makeopts_jobs)" # TODO
			)
		fi
	fi

	if multilib_native_use testprograms; then
		# NOTE do this so testprograms do not fail
		mycmakeargs+=(
			-DOPENCV_TEST_INSTALL_PATH="libexec/${PN}/bin/test"
		)
	fi

	if multilib_native_use python; then
		python_configure() {
			# Set all python variables to load the correct Gentoo paths
			local mycmakeargs=(
				"${mycmakeargs[@]}"
				# python_setup alters PATH and sets this as wrapper
				# to the correct interpreter we are building for
				-DBUILD_opencv_python3="yes"
				-DBUILD_opencv_python_bindings_generator="yes"
				-DBUILD_opencv_python_tests="$(usex test)"
				-DPYTHON_DEFAULT_EXECUTABLE="${EPYTHON}"
				-DINSTALL_PYTHON_EXAMPLES="$(usex examples)"
			)
			cmake_src_configure
		}

		python_foreach_impl python_configure
	else
		mycmakeargs+=(
			-DPYTHON_EXECUTABLE="no"
			-DINSTALL_PYTHON_EXAMPLES="no"
			-DBUILD_opencv_python3="no"
			-DBUILD_opencv_python_bindings_generator="no"
			-DBUILD_opencv_python_tests="no"
		)
		cmake_src_configure
	fi
}

multilib_src_compile() {
	if multilib_native_use python; then
		python_foreach_impl cmake_src_compile
	else
		cmake_src_compile
	fi
}

multilib_src_test() {
	# no tests on ABI_X86_32
	! multilib_is_native_abi && return

	# NOTE we don't run the tests
	use testprograms && return

	declare -xA OPENCV_SKIP_TESTS

	local -x OPENCV_SKIP_TESTS_core=(
		'hal_intrin128.*32x4_CPP_EMULATOR'
		'hal_intrin128.*64x2_CPP_EMULATOR'
	)

	local -x OPENCV_SKIP_TESTS_gapi=(
		'AsyncAPICancelation/cancel/*.basic'
	)

	local -x OPENCV_SKIP_TESTS_videoio=(
		'*mfx*'
		'videoio/videoio_bunny.frame_count/12'
	)

	local -x OPENCV_SKIP_TESTS_video=(
		'GOTURN.accuracy'
		'DaSiamRPN.accuracy'
		'NanoTrack.accuracy_NanoTrack_V1'
		'NanoTrack.accuracy_NanoTrack_V2'
		'Tracking/DistanceAndOverlap.GOTURN*'
	)

	if ! use gtk3 && ! use qt6; then
		local -x OPENCV_SKIP_TESTS_highgui=(
			'Highgui_GUI.*'
		)
	else
		addpredict /dev/fuse
	fi

	if multilib_native_use cuda; then
		local -x OPENCV_SKIP_TESTS_cudaoptflow=(
			'CUDA_OptFlow/BroxOpticalFlow.Regression/0'
			'CUDA_OptFlow/BroxOpticalFlow.OpticalFlowNan/0'
			'CUDA_OptFlow/NvidiaOpticalFlow_1_0.Regression/0'
			'CUDA_OptFlow/NvidiaOpticalFlow_2_0.Regression/0'
		)
		if use opengl; then
			local -x OPENCV_SKIP_TESTS_cudaarithm=(
				'OpenGL/Buffer.MapDevice/*'
				'OpenGL/*Gpu*'
			)
		fi
	fi

	if use contribdnn; then
		local -x OPENCV_SKIP_TESTS_dnn=(
			'Test_ONNX_layers.LSTM_cell_forward/*'
			'Test_ONNX_layers.LSTM_cell_bidirectional/*'
			'Test_TensorFlow_layers.Convolution3D/*'
			'Test_TensorFlow_layers.concat_3d/*'
		)
		local -x OPENCV_SKIP_TESTS_objdetect=(
			'Objdetect_face_detection.regression'
			'Objdetect_face_recognition.regression' 'Objdetect_QRCode_Encode_Decode_Structured_Append.regression'
		)
	else
		local -x OPENCV_SKIP_TESTS_objdetect=(
			'Objdetect_face_detection.regression'
			'Objdetect_face_recognition.regression'
			)

		OPENCV_SKIP_TESTS_video+=(
			'vittrack.accuracy_vittrack'
		)
	fi
	if use dnnsamples; then
		local -x OPENCV_SKIP_TESTS_wechat_qrcode=(
			'Objdetect_QRCode_points_position.rotate45'
			'Objdetect_QRCode_Big.regression'
			'Objdetect_QRCode_Tiny.regression'
			'Objdetect_QRCode_Multi.regression/*'
			'Objdetect_QRCode_Easy_Multi.regression/1'
		)
	fi

	if multilib_native_use cuda; then
		if ! SANDBOX_WRITE=/dev/nvidiactl test -w /dev/nvidiactl ; then
			eerror "Can't access the GPU at /dev/nvidiactl."
			eerror "User $(id -nu) is not in the group \"video\"."
			local -x TEST_CUDA="false"
			# local -x OPENCV_PARALLEL_BACKEND="threads"
			# local -x DNN_BACKEND_OPENCV="cuda"

			local -x OPENCV_SKIP_TESTS_photo=( "CUDA_*" )
			local -x OPENCV_SKIP_TESTS_stitching=( "CUDA_*" )
			OPENCV_SKIP_TESTS_video+=( "CUDA_*" )
		else
			cuda_add_sandbox -w
			addwrite "/dev/dri/"
			[[ -e /dev/udmabuf ]] && addwrite /dev/udmabuf
		fi
	fi

	opencv_test() {
		cd "${BUILD_DIR}" || die

		# directories to search for _core_ plugins
		local -x OPENCV_CORE_PLUGIN_PATH="${BUILD_DIR}/lib"
		# directories to search for _dnn_ plugins
		local -x OPENCV_DNN_PLUGIN_PATH="${BUILD_DIR}/lib"
		# directories to search for _videoio_ plugins
		local -x OPENCV_VIDEOIO_PLUGIN_PATH="${BUILD_DIR}/lib"
		# # path to extra OpenVINO plugins
		# local -x OPENCV_DNN_IE_EXTRA_PLUGIN_PATH="${BUILD_DIR}/lib"

		local -x OPENCV_TEMP_PATH="${T}"

		local -x OPENCV_TEST_DATA_PATH="${WORKDIR}/${PN}_extra-${PV}/testdata"

		local test_opts_base=(
			--skip_unstable=1
			--test_threads="$(makeopts_jobs)"
		)

		local results=()

		local tests
		readarray -t tests <<< "$(find "${BUILD_DIR}/bin" -name 'opencv_test_*')"

		for test in "${tests[@]}" ; do

			if [[ ${TEST_CUDA} == "false" && ${test} = *opencv_test_cu* ]] ; then
				eqawarn "Skipping test ${test}"
				continue
			fi

			local test_opts=(
				--gtest_color=yes
				--gtest_output="json:${BUILD_DIR}/test-reports/$(basename "${test}").json"
			)

			local testname
			testname="OPENCV_SKIP_TESTS_$(basename "${test//opencv_test_/}")[*]"
			if [[ -n "${!testname}" ]]; then
				test_opts+=(
					--gtest_filter="-$(IFS=':'; echo "${!testname}")"
				)
			fi

			einfo "${test} ${test_opts_base[*]} ${test_opts[*]}"
			if ! "${test}" "${test_opts_base[@]}" "${test_opts[@]}"; then
				results+=( "$(basename "${test}")" )

				if [[ -z "${OPENCV_TEST_CONTINUE_ON_FAIL}" ]]; then
					eerror "${results[*]} failed"
					die
				fi
			fi
		done

		if [[ -n "${results[*]}" ]]; then
			eerror "failed: ${results[*]}"
			die "${results[*]}"
		fi
	}

	if multilib_native_use python; then
		python_foreach_impl virtx opencv_test
	else
		virtx opencv_test
	fi
}

multilib_src_install() {
	if use abi_x86_64 && use abi_x86_32; then
		MULTILIB_WRAPPED_HEADERS=( # {{{
			# [opencv4]
			/usr/include/opencv4/opencv2/cvconfig.h
			/usr/include/opencv4/opencv2/opencv_modules.hpp

			/usr/include/opencv4/opencv2/core_detect.hpp

			/usr/include/opencv4/opencv2/cudaarithm.hpp
			/usr/include/opencv4/opencv2/cudabgsegm.hpp
			/usr/include/opencv4/opencv2/cudacodec.hpp
			/usr/include/opencv4/opencv2/cudafeatures2d.hpp
			/usr/include/opencv4/opencv2/cudafilters.hpp
			/usr/include/opencv4/opencv2/cudaimgproc.hpp
			/usr/include/opencv4/opencv2/cudalegacy.hpp
			/usr/include/opencv4/opencv2/cudalegacy/NCV.hpp
			/usr/include/opencv4/opencv2/cudalegacy/NCVBroxOpticalFlow.hpp
			/usr/include/opencv4/opencv2/cudalegacy/NCVHaarObjectDetection.hpp
			/usr/include/opencv4/opencv2/cudalegacy/NCVPyramid.hpp
			/usr/include/opencv4/opencv2/cudalegacy/NPP_staging.hpp
			/usr/include/opencv4/opencv2/cudaobjdetect.hpp
			/usr/include/opencv4/opencv2/cudaoptflow.hpp
			/usr/include/opencv4/opencv2/cudastereo.hpp
			/usr/include/opencv4/opencv2/cudawarping.hpp
			# [cudev]
			/usr/include/opencv4/opencv2/cudev.hpp
			/usr/include/opencv4/opencv2/cudev/block/block.hpp
			/usr/include/opencv4/opencv2/cudev/block/detail/reduce.hpp
			/usr/include/opencv4/opencv2/cudev/block/detail/reduce_key_val.hpp
			/usr/include/opencv4/opencv2/cudev/block/dynamic_smem.hpp
			/usr/include/opencv4/opencv2/cudev/block/reduce.hpp
			/usr/include/opencv4/opencv2/cudev/block/scan.hpp
			/usr/include/opencv4/opencv2/cudev/block/vec_distance.hpp
			/usr/include/opencv4/opencv2/cudev/common.hpp
			/usr/include/opencv4/opencv2/cudev/expr/binary_func.hpp
			/usr/include/opencv4/opencv2/cudev/expr/binary_op.hpp
			/usr/include/opencv4/opencv2/cudev/expr/color.hpp
			/usr/include/opencv4/opencv2/cudev/expr/deriv.hpp
			/usr/include/opencv4/opencv2/cudev/expr/expr.hpp
			/usr/include/opencv4/opencv2/cudev/expr/per_element_func.hpp
			/usr/include/opencv4/opencv2/cudev/expr/reduction.hpp
			/usr/include/opencv4/opencv2/cudev/expr/unary_func.hpp
			/usr/include/opencv4/opencv2/cudev/expr/unary_op.hpp
			/usr/include/opencv4/opencv2/cudev/expr/warping.hpp
			/usr/include/opencv4/opencv2/cudev/functional/color_cvt.hpp
			/usr/include/opencv4/opencv2/cudev/functional/detail/color_cvt.hpp
			/usr/include/opencv4/opencv2/cudev/functional/functional.hpp
			/usr/include/opencv4/opencv2/cudev/functional/tuple_adapter.hpp
			/usr/include/opencv4/opencv2/cudev/grid/copy.hpp
			/usr/include/opencv4/opencv2/cudev/grid/detail/copy.hpp
			/usr/include/opencv4/opencv2/cudev/grid/detail/histogram.hpp
			/usr/include/opencv4/opencv2/cudev/grid/detail/integral.hpp
			/usr/include/opencv4/opencv2/cudev/grid/detail/minmaxloc.hpp
			/usr/include/opencv4/opencv2/cudev/grid/detail/pyr_down.hpp
			/usr/include/opencv4/opencv2/cudev/grid/detail/pyr_up.hpp
			/usr/include/opencv4/opencv2/cudev/grid/detail/reduce.hpp
			/usr/include/opencv4/opencv2/cudev/grid/detail/reduce_to_column.hpp
			/usr/include/opencv4/opencv2/cudev/grid/detail/reduce_to_row.hpp
			/usr/include/opencv4/opencv2/cudev/grid/detail/split_merge.hpp
			/usr/include/opencv4/opencv2/cudev/grid/detail/transform.hpp
			/usr/include/opencv4/opencv2/cudev/grid/detail/transpose.hpp
			/usr/include/opencv4/opencv2/cudev/grid/histogram.hpp
			/usr/include/opencv4/opencv2/cudev/grid/integral.hpp
			/usr/include/opencv4/opencv2/cudev/grid/pyramids.hpp
			/usr/include/opencv4/opencv2/cudev/grid/reduce.hpp
			/usr/include/opencv4/opencv2/cudev/grid/reduce_to_vec.hpp
			/usr/include/opencv4/opencv2/cudev/grid/split_merge.hpp
			/usr/include/opencv4/opencv2/cudev/grid/transform.hpp
			/usr/include/opencv4/opencv2/cudev/grid/transpose.hpp
			/usr/include/opencv4/opencv2/cudev/ptr2d/constant.hpp
			/usr/include/opencv4/opencv2/cudev/ptr2d/deriv.hpp
			/usr/include/opencv4/opencv2/cudev/ptr2d/detail/gpumat.hpp
			/usr/include/opencv4/opencv2/cudev/ptr2d/extrapolation.hpp
			/usr/include/opencv4/opencv2/cudev/ptr2d/glob.hpp
			/usr/include/opencv4/opencv2/cudev/ptr2d/gpumat.hpp
			/usr/include/opencv4/opencv2/cudev/ptr2d/interpolation.hpp
			/usr/include/opencv4/opencv2/cudev/ptr2d/lut.hpp
			/usr/include/opencv4/opencv2/cudev/ptr2d/mask.hpp
			/usr/include/opencv4/opencv2/cudev/ptr2d/remap.hpp
			/usr/include/opencv4/opencv2/cudev/ptr2d/resize.hpp
			/usr/include/opencv4/opencv2/cudev/ptr2d/texture.hpp
			/usr/include/opencv4/opencv2/cudev/ptr2d/traits.hpp
			/usr/include/opencv4/opencv2/cudev/ptr2d/transform.hpp
			/usr/include/opencv4/opencv2/cudev/ptr2d/warping.hpp
			/usr/include/opencv4/opencv2/cudev/ptr2d/zip.hpp
			/usr/include/opencv4/opencv2/cudev/util/atomic.hpp
			/usr/include/opencv4/opencv2/cudev/util/detail/tuple.hpp
			/usr/include/opencv4/opencv2/cudev/util/detail/type_traits.hpp
			/usr/include/opencv4/opencv2/cudev/util/limits.hpp
			/usr/include/opencv4/opencv2/cudev/util/saturate_cast.hpp
			/usr/include/opencv4/opencv2/cudev/util/simd_functions.hpp
			/usr/include/opencv4/opencv2/cudev/util/tuple.hpp
			/usr/include/opencv4/opencv2/cudev/util/type_traits.hpp
			/usr/include/opencv4/opencv2/cudev/util/vec_math.hpp
			/usr/include/opencv4/opencv2/cudev/util/vec_traits.hpp
			/usr/include/opencv4/opencv2/cudev/warp/detail/reduce.hpp
			/usr/include/opencv4/opencv2/cudev/warp/detail/reduce_key_val.hpp
			/usr/include/opencv4/opencv2/cudev/warp/reduce.hpp
			/usr/include/opencv4/opencv2/cudev/warp/scan.hpp
			/usr/include/opencv4/opencv2/cudev/warp/shuffle.hpp
			/usr/include/opencv4/opencv2/cudev/warp/warp.hpp
			# [contribcvv]
			/usr/include/opencv4/opencv2/cvv.hpp
			/usr/include/opencv4/opencv2/cvv/call_meta_data.hpp
			/usr/include/opencv4/opencv2/cvv/cvv.hpp
			/usr/include/opencv4/opencv2/cvv/debug_mode.hpp
			/usr/include/opencv4/opencv2/cvv/dmatch.hpp
			/usr/include/opencv4/opencv2/cvv/filter.hpp
			/usr/include/opencv4/opencv2/cvv/final_show.hpp
			/usr/include/opencv4/opencv2/cvv/show_image.hpp
			# [contribdnn]
			/usr/include/opencv4/opencv2/dnn.hpp
			/usr/include/opencv4/opencv2/dnn/all_layers.hpp
			/usr/include/opencv4/opencv2/dnn/dict.hpp
			/usr/include/opencv4/opencv2/dnn/dnn.hpp
			/usr/include/opencv4/opencv2/dnn/dnn.inl.hpp
			/usr/include/opencv4/opencv2/dnn/layer.details.hpp
			/usr/include/opencv4/opencv2/dnn/layer.hpp
			/usr/include/opencv4/opencv2/dnn/shape_utils.hpp
			/usr/include/opencv4/opencv2/dnn/utils/debug_utils.hpp
			/usr/include/opencv4/opencv2/dnn/utils/inference_engine.hpp
			/usr/include/opencv4/opencv2/dnn/version.hpp
			/usr/include/opencv4/opencv2/dnn_superres.hpp
			# [contribhdf]
			/usr/include/opencv4/opencv2/hdf.hpp
			/usr/include/opencv4/opencv2/hdf/hdf5.hpp

			/usr/include/opencv4/opencv2/mcc.hpp
			/usr/include/opencv4/opencv2/mcc/ccm.hpp
			/usr/include/opencv4/opencv2/mcc/checker_detector.hpp
			/usr/include/opencv4/opencv2/mcc/checker_model.hpp

			/usr/include/opencv4/opencv2/text.hpp
			/usr/include/opencv4/opencv2/text/erfilter.hpp
			/usr/include/opencv4/opencv2/text/ocr.hpp
			/usr/include/opencv4/opencv2/text/swt_text_detection.hpp
			/usr/include/opencv4/opencv2/text/textDetector.hpp

			# [qt6]
			/usr/include/opencv4/opencv2/viz.hpp
			/usr/include/opencv4/opencv2/viz/types.hpp
			/usr/include/opencv4/opencv2/viz/viz3d.hpp
			/usr/include/opencv4/opencv2/viz/vizcore.hpp
			/usr/include/opencv4/opencv2/viz/widget_accessor.hpp
			/usr/include/opencv4/opencv2/viz/widgets.hpp

			/usr/include/opencv4/opencv2/wechat_qrcode.hpp
		) # }}}
	fi

	if multilib_native_use python; then
		python_foreach_impl cmake_src_install
		python_foreach_impl python_optimize
	else
		cmake_src_install
	fi

	for plugin in "${ED}/usr/$(get_libdir)/libopencv_"*".$(ver_rs 1-2 '' "$(ver_cut 1-2)").${ARCH}"* ; do
		patchelf --set-soname "$(basename "${plugin}" ".$(get_libname)")" "${plugin}"
	done
}
