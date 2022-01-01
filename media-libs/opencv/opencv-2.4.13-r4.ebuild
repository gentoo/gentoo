# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 )

inherit toolchain-funcs cmake-utils python-single-r1 java-pkg-opt-2 java-ant-2

DESCRIPTION="A collection of algorithms and sample code for various computer vision problems"
HOMEPAGE="https://opencv.org"

SRC_URI="https://github.com/Itseez/opencv/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0/2.4"
KEYWORDS="amd64 ~arm ~ppc ~ppc64 x86 ~amd64-linux"
IUSE="cuda +eigen examples ffmpeg gstreamer gtk ieee1394 jpeg opencl openexr opengl openmp pch png +python qt5 testprograms threads tiff v4l vtk xine"

REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

# The following logic is intrinsic in the build system, but we do not enforce
# it on the useflags since this just blocks emerging pointlessly:
#	gtk? ( !qt4 )
#	opengl? ( || ( gtk qt4 ) )
#	openmp? ( !threads )

RDEPEND="
	app-arch/bzip2
	sys-libs/zlib
	cuda? ( >=dev-util/nvidia-cuda-toolkit-5.5 )
	ffmpeg? ( media-video/ffmpeg:0= )
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
	ieee1394? (
		media-libs/libdc1394
		sys-libs/libraw1394
	)
	opencl? ( virtual/opencl )
	openexr? ( media-libs/openexr )
	opengl? ( virtual/opengl virtual/glu )
	png? ( media-libs/libpng:0= )
	python? (
		${PYTHON_DEPS}
		$(python_gen_cond_dep '
			|| (
				dev-python/numpy-python2[${PYTHON_MULTI_USEDEP}]
				dev-python/numpy[${PYTHON_MULTI_USEDEP}]
			)
		')
	)
	qt5? (
		dev-qt/qtconcurrent:5
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qttest:5
		opengl? ( dev-qt/qtopengl:5 )
	)
	threads? ( dev-cpp/tbb )
	tiff? ( media-libs/tiff:0 )
	v4l? ( >=media-libs/libv4l-0.8.3 )
	vtk? ( sci-libs/vtk[rendering] )
	xine? ( media-libs/xine-lib )
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	eigen? ( dev-cpp/eigen:3 )
	java? ( >=virtual/jdk-1.6 )
"

PATCHES=(
	"${FILESDIR}/${PN}-2.3.1a-libav-0.7.patch"
	"${FILESDIR}/${PN}-2.4.3-gcc47.patch"
	"${FILESDIR}/${PN}-2.4.2-cflags.patch"
	"${FILESDIR}/${PN}-2.4.8-javamagic.patch"
	"${FILESDIR}/${PN}-2.4.9-cuda-pkg-config.patch"
	"${FILESDIR}/${PN}-3.0.0-gles.patch"
	"${FILESDIR}/${P}-gcc-6.0.patch"
	"${FILESDIR}/${P}-imgcodecs-refactoring.patch" #bug 627958
)

pkg_setup() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
	use python && python-single-r1_pkg_setup
	java-pkg-opt-2_pkg_setup
}

src_prepare() {
	cmake-utils_src_prepare

	# remove bundled stuff
	rm -rf 3rdparty || die "Removing 3rd party components failed"
	sed -i \
		-e '/add_subdirectory(3rdparty)/ d' \
		CMakeLists.txt || die

	java-pkg-opt-2_src_prepare
}

