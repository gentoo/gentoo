# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
PYTHON_COMPAT=( python{2_7,3_4,3_5} )

inherit toolchain-funcs cmake-utils python-r1 java-pkg-opt-2 java-ant-2

DESCRIPTION="A collection of algorithms and sample code for
	various computer vision problems"
HOMEPAGE="http://opencv.org"

BASE_URI="https://github.com/${PN}/${PN}"
#commit from Thu, 02 Jun 2016
CONTRIB_URI="75b3ea9f72fdb083140fc63855b7677d67748376"
CONTRIB_P="${P}_contrib-${CONTRIB_URI:0:7}"

SRC_URI="${BASE_URI}/archive/${PV}.tar.gz -> ${P}.tar.gz
	contrib? ( ${BASE_URI}_contrib/archive/${CONTRIB_URI}.tar.gz -> ${CONTRIB_P}.tar.gz )"
LICENSE="BSD"
SLOT="0/3.1" # subslot = libopencv* soname version
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86 ~amd64-linux"
IUSE="contrib cuda +eigen examples ffmpeg gdal gflags glog gphoto2 gstreamer gtk \
	ieee1394 ipp jpeg jpeg2k libav opencl openexr opengl openmp pch png \
	+python qt5 tesseract testprograms threads tiff vaapi v4l vtk webp xine \
	contrib_cvv contrib_hdf contrib_sfm"

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
	ffmpeg? (
		libav? ( media-video/libav:0= )
		!libav? ( media-video/ffmpeg:0= )
	)
	gdal? ( sci-libs/gdal )
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
	java? ( >=virtual/jre-1.6:* )
	jpeg? ( virtual/jpeg:0 )
	jpeg2k? ( media-libs/jasper )
	ieee1394? (
		media-libs/libdc1394
		sys-libs/libraw1394
	)
	ipp? ( sci-libs/ipp )
	contrib_hdf? ( sci-libs/hdf5 )
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
	"${FILESDIR}"/${PN}-3.0.0-gles.patch
	"${FILESDIR}"/${P}-cmake-no-opengl.patch
	"${FILESDIR}"/${P}-git-autodetect.patch
	"${FILESDIR}"/${P}-java-magic.patch
	"${FILESDIR}"/${P}-gentooify-python.patch
	"${FILESDIR}"/${P}-remove-graphcut-for-cuda-8.patch
	"${FILESDIR}"/${P}-find-libraries-fix.patch
)

GLOBALCMAKEARGS=()

pkg_pretend() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

pkg_setup() {
	java-pkg-opt-2_pkg_setup
}

src_prepare() {
	default

	# remove bundled stuff
	rm -rf 3rdparty || die "Removing 3rd party components failed"
	sed -e '/add_subdirectory(.*3rdparty.*)/ d' \
	    -i CMakeLists.txt cmake/*cmake || die

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
		-DWITH_AVFOUNDATION=OFF 	# IOS
		-DWITH_VTK=$(usex vtk)
		-DWITH_EIGEN=$(usex eigen)
		-DWITH_VFW=OFF     		# Video windows support
		-DWITH_FFMPEG=$(usex ffmpeg)
		-DWITH_GSTREAMER=$(usex gstreamer)
		-DWITH_GSTREAMER_0_10=OFF	# Don't want this
		-DWITH_GTK=$(usex gtk)
		-DWITH_GTK_2_X=OFF
		-DWITH_IPP=$(usex ipp)
		-DWITH_JASPER=$(usex jpeg2k)
		-DWITH_JPEG=$(usex jpeg)
		-DWITH_WEBP=$(usex webp)
		-DWITH_OPENEXR=$(usex openexr)
		-DWITH_OPENGL=$(usex opengl)
		-DWITH_OPENNI=OFF 		# Not packaged
		-DWITH_OPENNI2=OFF 		# Not packaged
		-DWITH_PNG=$(usex png)
		-DWITH_PVAPI=OFF		# Not packaged
		-DWITH_GIGEAPI=OFF
		-DWITH_QT=$(usex qt5 5 OFF)
		-DWITH_WIN32UI=OFF		# Windows only
		-DWITH_QUICKTIME=OFF
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
	# ===================================================
	# CUDA build components: nvidia-cuda-toolkit takes care of GCC version
	# ===================================================
		-DWITH_CUDA=$(usex cuda)
		-DWITH_CUBLAS=$(usex cuda)
		-DWITH_CUFFT=$(usex cuda)
		-DCUDA_NPP_LIBRARY_ROOT_DIR=$(usex cuda "${EPREFIX}/opt/cuda" "")
	# ===================================================
	# OpenCV build components
	# ===================================================
		-DBUILD_SHARED_LIBS=ON
		-DBUILD_ANDROID_EXAMPLES=OFF
		-DBUILD_DOCS=OFF # Doesn't install anyways.
		-DBUILD_EXAMPLES=$(usex examples)
		-DBUILD_PERF_TESTS=OFF
		-DBUILD_TESTS=$(usex testprograms)
		-DOPENCV_EXTRA_MODULES_PATH=$(usex contrib "${WORKDIR}/opencv_contrib-${CONTRIB_URI}/modules" "")
	# ===================================================
	# OpenCV installation options
	# ===================================================
		-DINSTALL_C_EXAMPLES=$(usex examples)
		-DINSTALL_TESTS=$(usex testprograms)
	# ===================================================
	# OpenCV build options
	# ===================================================
		-DENABLE_PRECOMPILED_HEADERS=$(usex pch)
		-DHAVE_opencv_java=$(usex java YES NO)
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
			-DBUILD_opencv_cvv=$(usex contrib_cvv ON OFF)
			-DBUILD_opencv_hdf=$(usex contrib_hdf ON OFF)
			-DBUILD_opencv_sfm=$(usex contrib_sfm ON OFF)
		)
	fi

	# workaround for bug 413429
	tc-export CC CXX

	local mycmakeargs=( ${GLOBALCMAKEARGS[@]}
			    -DWITH_PYTHON=OFF
			    -DINSTALL_PYTHON_EXAMPLES=OFF
	)

	cmake-utils_src_configure
}

python_module_compile() {
	local mycmakeargs=( ${GLOBALCMAKEARGS[@]} )

	# Set all python variables to load the correct Gentoo paths
	mycmakeargs+=(
		-DWITH_PYTHON=ON
		-DGENTOO_PYTHON_EXECUTABLE=${EPYTHON}
		-DGENTOO_PYTHON_INCLUDE_PATH="$(python_get_includedir)"
		-DGENTOO_PYTHON_LIBRARIES="$(python_get_library_path)"
		-DGENTOO_PYTHON_PACKAGES_PATH="$(python_get_sitedir)"
		-DGENTOO_PYTHON_MAJOR=${EPYTHON:6:1}
		-DGENTOO_PYTHON_MINOR=${EPYTHON:8:1}
		-DGENTOO_PYTHON_DEBUG_LIBRARIES=""
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
	emake -C modules/${EPYTHON:0:7} clean
	rm -rf modules/${EPYTHON:0:7} || die "rm failed"
}

src_install() {
	cmake-utils_src_install

	# Build and install the python modules for all targets
	use python && python_foreach_impl python_module_compile
}
