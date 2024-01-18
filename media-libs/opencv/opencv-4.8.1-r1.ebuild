# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )
inherit cuda java-pkg-opt-2 java-ant-2 cmake-multilib flag-o-matic python-r1 toolchain-funcs

DESCRIPTION="A collection of algorithms and sample code for various computer vision problems"
HOMEPAGE="https://opencv.org"

ADE_PV="0.1.2a" # branch master
QRCODE_COMMIT="a8b69ccc738421293254aec5ddb38bd523503252" # branch wechat_qrcode_20210119
DNN_SAMPLES_FACE_DETECTOR_COMMIT="b2bfc75f6aea5b1f834ff0f0b865a7c18ff1459f" # branch dnn_samples_face_detector_20170830
XFEATURES2D_BOOSTDESC_COMMIT="34e4206aef44d50e6bbcd0ab06354b52e7466d26" # branch contrib_xfeatures2d_boostdesc_20161012
XFEATURES2D_VGG_COMMIT="fccf7cd6a4b12079f73bbfb21745f9babcd4eb1d" # branch contrib_xfeatures2d_vgg_20160317
FACE_ALIGNMENT_COMMIT="8afa57abc8229d611c4937165d20e2a2d9fc5a12" # branch contrib_face_alignment_20170818
NVIDIA_OPTICAL_FLOW_COMMIT="edb50da3cf849840d680249aa6dbef248ebce2ca" # branch nvof_2_0_bsd

SRC_URI="https://github.com/${PN}/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/opencv/ade/archive/v${ADE_PV}.tar.gz -> ade-${ADE_PV}.tar.gz
	contrib? (
		https://github.com/${PN}/${PN}_contrib/archive/${PV}.tar.gz -> ${P}_contrib.tar.gz
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
	)
"

LICENSE="Apache-2.0"
SLOT="0/${PV}" # subslot = libopencv* soname version
KEYWORDS="amd64 ~arm arm64 ~loong ~ppc ~ppc64 ~riscv x86"
IUSE="contrib contribcvv contribdnn contribfreetype contribhdf contribovis contribsfm contribxfeatures2d cuda cudnn debug dnnsamples +eigen examples +features2d ffmpeg gdal gflags glog gphoto2 gstreamer gtk3 ieee1394 jpeg jpeg2k lapack non-free opencl openexr opengl openmp opencvapps png +python qt5 qt6 tesseract testprograms tbb tiff vaapi v4l vtk webp xine video_cards_intel"

