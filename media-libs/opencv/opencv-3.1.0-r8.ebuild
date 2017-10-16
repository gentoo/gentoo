# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python{2_7,3_4,3_5} )

inherit toolchain-funcs python-r1 java-pkg-opt-2 java-ant-2 \
	cmake-multilib

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
	app-arch/bzip2[${MULTILIB_USEDEP}]
	sys-libs/zlib[${MULTILIB_USEDEP}]
	cuda? ( dev-util/nvidia-cuda-toolkit:0= )
	ffmpeg? (
		libav? ( media-video/libav:0=[${MULTILIB_USEDEP}] )
		!libav? ( media-video/ffmpeg:0=[${MULTILIB_USEDEP}] )
	)
	gdal? ( sci-libs/gdal )
	gflags? ( dev-cpp/gflags[${MULTILIB_USEDEP}] )
	glog? ( dev-cpp/glog[${MULTILIB_USEDEP}] )
	gphoto2? ( media-libs/libgphoto2[${MULTILIB_USEDEP}] )
	gstreamer? (
		media-libs/gstreamer:1.0[${MULTILIB_USEDEP}]
		media-libs/gst-plugins-base:1.0[${MULTILIB_USEDEP}]
	)
	gtk? (
		dev-libs/glib:2[${MULTILIB_USEDEP}]
		x11-libs/gtk+:2[${MULTILIB_USEDEP}]
		opengl? ( x11-libs/gtkglext[${MULTILIB_USEDEP}] )
	)
	java? ( >=virtual/jre-1.6:* )
	jpeg? ( virtual/jpeg:0[${MULTILIB_USEDEP}] )
	jpeg2k? ( media-libs/jasper:=[${MULTILIB_USEDEP}] )
	ieee1394? (
		media-libs/libdc1394[${MULTILIB_USEDEP}]
		sys-libs/libraw1394[${MULTILIB_USEDEP}]
	)
	ipp? ( sci-libs/ipp )
	contrib_hdf? ( sci-libs/hdf5 )
	opencl? ( virtual/opencl[${MULTILIB_USEDEP}] )
	openexr? ( media-libs/openexr[${MULTILIB_USEDEP}] )
	opengl? (
		virtual/opengl[${MULTILIB_USEDEP}]
		virtual/glu[${MULTILIB_USEDEP}]
	)
	png? ( media-libs/libpng:0=[${MULTILIB_USEDEP}] )
	python? ( ${PYTHON_DEPS} dev-python/numpy[${PYTHON_USEDEP}] )
	qt5? (
		dev-qt/qtgui:5
		dev-qt/qtwidgets:5
		dev-qt/qttest:5
		dev-qt/qtconcurrent:5
		opengl? ( dev-qt/qtopengl:5 )
	)
	tesseract? ( app-text/tesseract[opencl=] )
	threads? ( dev-cpp/tbb[${MULTILIB_USEDEP}] )
	tiff? ( media-libs/tiff:0[${MULTILIB_USEDEP}] )
	v4l? ( >=media-libs/libv4l-0.8.3[${MULTILIB_USEDEP}] )
	vtk? ( sci-libs/vtk[rendering] )
	webp? ( media-libs/libwebp[${MULTILIB_USEDEP}] )
	xine? ( media-libs/xine-lib )"
DEPEND="${RDEPEND}
	virtual/pkgconfig[${MULTILIB_USEDEP}]
	eigen? ( dev-cpp/eigen:3 )
	java?  ( >=virtual/jdk-1.6 )"

MULTILIB_WRAPPED_HEADERS=(
	/usr/include/opencv2/cvconfig.h
	/usr/include/opencv2/opencv_modules.hpp
	# [contrib_cvv]
	/usr/include/opencv2/cvv.hpp
	/usr/include/opencv2/cvv/call_meta_data.hpp
	/usr/include/opencv2/cvv/cvv.hpp
	/usr/include/opencv2/cvv/debug_mode.hpp
	/usr/include/opencv2/cvv/dmatch.hpp
	/usr/include/opencv2/cvv/filter.hpp
	/usr/include/opencv2/cvv/final_show.hpp
	/usr/include/opencv2/cvv/show_image.hpp
	# [contrib_hdf]
	/usr/include/opencv2/hdf.hpp
	/usr/include/opencv2/hdf/hdf5.hpp
	# [vtk]
	/usr/include/opencv2/viz.hpp
	/usr/include/opencv2/viz/types.hpp
	/usr/include/opencv2/viz/viz3d.hpp
	/usr/include/opencv2/viz/vizcore.hpp
	/usr/include/opencv2/viz/widget_accessor.hpp
	/usr/include/opencv2/viz/widgets.hpp
)

PATCHES=(
	"${FILESDIR}"/${PN}-3.0.0-gles.patch
	"${FILESDIR}"/${P}-cmake-no-opengl.patch
	"${FILESDIR}"/${P}-git-autodetect.patch
	"${FILESDIR}"/${P}-java-magic.patch
	"${FILESDIR}"/${P}-remove-graphcut-for-cuda-8.patch
	"${FILESDIR}"/${P}-find-libraries-fix.patch
)

