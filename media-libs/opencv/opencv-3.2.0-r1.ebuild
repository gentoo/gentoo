# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python{2_7,3_4,3_5} )

inherit toolchain-funcs cmake-utils python-r1 java-pkg-opt-2 java-ant-2

DESCRIPTION="A collection of algorithms and sample code for various computer vision problems"
HOMEPAGE="http://opencv.org"

SRC_URI="https://github.com/${PN}/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz
	contrib? ( https://github.com/${PN}/${PN}_contrib/archive/${PV}.tar.gz -> ${P}_contrib.tar.gz
		contrib_xfeatures2d? ( http://dev.gentoo.org/~amynka/snap/vgg_boostdesc-${PV}.tar.gz ) )"
LICENSE="BSD"
SLOT="0/3.2" # subslot = libopencv* soname version
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86 ~amd64-linux"
IUSE="contrib cuda debug +eigen examples ffmpeg gdal gflags glog gphoto2 gstreamer gtk ieee1394 ipp jpeg jpeg2k lapack libav opencl openexr opengl openmp pch png +python qt5 tesseract testprograms threads tiff vaapi v4l vtk webp xine contrib_cvv contrib_hdf contrib_sfm contrib_xfeatures2d"

# OpenGL needs gtk or Qt installed to activate, otherwise build system
# will silently disable it without the user knowing, which defeats the
# purpose of the opengl use flag.
REQUIRED_USE="
	cuda? ( tesseract? ( opencl ) )
	gflags? ( contrib )
	glog? ( contrib )
	contrib_cvv? ( contrib qt5 )
	contrib_hdf? ( contrib )
	contrib_sfm? ( contrib eigen gflags glog )
	opengl? ( || ( gtk qt5 ) )
	python? ( ${PYTHON_REQUIRED_USE} )
	tesseract? ( contrib )"

# The following logic is intrinsic in the build system, but we do not enforce
# it on the useflags since this just blocks emerging pointlessly:
#	gtk? ( !qt5 )
#	openmp? ( !threads )

RDEPEND="
	app-arch/bzip2
	sys-libs/zlib
	cuda? ( dev-util/nvidia-cuda-toolkit:0= )
	contrib_hdf? ( sci-libs/hdf5 )
	ffmpeg? (
		libav? ( media-video/libav:0= )
		!libav? ( media-video/ffmpeg:0= )
	)
	gdal? ( sci-libs/gdal:= )
	gflags? ( dev-cpp/gflags )
	glog? ( dev-cpp/glog )
	gphoto2? ( media-libs/libgphoto2 )
	gstreamer? (
		media-libs/gstreamer:1.0
		media-libs/gst-plugins-base:1.0
	)
	gtk? (
		dev-libs/glib:2
		x11-libs/gtk+:2
		opengl? ( x11-libs/gtkglext )
	)
	ieee1394? (
		media-libs/libdc1394
		sys-libs/libraw1394
		)
	ipp? ( sci-libs/ipp )
	java? ( >=virtual/jre-1.6:* )
	jpeg? ( virtual/jpeg:0 )
	jpeg2k? ( media-libs/jasper:= )
	lapack? ( virtual/lapack )
	opencl? ( virtual/opencl )
	openexr? ( media-libs/openexr )
	opengl? ( virtual/opengl virtual/glu )
	png? ( media-libs/libpng:0= )
	python? ( ${PYTHON_DEPS} dev-python/numpy[${PYTHON_USEDEP}] )
	qt5? (
		dev-qt/qtgui:5
		dev-qt/qtwidgets:5
		dev-qt/qttest:5
		dev-qt/qtconcurrent:5
		opengl? ( dev-qt/qtopengl:5 )
	)
	tesseract? ( app-text/tesseract[opencl=] )
	threads? ( dev-cpp/tbb )
	tiff? ( media-libs/tiff:0 )
	v4l? ( >=media-libs/libv4l-0.8.3 )
	vtk? ( sci-libs/vtk[rendering] )
	webp? ( media-libs/libwebp )
	xine? ( media-libs/xine-lib )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	eigen? ( dev-cpp/eigen:3 )
	java?  ( >=virtual/jdk-1.6 )"

PATCHES=(
	"${FILESDIR}/${PN}-3.0.0-gles.patch"
	"${FILESDIR}/${PN}-3.1.0-java-magic.patch"
	"${FILESDIR}/${PN}-3.1.0-find-libraries-fix.patch"
	"${FILESDIR}/${P}-vtk.patch"
	"${FILESDIR}/${P}-gcc-6.0.patch"
)

pkg_pretend() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

pkg_setup() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
	java-pkg-opt-2_pkg_setup
}

src_prepare() {
	cmake-utils_src_prepare

	# remove bundled stuff
	rm -rf 3rdparty || die "Removing 3rd party components failed"
	sed -e '/add_subdirectory(.*3rdparty.*)/ d' \
		-i CMakeLists.txt cmake/*cmake || die

	if use contrib && use contrib_xfeatures2d; then
		cd  "${WORKDIR}/${PN}_contrib-${PV}" || die
		eapply "${FILESDIR}/${P}-contrib_xfeatures2d-autodownload.patch"
		mv "${WORKDIR}"/*.i "${WORKDIR}/${PN}_contrib-${PV}"/modules/xfeatures2d/src/ || die
	fi

	java-pkg-opt-2_src_prepare
}

src_configure() {
	JAVA_ANT_ENCODING="iso-8859-1"
	# set encoding so even this cmake build will pick it up.
	export ANT_OPTS+=" -Dfile.encoding=iso-8859-1"
	java-ant-2_src_configure

	# please dont sort here, order is the same as in CMakeLists.txt
	GLOBALCMAKEARGS=(
	# Optional 3rd party components
	# ===================================================
		-DWITH_1394=$(usex ieee1394)
	#	-DWITH_AVFOUNDATION=OFF 	# IOS
		-DWITH_VTK=$(usex vtk)
		-DWITH_EIGEN=$(usex eigen)
		-DWITH_VFW=OFF     		# Video windows support
		-DWITH_FFMPEG=$(usex ffmpeg)
		-DWITH_GSTREAMER=$(usex gstreamer)
		-DWITH_GSTREAMER_0_10=OFF	# Don't want this
		-DWITH_GTK=$(usex gtk)
		-DWITH_GTK_2_X=$(usex gtk)
		-DWITH_IPP=$(usex ipp)
		-DWITH_JASPER=$(usex jpeg2k)
		-DWITH_JPEG=$(usex jpeg)
		-DWITH_WEBP=$(usex webp)
		-DWITH_OPENEXR=$(usex openexr)
		-DWITH_OPENGL=$(usex opengl)
		-DWITH_OPENVX=OFF
		-DWITH_OPENNI=OFF 		# Not packaged
		-DWITH_OPENNI2=OFF 		# Not packaged
		-DWITH_PNG=$(usex png)
		-DWITH_GDCM=OFF
		-DWITH_PVAPI=OFF
		-DWITH_GIGEAPI=OFF
		-DWITH_ARAVIS=OFF
		-DWITH_QT=$(usex qt5 5 OFF)
		-DWITH_WIN32UI=OFF		# Windows only
	#	-DWITH_QUICKTIME=OFF
	#	-DWITH_QTKIT=OFF
		-DWITH_TBB=$(usex threads)
		-DWITH_OPENMP=$(usex openmp)
		-DWITH_CSTRIPES=OFF
		-DWITH_PTHREADS_PF=ON
		-DWITH_TIFF=$(usex tiff)
		-DWITH_UNICAP=OFF		# Not packaged
		-DWITH_V4L=$(usex v4l)
		-DWITH_LIBV4L=$(usex v4l)
		-DWITH_DSHOW=ON			# direct show supp
		-DWITH_MSMF=OFF
		-DWITH_XIMEA=OFF 		# Windows only
		-DWITH_XINE=$(usex xine)
		-DWITH_CLP=OFF
		-DWITH_OPENCL=$(usex opencl)
		-DWITH_OPENCL_SVM=OFF
		-DWITH_OPENCLAMDFFT=$(usex opencl)
		-DWITH_OPENCLAMDBLAS=$(usex opencl)
		-DWITH_DIRECTX=OFF
		-DWITH_INTELPERC=OFF
		-DWITH_JAVA=$(usex java) # Ant needed, no compile flag
		-DWITH_IPP_A=OFF
		-DWITH_MATLAB=OFF
		-DWITH_VA=$(usex vaapi)
		-DWITH_VA_INTEL=$(usex vaapi)
		-DWITH_GDAL=$(usex gdal)
		-DWITH_GPHOTO2=$(usex gphoto2)
		-DWITH_LAPACK=$(usex lapack)
	# ===================================================
	# CUDA build components: nvidia-cuda-toolkit takes care of GCC version
	# ===================================================
		-DWITH_CUDA=$(usex cuda)
		-DWITH_CUBLAS=$(usex cuda)
		-DWITH_CUFFT=$(usex cuda)
		-DWITH_NVCUVID=OFF
#		-DWITH_NVCUVID=$(usex cuda)
		-DCUDA_NPP_LIBRARY_ROOT_DIR=$(usex cuda "${EPREFIX}/opt/cuda" "")
	# ===================================================
	# OpenCV build components
	# ===================================================
		-DBUILD_SHARED_LIBS=ON
		-DBUILD_ANDROID_EXAMPLES=OFF
		-BUILD_opencv_apps=
		-DBUILD_DOCS=OFF # Doesn't install anyways.
		-DBUILD_EXAMPLES=$(usex examples)
		-DBUILD_PERF_TESTS=OFF
		-DBUILD_TESTS=$(usex testprograms)
		-DBUILD_WITH_DEBUG_INFO=$(usex debug)
	#	-DBUILD_WITH_STATIC_CRT=OFF
		-DBUILD_WITH_DYNAMIC_IPP=OFF
		-DBUILD_FAT_JAVA_LIB=$(usex java)
	#	-DBUILD_ANDROID_SERVICE=OFF
		-DBUILD_CUDA_STUBS=$(usex cuda)
		-DOPENCV_EXTRA_MODULES_PATH=$(usex contrib "${WORKDIR}/opencv_contrib-${PV}/modules" "")
	# ===================================================
	# OpenCV installation options
	# ===================================================
		-DINSTALL_CREATE_DISTRIB=OFF
		-DINSTALL_C_EXAMPLES=$(usex examples)
		-DINSTALL_TESTS=$(usex testprograms)
		-DINSTALL_PYTHON_EXAMPLES=$(usex examples)
	#	-DINSTALL_ANDROID_EXAMPLES=OFF
		-DINSTALL_TO_MANGLED_PATHS=OFF
	# ===================================================
	# OpenCV build options
	# ===================================================
		-DENABLE_CCACHE=OFF
		-DENABLE_PRECOMPILED_HEADERS=$(usex pch)
		-DENABLE_SOLUTION_FOLDERS=OFF
		-DENABLE_PROFILING=OFF
		-DENABLE_COVERAGE=OFF
		-DENABLE_OMIT_FRAME_POINTER=OFF
		-DENABLE_FAST_MATH=OFF
		-DENABLE_SSE=OFF
		-DENABLE_SSE2=OFF
		-DENABLE_SSE3=OFF
		-DENABLE_SSSE3=OFF
		-DENABLE_SSE41=OFF
		-DENABLE_SSE42=OFF
		-DENABLE_POPCNT=OFF
		-DENABLE_AVX=OFF
		-DENABLE_AVX=OFF
		-DENABLE_AVX2=OFF
		-DENABLE_FMA3=OFF
		-DENABLE_NEON=OFF

		-DHAVE_opencv_java=$(usex java YES NO)
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
		-DENABLE_PROFILING=OFF
	# ===================================================
	# things we want to be hard enabled not worth useflag
	# ===================================================
		-DCMAKE_SKIP_RPATH=ON
		-DOPENCV_DOC_INSTALL_PATH=
	)

	# ===================================================
	# OpenCV Contrib Modules
	# ===================================================
	if use contrib; then
		GLOBALCMAKEARGS+=(
			-DBUILD_opencv_dnn=OFF
			-DBUILD_opencv_dnns_easily_fooled=OFF
			-DBUILD_opencv_xfeatures2d=$(usex contrib_xfeatures2d ON OFF)
			-DBUILD_opencv_cvv=$(usex contrib_cvv ON OFF)
			-DBUILD_opencv_hdf=$(usex contrib_hdf ON OFF)
			-DBUILD_opencv_sfm=$(usex contrib_sfm ON OFF)
		)
	fi

	# workaround for bug 413429
	tc-export CC CXX

	local mycmakeargs=( ${GLOBALCMAKEARGS[@]}
		-DPYTHON_EXECUTABLE=OFF
		-DINSTALL_PYTHON_EXAMPLES=OFF
	)

	cmake-utils_src_configure
}

python_module_compile() {
	local mycmakeargs=( ${GLOBALCMAKEARGS[@]} )

	# Set all python variables to load the correct Gentoo paths
	mycmakeargs+=(
		# cheap trick: python_setup sets one of them as a symlink
		# to the correct interpreter, and the other to fail-wrapper
		-DPYTHON2_EXECUTABLE=$(type -P python2)
		-DPYTHON3_EXECUTABLE=$(type -P python3)
		-DINSTALL_PYTHON_EXAMPLES=$(usex examples)
	)

	# Compile and install all at once because configuration will be wiped
	# for each impl of Python
	BUILD_DIR="${WORKDIR}"/${P}_build
	cd "${BUILD_DIR}" || die "cd failed"

	# Regenerate cache file. Can't use rebuild_cache as it won't
	# have the Gentoo specific options.
	rm -rf CMakeCache.txt || die "rm failed"
	cmake-utils_src_configure
	cmake-utils_src_compile
	cmake-utils_src_install

	# Remove compiled binary so new version compiles
	# Avoid conflicts with new module builds as build system doesn't
	# really support it.
	rm -rf modules/python2 || die "rm failed"
}

src_install() {
	cmake-utils_src_install

	# Build and install the python modules for all targets
	use python && python_foreach_impl python_module_compile
}