src_configure() {

	JAVA_ANT_ENCODING="iso-8859-1"
	# set encoding so even this cmake build will pick it up.
	export ANT_OPTS+=" -Dfile.encoding=iso-8859-1"
	java-ant-2_src_configure

	# please dont sort here, order is the same as in CMakeLists.txt
	local mycmakeargs=(
	# the optinal dependency libraries
		-DWITH_1394=$(usex ieee1394)
		-DWITH_AVFOUNDATION=OFF
		-DWITH_VTK=$(usex vtk)
		-DWITH_EIGEN=$(usex eigen)
		-DWITH_VFW=OFF
		-DWITH_FFMPEG=$(usex ffmpeg)
		-DWITH_GSTREAMER=$(usex gstreamer)
		-DWITH_GSTREAMER_0_10=OFF
		-DWITH_GTK=$(usex gtk)
		-DWITH_IMAGEIO=OFF
		-DWITH_IPP=OFF
		-DWITH_JASPER=OFF
		-DWITH_JPEG=$(usex jpeg)
		-DWITH_OPENEXR=$(usex openexr)
		-DWITH_OPENGL=$(usex opengl)
		-DWITH_OPENCL=$(usex opencl)
		-DWITH_OPENNI=OFF
		-DWITH_PNG=$(usex png)
		-DWITH_PVAPI=OFF
		-DWITH_QT=$(usex qt5 5 OFF)
		-DWITH_GIGEAPI=OFF
		-DWITH_WIN32UI=OFF
		-DWITH_QUICKTIME=OFF
		-DWITH_TBB=$(usex threads)
		-DWITH_OPENMP=$(usex openmp)
		-DWITH_CSTRIPES=OFF
		-DWITH_TIFF=$(usex tiff)
		-DWITH_UNICAP=OFF
		-DWITH_V4L=$(usex v4l)
		-DWITH_LIBV4L=$(usex v4l)
		-DWITH_DSHOW=ON
		-DWITH_MSMF=OFF
		-DWITH_XIMEA=OFF
		-DWITH_XINE=$(usex xine)
		-DWITH_OPENCL=$(usex opencl)
		-DWITH_OPENCLAMDFFT=$(usex opencl)
		-DWITH_OPENCLAMDBLAS=$(usex opencl)
		-DWITH_INTELPERC=OFF
		-DWITH_JAVA=$(usex java)

		# the build components
		-DBUILD_SHARED_LIBS=ON
		-DBUILD_ANDROID_EXAMPLES=OFF
		-DBUILD_DOCS=OFF #too much dark magic in cmakelists
		-DBUILD_EXAMPLES=$(usex examples)
		-DBUILD_PERF_TESTS=OFF
		-DBUILD_TESTS=$(usex testprograms)

		# install examples
		-DINSTALL_C_EXAMPLES=$(usex examples)
		-DINSTALL_TESTS=$(usex testprograms)

		# build options
		-DENABLE_PRECOMPILED_HEADERS=$(usex pch)
		-DENABLE_SOLUTION_FOLDERS=OFF
		-DENABLE_PROFILING=OFF
		-DENABLE_COVERAGE=OFF
		-DENABLE_OMIT_FRAME_POINTER=OFF
		-DENABLE_FAST_MATH=OFF					#
		-DENABLE_SSE=OFF					# these options do nothing but
		-DENABLE_SSE2=OFF					# add params to CFLAGS
		-DENABLE_SSE3=OFF
		-DENABLE_SSSE3=OFF
		-DENABLE_SSE41=OFF
		-DENABLE_SSE42=OFF

		-DOPENCV_EXTRA_FLAGS_RELEASE=""				# black magic
	)

	if use cuda; then
		if [[ "$(gcc-version)" > "4.8" ]]; then
			# bug 577410
			# #error -- unsupported GNU version! gcc 4.9 and up are not supported!
			ewarn "CUDA and >=sys-devel/gcc-4.9 do not play well together. Disabling CUDA support."
			mycmakeargs+=( -DWITH_CUDA=OFF )
			mycmakeargs+=( -DWITH_CUBLAS=OFF )
			mycmakeargs+=( -DWITH_CUFFT=OFF )

		else
			mycmakeargs+=( -DWITH_CUDA=ON )
			mycmakeargs+=( -DWITH_CUBLAS=ON )
			mycmakeargs+=( -DWITH_CUFFT=ON )
			mycmakeargs+=( -DCUDA_NPP_LIBRARY_ROOT_DIR=/opt/cuda )
		fi
	else
		mycmakeargs+=( -DWITH_CUDA=OFF )
		mycmakeargs+=( -DWITH_CUBLAS=OFF )
		mycmakeargs+=( -DWITH_CUFFT=OFF )
	fi

	if use examples && use python; then
		mycmakeargs+=( -DINSTALL_PYTHON_EXAMPLES=ON )
	else
		mycmakeargs+=( -DINSTALL_PYTHON_EXAMPLES=OFF )
	fi

	# things we want to be hard off or not yet figured out
	mycmakeargs+=(
		-DOPENCV_BUILD_3RDPARTY_LIBS=OFF
		-DBUILD_PACKAGE=OFF
	)

	# things we want to be hard enabled not worth useflag
	mycmakeargs+=(
		-DCMAKE_SKIP_RPATH=ON
		-DOPENCV_DOC_INSTALL_PATH=
	)

	# workaround for bug 413429
	tc-export CC CXX

	cmake-utils_src_configure
}