GLOBALCMAKEARGS=()

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

	java-pkg-opt-2_src_prepare

	# this really belongs in src_prepare() too
	JAVA_ANT_ENCODING="iso-8859-1"
	# set encoding so even this cmake build will pick it up.
	export ANT_OPTS+=" -Dfile.encoding=iso-8859-1"
	java-ant-2_src_configure
}

multilib_src_configure() {
	# please dont sort here, order is the same as in CMakeLists.txt
	GLOBALCMAKEARGS=(
	# Optional 3rd party components
	# ===================================================
		-DWITH_1394=$(usex ieee1394)
		-DWITH_AVFOUNDATION=OFF 	# IOS
		-DWITH_VTK=$(multilib_native_usex vtk)
		-DWITH_EIGEN=$(usex eigen)
		-DWITH_VFW=OFF     		# Video windows support
		-DWITH_FFMPEG=$(usex ffmpeg)
		-DWITH_GSTREAMER=$(usex gstreamer)
		-DWITH_GSTREAMER_0_10=OFF	# Don't want this
		-DWITH_GTK=$(usex gtk)
		-DWITH_GTK_2_X=$(usex gtk)
		-DWITH_IPP=$(multilib_native_usex ipp)
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
		-DWITH_QT=$(multilib_native_usex qt5 5 OFF)
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
		-DWITH_XINE=$(multilib_native_usex xine)
		-DWITH_CLP=OFF
		-DWITH_OPENCL=$(usex opencl)
		-DWITH_OPENCL_SVM=OFF
		-DWITH_OPENCLAMDFFT=$(usex opencl)
		-DWITH_OPENCLAMDBLAS=$(usex opencl)
		-DWITH_DIRECTX=OFF
		-DWITH_INTELPERC=OFF
		-DWITH_JAVA=$(multilib_native_usex java) # Ant needed, no compile flag
		-DWITH_IPP_A=OFF
		-DWITH_MATLAB=OFF
		-DWITH_VA=$(usex vaapi)
		-DWITH_VA_INTEL=$(usex vaapi)
		-DWITH_GDAL=$(multilib_native_usex gdal)
		-DWITH_GPHOTO2=$(usex gphoto2)
	# ===================================================
	# CUDA build components: nvidia-cuda-toolkit takes care of GCC version
	# ===================================================
		-DWITH_CUDA=$(multilib_native_usex cuda)
		-DWITH_CUBLAS=$(multilib_native_usex cuda)
		-DWITH_CUFFT=$(multilib_native_usex cuda)
		-DCUDA_NPP_LIBRARY_ROOT_DIR=$(usex cuda "${EPREFIX}/opt/cuda" "")
	# ===================================================
	# OpenCV build components
	# ===================================================
		-DBUILD_SHARED_LIBS=ON
		-DBUILD_ANDROID_EXAMPLES=OFF
		-DBUILD_DOCS=OFF # Doesn't install anyways.
		-DBUILD_EXAMPLES=$(multilib_native_usex examples)
		-DBUILD_PERF_TESTS=OFF
		-DBUILD_TESTS=$(multilib_native_usex testprograms)
		-DOPENCV_EXTRA_MODULES_PATH=$(usex contrib "${WORKDIR}/opencv_contrib-${CONTRIB_URI}/modules" "")
	# ===================================================
	# OpenCV installation options
	# ===================================================
		-DINSTALL_C_EXAMPLES=$(multilib_native_usex examples)
		-DINSTALL_TESTS=$(multilib_native_usex testprograms)
	# ===================================================
	# OpenCV build options
	# ===================================================
		-DENABLE_PRECOMPILED_HEADERS=$(usex pch)
		-DHAVE_opencv_java=$(multilib_native_usex java YES NO)
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
			-DBUILD_opencv_hdf=$(multilib_native_usex contrib_hdf ON OFF)
			-DBUILD_opencv_sfm=$(usex contrib_sfm ON OFF)
		)

		if multilib_is_native_abi; then
			GLOBALCMAKEARGS+=(
				-DCMAKE_DISABLE_FIND_PACKAGE_Tesseract=$(usex !tesseract)
			)
		else
			GLOBALCMAKEARGS+=(
				-DCMAKE_DISABLE_FIND_PACKAGE_Tesseract=ON
			)
		fi
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
	local BUILD_DIR=${orig_BUILD_DIR}
	local mycmakeargs=( ${GLOBALCMAKEARGS[@]} )

	# Set all python variables to load the correct Gentoo paths
	mycmakeargs+=(
		# upstream doesn't really care about 2/3, and if we don't
		# disable this, it builds python2 + python3 module for the same
		# version of Python 3 (i.e. two identical modules)...
		-DPYTHON3_EXECUTABLE=/bin/false
		-DINSTALL_PYTHON_EXAMPLES=$(usex examples)
	)

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

multilib_src_install() {
	cmake-utils_src_install

	# Build and install the python modules for all targets
	if multilib_is_native_abi && use python; then
		local orig_BUILD_DIR=${BUILD_DIR}
		python_foreach_impl python_module_compile
	fi
}