# The following lines are shamelessly stolen from ffmpeg-9999.ebuild with modifications
ARM_CPU_FEATURES=(
	cpu_flags_arm_neon:NEON
	cpu_flags_arm_vfpv3:VFPV3
)
PPC_CPU_FEATURES=(
	cpu_flags_ppc_vsx:VSX
	cpu_flags_ppc_vsx3:VSX3
)
X86_CPU_FEATURES_RAW=(
	sse:SSE
	sse2:SSE2
	sse3:SSE3
	ssse3:SSSE3
	sse4_1:SSE4_1
	popcnt:POPCNT
	sse4_2:SSE4_2
	f16c:FP16
	fma3:FMA3
	avx:AVX
	avx2:AVX2
	avx512f:AVX_512F
)
X86_CPU_FEATURES=( ${X86_CPU_FEATURES_RAW[@]/#/cpu_flags_x86_} )
CPU_FEATURES_MAP=(
	${ARM_CPU_FEATURES[@]}
	${PPC_CPU_FEATURES[@]}
	${X86_CPU_FEATURES[@]}
)
IUSE="${IUSE} ${CPU_FEATURES_MAP[@]%:*}"

# OpenGL needs gtk or Qt installed to activate, otherwise build system
# will silently disable it without the user knowing, which defeats the
# purpose of the opengl use flag.
# cuda needs contrib, bug #701712
REQUIRED_USE="
	cpu_flags_x86_avx2? ( cpu_flags_x86_f16c )
	cpu_flags_x86_f16c? ( cpu_flags_x86_avx )
	cuda? (
		contrib
		tesseract? ( opencl )
	)
	cudnn? ( cuda )
	dnnsamples? ( examples )
	gflags? ( contrib )
	glog? ( contrib )
	contribcvv? ( contrib || ( qt5 qt6 ) )
	contribdnn? ( contrib )
	contribfreetype? ( contrib )
	contribhdf? ( contrib )
	contribovis? ( contrib )
	contribsfm? ( contrib eigen gflags glog )
	contribxfeatures2d? ( contrib )
	java? ( python )
	opengl? ( || ( qt5 qt6 ) )
	python? ( ${PYTHON_REQUIRED_USE} )
	tesseract? ( contrib )
	?? ( gtk3 || ( qt5 qt6 ) )
	?? ( cuda gdal )
	?? ( cuda openexr )
	?? ( cuda tbb )
"

# The following logic is intrinsic in the build system, but we do not enforce
# it on the useflags since this just blocks emerging pointlessly:
#	openmp? ( !tbb )

RDEPEND="
	app-arch/bzip2[${MULTILIB_USEDEP}]
	<dev-libs/protobuf-23:=[${MULTILIB_USEDEP}]
	sys-libs/zlib[${MULTILIB_USEDEP}]
	cuda? ( dev-util/nvidia-cuda-toolkit:0= )
	cudnn? ( dev-libs/cudnn:= )
	contribdnn? ( dev-libs/flatbuffers:= )
	contribhdf? ( sci-libs/hdf5:= )
	contribfreetype? (
		media-libs/freetype:2[${MULTILIB_USEDEP}]
		media-libs/harfbuzz:=[${MULTILIB_USEDEP}]
	)
	contribovis? ( >=dev-games/ogre-1.12:= )
	ffmpeg? ( media-video/ffmpeg:0=[${MULTILIB_USEDEP}] )
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
	java? ( >=virtual/jre-1.8:* )
	jpeg? ( media-libs/libjpeg-turbo:=[${MULTILIB_USEDEP}] )
	jpeg2k? ( media-libs/openjpeg:2=[${MULTILIB_USEDEP}] )
	lapack? (
		virtual/cblas
		>=virtual/lapack-3.10
		virtual/lapacke
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
		dev-python/numpy[${PYTHON_USEDEP}]
	)
	qt5? (
		dev-qt/qtgui:5
		dev-qt/qtwidgets:5
		dev-qt/qttest:5
		dev-qt/qtconcurrent:5
		opengl? ( dev-qt/qtopengl:5 )
	)
	!qt5? (
		qt6? (
			dev-qt/qtbase:6[gui,widgets,concurrent,opengl?]
		)
	)
	tesseract? ( app-text/tesseract[opencl=,${MULTILIB_USEDEP}] )
	tbb? ( dev-cpp/tbb:=[${MULTILIB_USEDEP}] )
	tiff? ( media-libs/tiff:=[${MULTILIB_USEDEP}] )
	v4l? ( >=media-libs/libv4l-0.8.3[${MULTILIB_USEDEP}] )
	vaapi? ( media-libs/libva[${MULTILIB_USEDEP}] )
	vtk? ( sci-libs/vtk:=[rendering,cuda=] )
	webp? ( media-libs/libwebp:=[${MULTILIB_USEDEP}] )
	xine? ( media-libs/xine-lib )"
DEPEND="${RDEPEND}
	eigen? ( >=dev-cpp/eigen-3.3.8-r1:3 )
	java? ( >=virtual/jdk-1.8:* )"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}/${PN}-3.4.0-disable-download.patch"
	"${FILESDIR}/${PN}-3.4.1-cuda-add-relaxed-constexpr.patch"
	"${FILESDIR}/${PN}-4.1.2-opencl-license.patch"
	"${FILESDIR}/${PN}-4.4.0-disable-native-cpuflag-detect.patch"
	"${FILESDIR}/${PN}-4.5.0-link-with-cblas-for-lapack.patch"
	"${FILESDIR}/${PN}-4.8.0-arm64-fp16.patch"
	"${FILESDIR}/${PN}-4.8.0-fix-cuda-12.2.0.patch"

	"${FILESDIR}/${PN}-4.8.1-use-system-flatbuffers.patch"
	"${FILESDIR}/${PN}-4.8.1-eliminate-lto-compiler-warnings.patch"
	"${FILESDIR}/${PN}-4.8.1-python3_12-support.patch"

	"${FILESDIR}/${PN}-4.8.1-use-system-opencl.patch"
	"${FILESDIR}/${PN}-4.8.1-opencv_test.patch"
	"${FILESDIR}/${PN}-4.8.1-drop-python2-detection.patch"
	"${FILESDIR}/${PN}-4.8.1-libpng16.patch"
	"${FILESDIR}/${PN}-4.8.1-ade-0.1.2a.tar.gz.patch"

	# TODO applied in src_prepare
	# "${FILESDIR}/${PN}_contrib-${PV}-rgbd.patch"
	# "${FILESDIR}/${PN}_contrib-4.8.1-NVIDIAOpticalFlowSDK-2.0.tar.gz.patch"
)

pkg_pretend() {
	if use cuda && [[ -z "${CUDA_GENERATION}" ]] && [[ -z "${CUDA_ARCH_BIN}" ]]; then
		einfo "The target CUDA architecture can be set via one of:"
		einfo "  - CUDA_GENERATION set to one of Maxwell, Pascal, Volta, Turing, Ampere, Lovelace, Hopper, Auto"
		einfo "  - CUDA_ARCH_BIN, (and optionally CUDA_ARCH_PTX) in the form of x.y tuples."
		einfo "      You can specify multiple tuple separated by \";\"."
		einfo ""
		einfo "The CUDA architecture tuple for your device can be found at https://developer.nvidia.com/cuda-gpus."
	fi

	if [[ ${MERGE_TYPE} == "buildonly" ]] && [[ -n "${CUDA_GENERATION}" || -n "${CUDA_ARCH_BIN}" ]]; then
		local info_message="When building a binary package it's recommended to unset CUDA_GENERATION and CUDA_ARCH_BIN"
		einfo "$info_message so all available architectures are build."
	fi

	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

pkg_setup() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
	use java && java-pkg-opt-2_pkg_setup
}

src_unpack() {
	unpack $(echo "${A}" | tr ' ' '\n' | grep -vP "(ade-0.1.2|NVIDIAOpticalFlowSDK)")
}

src_prepare() {
	if use cuda; then
		export CUDA_VERBOSE="$(usex debug "true" "false")"
		cuda_src_prepare
	fi

	cmake_src_prepare

	# remove bundled stuff
	rm -r 3rdparty || die "Removing 3rd party components failed"
	sed -e '/add_subdirectory(.*3rdparty.*)/ d' \
		-i CMakeLists.txt cmake/*cmake || die

	if use contrib; then
		cd "${WORKDIR}/${PN}_contrib-${PV}" || die
		eapply "${FILESDIR}/${PN}_contrib-${PV}-rgbd.patch"
		eapply "${FILESDIR}/${PN}_contrib-4.8.1-NVIDIAOpticalFlowSDK-2.0.tar.gz.patch"
		cd "${S}" || die

		! use contribcvv && { rm -R "${WORKDIR}/${PN}_contrib-${PV}/modules/cvv" || die; }
		# ! use contribdnn && { rm -R "${WORKDIR}/${PN}_contrib-${PV}/modules/dnn" || die; }
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
		for file in "face_landmark_model.dat"; do
			mv \
				"${WORKDIR}/${PN}_3rdparty-${FACE_ALIGNMENT_COMMIT}/${file}" \
				"${S}/.cache/data/$( \
					md5sum "${WORKDIR}/${PN}_3rdparty-${FACE_ALIGNMENT_COMMIT}/${file}" | cut -f 1 -d " " \
				)-${file}" || die
		done
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

		# this really belongs in src_prepare() too
		JAVA_ANT_ENCODING="iso-8859-1"
		# set encoding so even this cmake build will pick it up.
		export ANT_OPTS+=" -Dfile.encoding=iso-8859-1"
	fi
}

multilib_src_configure() {
	# bug #919101 and https://github.com/opencv/opencv/issues/19020
	filter-lto

	# please dont sort here, order is the same as in CMakeLists.txt
	local mycmakeargs=(
		-DMIN_VER_CMAKE=3.26

		-DCMAKE_POLICY_DEFAULT_CMP0146="OLD" # FindCUDA
		-DCMAKE_POLICY_DEFAULT_CMP0148="OLD" # FindPythonInterp

		# for protobuf
		-DCMAKE_CXX_STANDARD=14

	# Optional 3rd party components
	# ===================================================
		-DENABLE_DOWNLOAD=yes
		-DOPENCV_ENABLE_NONFREE=$(usex non-free)
		-DWITH_QUIRC=OFF # Do not have dependencies
		-DWITH_FLATBUFFERS=$(multilib_native_usex contribdnn)
		-DWITH_1394=$(usex ieee1394)
	#	-DWITH_AVFOUNDATION=OFF # IOS
		-DWITH_VTK=$(multilib_native_usex vtk)
		-DWITH_EIGEN=$(usex eigen)
		-DWITH_VFW=OFF # Video windows support
		-DWITH_FFMPEG=$(usex ffmpeg)
		-DWITH_GSTREAMER=$(usex gstreamer)
		-DWITH_GSTREAMER_0_10=OFF	# Don't want this
		-DWITH_GTK=$(usex gtk3)
		-DWITH_GTK_2_X=OFF # only want gtk3 nowadays
		-DWITH_IPP=OFF
		# Jasper was removed from tree because of security problems.
		# Upstream were/are making progress. We use openjpeg instead.
		# bug 734284
		-DWITH_JASPER=OFF
		-DWITH_JPEG=$(usex jpeg)
		-DWITH_OPENJPEG=$(usex jpeg2k)
		-DWITH_WEBP=$(usex webp)
		-DWITH_OPENEXR=$(multilib_native_usex openexr)
		-DWITH_OPENGL=$(usex opengl)
		-DOpenGL_GL_PREFERENCE="GLVND"
		-DWITH_OPENVX=OFF
		-DWITH_OPENNI=OFF	# Not packaged
		-DWITH_OPENNI2=OFF	# Not packaged
		-DWITH_PNG=$(usex png)
		-DWITH_GDCM=OFF
		-DWITH_PVAPI=OFF
		-DWITH_GIGEAPI=OFF
		-DWITH_ARAVIS=OFF
		-DWITH_WIN32UI=OFF		# Windows only
	#	-DWITH_QUICKTIME=OFF
	#	-DWITH_QTKIT=OFF
		-DWITH_TBB=$(usex tbb)
		-DWITH_OPENMP=$(usex !tbb $(usex openmp))
		-DWITH_CSTRIPES=OFF
		-DWITH_PTHREADS_PF=ON
		-DWITH_TIFF=$(usex tiff)
		-DWITH_UNICAP=OFF		# Not packaged
		-DWITH_V4L=$(usex v4l)
		-DWITH_LIBV4L=$(usex v4l)
	#	-DWITH_DSHOW=ON			# direct show supp
		-DWITH_MSMF=OFF
		-DWITH_XIMEA=OFF	# Windows only
		-DWITH_XINE=$(multilib_native_usex xine)
		-DWITH_CLP=OFF
		-DWITH_OPENCL=$(usex opencl)
		-DWITH_OPENCL_SVM=OFF
		-DWITH_OPENCLAMDFFT=$(usex opencl)
		-DWITH_OPENCLAMDBLAS=$(usex opencl)
		-DWITH_DIRECTX=OFF
		-DWITH_INTELPERC=OFF
		-DWITH_IPP_A=OFF
		-DWITH_MATLAB=OFF
		-DWITH_VA=$(usex vaapi)
		-DWITH_VA_INTEL=$(usex vaapi $(usex video_cards_intel))
		-DWITH_GDAL=$(multilib_native_usex gdal)
		-DWITH_GPHOTO2=$(usex gphoto2)
		-DWITH_LAPACK=$(multilib_native_usex lapack)
		-DWITH_ITT=OFF # 3dparty libs itt_notify
	# ===================================================
	# CUDA build components: nvidia-cuda-toolkit
	# ===================================================
		-DWITH_CUDA=$(multilib_native_usex cuda)
		-DWITH_CUBLAS=$(multilib_native_usex cuda)
		-DWITH_CUFFT=$(multilib_native_usex cuda)
		-DWITH_CUDNN=$(multilib_native_usex cudnn)
		-DWITH_NVCUVID="no"
		-DCUDA_NPP_LIBRARY_ROOT_DIR=$(usex cuda "${EPREFIX}/opt/cuda" "")
	# ===================================================
	# OpenCV build components
	# ===================================================
		-DBUILD_SHARED_LIBS=ON
		-DBUILD_JAVA=$(multilib_native_usex java) # Ant needed, no compile flag
		-DBUILD_ANDROID_EXAMPLES=OFF
		-DBUILD_opencv_apps=$(usex opencvapps ON OFF)
		-DBUILD_DOCS=OFF # Doesn't install anyways.
		-DBUILD_EXAMPLES=$(multilib_native_usex examples)
		-DBUILD_PERF_TESTS=OFF
		-DBUILD_TESTS=$(multilib_native_usex testprograms)
		-DBUILD_WITH_DEBUG_INFO=$(usex debug)
		-DOPENCV_ENABLE_MEMORY_SANITIZER=$(usex debug)
	#	-DBUILD_WITH_STATIC_CRT=OFF
		-DBUILD_WITH_DYNAMIC_IPP=OFF
		-DBUILD_FAT_JAVA_LIB=OFF
	#	-DBUILD_ANDROID_SERVICE=OFF
		-DBUILD_CUDA_STUBS=$(multilib_native_usex cuda)
		-DOPENCV_EXTRA_MODULES_PATH=$(usex contrib "${WORKDIR}/${PN}_contrib-${PV}/modules" "")
	# ===================================================
	# OpenCV installation options
	# ===================================================
		-DINSTALL_CREATE_DISTRIB=OFF
		-DINSTALL_C_EXAMPLES=$(multilib_native_usex examples)
		-DINSTALL_TESTS=$(multilib_native_usex testprograms)
		-DINSTALL_PYTHON_EXAMPLES=$(multilib_native_usex examples)
	#	-DINSTALL_ANDROID_EXAMPLES=OFF
		-DINSTALL_TO_MANGLED_PATHS=OFF
		-DOPENCV_GENERATE_PKGCONFIG=ON
		# opencv uses both ${CMAKE_INSTALL_LIBDIR} and ${LIB_SUFFIX}
		# to set its destination libdir
		-DLIB_SUFFIX=
	# ===================================================
	# OpenCV build options
	# ===================================================
		-DENABLE_CCACHE=OFF
		# bug 733796, but PCH is a risky game in CMake anyway
		-DENABLE_PRECOMPILED_HEADERS=OFF
		-DENABLE_SOLUTION_FOLDERS=OFF
		-DENABLE_PROFILING=OFF
		-DENABLE_COVERAGE=OFF

		-DHAVE_opencv_java=$(multilib_native_usex java YES NO)
		-DENABLE_NOISY_WARNINGS=OFF
		-DOPENCV_WARNINGS_ARE_ERRORS=OFF
		-DENABLE_IMPL_COLLECTION=OFF
		-DENABLE_INSTRUMENTATION=OFF
		-DGENERATE_ABI_DESCRIPTOR=OFF
		-DDOWNLOAD_EXTERNAL_TEST_DATA=OFF
	# ===================================================
	# things we want to be hard off or not yet figured out
	# ===================================================
		-DBUILD_PACKAGE=OFF
	# ===================================================
	# Not building protobuf but update files bug #631418
	# ===================================================
		-DWITH_PROTOBUF=ON
		-DBUILD_PROTOBUF=OFF
		-DPROTOBUF_UPDATE_FILES=ON
		-DProtobuf_MODULE_COMPATIBLE=ON
	# ===================================================
	# things we want to be hard enabled not worth useflag
	# ===================================================
		-DCMAKE_SKIP_RPATH=ON
		-DOPENCV_DOC_INSTALL_PATH=
		-DBUILD_opencv_features2d=$(usex features2d ON OFF)
	)

	if use qt5; then
		mycmakeargs+=(
			-DWITH_QT=$(multilib_native_usex qt5 ON OFF)
			-DCMAKE_DISABLE_FIND_PACKAGE_Qt6=ON
		)
	elif use qt6; then
		mycmakeargs+=(
			-DWITH_QT=$(multilib_native_usex qt6 ON OFF)
			-DCMAKE_DISABLE_FIND_PACKAGE_Qt5=ON
		)
	else
		mycmakeargs+=(
			-DWITH_QT=OFF
			-DCMAKE_DISABLE_FIND_PACKAGE_Qt5=ON
			-DCMAKE_DISABLE_FIND_PACKAGE_Qt6=ON
		)
	fi

	# ==================================================
	# cpu flags, should solve 633900
	#===================================================
	local CPU_BASELINE=""
	for i in "${CPU_FEATURES_MAP[@]}" ; do
		if [[ ${ABI} != x86 || ${i%:*} != "cpu_flags_x86_avx2" ]]; then # workaround for Bug 747163
			use ${i%:*} && CPU_BASELINE="${CPU_BASELINE}${i#*:};"
		fi
	done

	mycmakeargs+=(
		-DOPENCV_CPU_OPT_IMPLIES_IGNORE=ON
		-DCPU_BASELINE="${CPU_BASELINE}"
		-DCPU_DISPATCH=
	)

	# ===================================================
	# OpenCV Contrib Modules
	# ===================================================
	if use contrib; then
		mycmakeargs+=(
			-DBUILD_opencv_dnn=$(multilib_native_usex contribdnn ON OFF)
			-DBUILD_opencv_xfeatures2d=$(usex contribxfeatures2d ON OFF)
			-DBUILD_opencv_cvv=$(usex contribcvv ON OFF)
			-DBUILD_opencv_hdf=$(multilib_native_usex contribhdf ON OFF)
			-DBUILD_opencv_sfm=$(usex contribsfm ON OFF)
			-DBUILD_opencv_freetype=$(usex contribfreetype ON OFF)
			-DBUILD_opencv_ovis=$(usex contribovis ON OFF)
		)

		if multilib_is_native_abi; then
			mycmakeargs+=(
				-DCMAKE_DISABLE_FIND_PACKAGE_Tesseract=$(usex !tesseract)
			)
		else
			mycmakeargs+=(
				-DCMAKE_DISABLE_FIND_PACKAGE_Tesseract=ON
			)
		fi
	fi

	# workaround for bug 413429
	tc-export CC CXX

	if use cuda; then
		cuda_add_sandbox -w

		if [[ -n "${CUDA_GENERATION}" ]]; then
			mycmakeargs+=(
				-DCUDA_GENERATION="${CUDA_GENERATION}"
			)
		fi

		if [[ -n "${CUDA_ARCH_BIN}" ]]; then
				mycmakeargs+=(
					-DCUDA_ARCH_BIN="${CUDA_ARCH_BIN}"
				)

			if [[ -n "${CUDA_ARCH_PTX}" ]]; then
				mycmakeargs+=(
					-DCUDA_ARCH_PTX="${CUDA_ARCH_PTX}"
				)
			fi
		fi

		local NVCCFLAGS_OpenCV="${NVCCFLAGS// /\;}"
		mycmakeargs+=(
			-DOPENCV_CUDA_DETECTION_NVCC_FLAGS="-ccbin=$(cuda_gccdir)"
			-DCUDA_NVCC_FLAGS="-forward-unknown-opts;${NVCCFLAGS_OpenCV//\"/}"
		)

		use vtk && mycmakeargs+=(
			-DCMAKE_CUDA_FLAGS="-forward-unknown-opts ${NVCCFLAGS//\;/ }"
		)
	fi

	if multilib_is_native_abi && use python; then
		python_configure() {
			# Set all python variables to load the correct Gentoo paths
			local mycmakeargs=(
				"${mycmakeargs[@]}"
				# python_setup alters PATH and sets this as wrapper
				# to the correct interpreter we are building for
				-DPYTHON_DEFAULT_EXECUTABLE="${EPYTHON}"
				-DINSTALL_PYTHON_EXAMPLES="$(usex examples)"
			)
			cmake_src_configure
			use java && java-ant-2_src_configure
		}

		python_foreach_impl python_configure
	else
		mycmakeargs+=(
			-DPYTHON_EXECUTABLE=OFF
			-DINSTALL_PYTHON_EXAMPLES=OFF
			-DBUILD_opencv_python2=OFF
			-DBUILD_opencv_python3=OFF
		)
		cmake_src_configure
		use java && java-ant-2_src_configure
	fi

}

multilib_src_compile() {
	if multilib_is_native_abi && use python; then
		python_foreach_impl cmake_src_compile
	else
		cmake_src_compile
	fi
}

multilib_src_install() {
	if use abi_x86_64 && use abi_x86_32; then
		MULTILIB_WRAPPED_HEADERS=(
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

			# [qt5,qt6]
			/usr/include/opencv4/opencv2/viz.hpp
			/usr/include/opencv4/opencv2/viz/types.hpp
			/usr/include/opencv4/opencv2/viz/viz3d.hpp
			/usr/include/opencv4/opencv2/viz/vizcore.hpp
			/usr/include/opencv4/opencv2/viz/widget_accessor.hpp
			/usr/include/opencv4/opencv2/viz/widgets.hpp

			/usr/include/opencv4/opencv2/wechat_qrcode.hpp
		)
	fi
	if multilib_is_native_abi && use python; then
		python_foreach_impl cmake_src_install
		python_foreach_impl python_optimize
	else
		cmake_src_install
	fi
}
