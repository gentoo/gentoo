# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 python3_{6,7} )

inherit java-pkg-opt-2 java-ant-2 python-r1 toolchain-funcs cmake-multilib

DESCRIPTION="A collection of algorithms and sample code for various computer vision problems"
HOMEPAGE="https://opencv.org"
TINY_DNN_PV="1.0.0a3"
SRC_URI="https://github.com/${PN}/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz
	dnnsamples? ( https://dev.gentoo.org/~amynka/snap/${PN}-3.4.0-res10_300x300-caffeemodel.tar.gz )
	contrib? (
		https://github.com/${PN}/${PN}_contrib/archive/${PV}.tar.gz -> ${P}_contrib.tar.gz
		contribdnn? ( https://dev.gentoo.org/~amynka/snap/${PN}-3.4.0-face_landmark_model.tar.gz )
		contribxfeatures2d? ( https://dev.gentoo.org/~amynka/snap/vgg_boostdesc-3.2.0.tar.gz )
	)"

LICENSE="BSD"
SLOT="0/4.1.2" # subslot = libopencv* soname version
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86 ~amd64-linux"
IUSE="contrib contribcvv contribdnn contribhdf contribsfm contribxfeatures2d cpu_flags_x86_sse cpu_flags_x86_sse2 cpu_flags_x86_sse3 cpu_flags_x86_ssse3 cpu_flags_x86_sse4_1 cpu_flags_x86_sse4_2 cpu_flags_x86_popcnt cpu_flags_x86_avx cpu_flags_x86_avx2 cpu_flags_x86_fma3 cuda debug dnnsamples -download +eigen examples +features2d ffmpeg gdal gflags glog gphoto2 gstreamer gtk ieee1394 jpeg jpeg2k lapack libav opencl openexr opengl openmp opencvapps pch png +python qt5 tesseract testprograms threads tiff vaapi v4l vtk webp xine"
# OpenGL needs gtk or Qt installed to activate, otherwise build system
# will silently disable it Wwithout the user knowing, which defeats the
# purpose of the opengl use flag.
REQUIRED_USE="
	cuda? ( tesseract? ( opencl ) )
	dnnsamples? ( examples )
	gflags? ( contrib )
	glog? ( contrib )
	contribcvv? ( contrib qt5 )
	contribdnn? ( contrib )
	contribhdf? ( contrib )
	contribsfm? ( contrib eigen gflags glog )
	contribxfeatures2d? ( contrib download )
	java? ( python )
	opengl? ( || ( gtk qt5 ) )
	python? ( ${PYTHON_REQUIRED_USE} )
	tesseract? ( contrib )"

# The following logic is intrinsic in the build system, but we do not enforce
# it on the useflags since this just blocks emerging pointlessly:
#	gtk? ( !qt5 )
#	openmp? ( !threads )

RDEPEND="
	app-arch/bzip2[${MULTILIB_USEDEP}]
	dev-libs/protobuf:=[${MULTILIB_USEDEP}]
	sys-libs/zlib[${MULTILIB_USEDEP}]
	cuda? ( dev-util/nvidia-cuda-toolkit:0= )
	contribhdf? ( sci-libs/hdf5:= )
	ffmpeg? (
		libav? ( media-video/libav:0=[${MULTILIB_USEDEP}] )
		!libav? ( media-video/ffmpeg:0=[${MULTILIB_USEDEP}] )
	)
	gdal? ( sci-libs/gdal:= )
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
	ieee1394? (
		media-libs/libdc1394[${MULTILIB_USEDEP}]
		sys-libs/libraw1394[${MULTILIB_USEDEP}]
	)
	java? ( >=virtual/jre-1.6:* )
	jpeg? ( virtual/jpeg:0[${MULTILIB_USEDEP}] )
	lapack? ( virtual/lapack )
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
	java?  ( >=virtual/jdk-1.6 )
	vaapi?  ( x11-libs/libva )"

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
	# [cudev]
	/usr/include/opencv2/cudaarithm.hpp
	/usr/include/opencv2/cudabgsegm.hpp
	/usr/include/opencv2/cudacodec.hpp
	/usr/include/opencv2/cudafeatures2d.hpp
	/usr/include/opencv2/cudafilters.hpp
	/usr/include/opencv2/cudaimgproc.hpp
	/usr/include/opencv2/cudalegacy.hpp
	/usr/include/opencv2/cudalegacy/NCVBroxOpticalFlow.hpp
	/usr/include/opencv2/cudalegacy/NCVHaarObjectDetection.hpp
	/usr/include/opencv2/cudalegacy/NCV.hpp
	/usr/include/opencv2/cudalegacy/NCVPyramid.hpp
	/usr/include/opencv2/cudalegacy/NPP_staging.hpp
	/usr/include/opencv2/cudaobjdetect.hpp
	/usr/include/opencv2/cudaoptflow.hpp
	/usr/include/opencv2/cudastereo.hpp
	/usr/include/opencv2/cudawarping.hpp
	/usr/include/opencv2/cudev/block/block.hpp
	/usr/include/opencv2/cudev/block/detail/reduce.hpp
	/usr/include/opencv2/cudev/block/detail/reduce_key_val.hpp
	/usr/include/opencv2/cudev/block/dynamic_smem.hpp
	/usr/include/opencv2/cudev/block/reduce.hpp
	/usr/include/opencv2/cudev/block/scan.hpp
	/usr/include/opencv2/cudev/block/vec_distance.hpp
	/usr/include/opencv2/cudev/common.hpp
	/usr/include/opencv2/cudev/expr/binary_func.hpp
	/usr/include/opencv2/cudev/expr/binary_op.hpp
	/usr/include/opencv2/cudev/expr/color.hpp
	/usr/include/opencv2/cudev/expr/deriv.hpp
	/usr/include/opencv2/cudev/expr/expr.hpp
	/usr/include/opencv2/cudev/expr/per_element_func.hpp
	/usr/include/opencv2/cudev/expr/reduction.hpp
	/usr/include/opencv2/cudev/expr/unary_func.hpp
	/usr/include/opencv2/cudev/expr/unary_op.hpp
	/usr/include/opencv2/cudev/expr/warping.hpp
	/usr/include/opencv2/cudev/functional/color_cvt.hpp
	/usr/include/opencv2/cudev/functional/detail/color_cvt.hpp
	/usr/include/opencv2/cudev/functional/functional.hpp
	/usr/include/opencv2/cudev/functional/tuple_adapter.hpp
	/usr/include/opencv2/cudev/grid/copy.hpp
	/usr/include/opencv2/cudev/grid/detail/copy.hpp
	/usr/include/opencv2/cudev/grid/detail/histogram.hpp
	/usr/include/opencv2/cudev/grid/detail/integral.hpp
	/usr/include/opencv2/cudev/grid/detail/minmaxloc.hpp
	/usr/include/opencv2/cudev/grid/detail/pyr_down.hpp
	/usr/include/opencv2/cudev/grid/detail/pyr_up.hpp
	/usr/include/opencv2/cudev/grid/detail/reduce.hpp
	/usr/include/opencv2/cudev/grid/detail/reduce_to_column.hpp
	/usr/include/opencv2/cudev/grid/detail/reduce_to_row.hpp
	/usr/include/opencv2/cudev/grid/detail/split_merge.hpp
	/usr/include/opencv2/cudev/grid/detail/transform.hpp
	/usr/include/opencv2/cudev/grid/detail/transpose.hpp
	/usr/include/opencv2/cudev/grid/histogram.hpp
	/usr/include/opencv2/cudev/grid/integral.hpp
	/usr/include/opencv2/cudev/grid/pyramids.hpp
	/usr/include/opencv2/cudev/grid/reduce.hpp
	/usr/include/opencv2/cudev/grid/reduce_to_vec.hpp
	/usr/include/opencv2/cudev/grid/split_merge.hpp
	/usr/include/opencv2/cudev/grid/transform.hpp
	/usr/include/opencv2/cudev/grid/transpose.hpp
	/usr/include/opencv2/cudev.hpp
	/usr/include/opencv2/cudev/ptr2d/constant.hpp
	/usr/include/opencv2/cudev/ptr2d/deriv.hpp
	/usr/include/opencv2/cudev/ptr2d/detail/gpumat.hpp
	/usr/include/opencv2/cudev/ptr2d/extrapolation.hpp
	/usr/include/opencv2/cudev/ptr2d/glob.hpp
	/usr/include/opencv2/cudev/ptr2d/gpumat.hpp
	/usr/include/opencv2/cudev/ptr2d/interpolation.hpp
	/usr/include/opencv2/cudev/ptr2d/lut.hpp
	/usr/include/opencv2/cudev/ptr2d/mask.hpp
	/usr/include/opencv2/cudev/ptr2d/remap.hpp
	/usr/include/opencv2/cudev/ptr2d/resize.hpp
	/usr/include/opencv2/cudev/ptr2d/texture.hpp
	/usr/include/opencv2/cudev/ptr2d/traits.hpp
	/usr/include/opencv2/cudev/ptr2d/transform.hpp
	/usr/include/opencv2/cudev/ptr2d/warping.hpp
	/usr/include/opencv2/cudev/ptr2d/zip.hpp
	/usr/include/opencv2/cudev/util/atomic.hpp
	/usr/include/opencv2/cudev/util/detail/tuple.hpp
	/usr/include/opencv2/cudev/util/detail/type_traits.hpp
	/usr/include/opencv2/cudev/util/limits.hpp
	/usr/include/opencv2/cudev/util/saturate_cast.hpp
	/usr/include/opencv2/cudev/util/simd_functions.hpp
	/usr/include/opencv2/cudev/util/tuple.hpp
	/usr/include/opencv2/cudev/util/type_traits.hpp
	/usr/include/opencv2/cudev/util/vec_math.hpp
	/usr/include/opencv2/cudev/util/vec_traits.hpp
	/usr/include/opencv2/cudev/warp/detail/reduce.hpp
	/usr/include/opencv2/cudev/warp/detail/reduce_key_val.hpp
	/usr/include/opencv2/cudev/warp/reduce.hpp
	/usr/include/opencv2/cudev/warp/scan.hpp
	/usr/include/opencv2/cudev/warp/shuffle.hpp
	/usr/include/opencv2/cudev/warp/warp.hpp
	# [opencv4]
	/usr/include/opencv4/opencv2/core/cv_cpu_dispatch.h
	/usr/include/opencv4/opencv2/core/cvdef.h
	/usr/include/opencv4/opencv2/dnn.hpp
	/usr/include/opencv4/opencv2/core/cuda/transform.hpp
	/usr/include/opencv4/opencv2/core/opencl/runtime/opencl_core.hpp
	/usr/include/opencv4/opencv2/cvconfig.h
	/usr/include/opencv4/opencv2/core/utils/allocator_stats.impl.hpp
	/usr/include/opencv4/opencv2/video/tracking.hpp
	/usr/include/opencv4/opencv2/objdetect.hpp
)

PATCHES=(
	"${FILESDIR}/${PN}-3.0.0-gles.patch"
	"${FILESDIR}/${PN}-3.4.0-disable-download.patch"
	"${FILESDIR}/${PN}-3.4.1-cuda-add-relaxed-constexpr.patch"
	"${FILESDIR}/${P}-pkg-config-file.patch"
	"${FILESDIR}/${P}-opencl-license.patch"
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

	if use dnnsamples; then
		mv  "${WORKDIR}/res10_300x300_ssd_iter_140000.caffemodel" "${WORKDIR}/${P}/samples/dnn/" || die
	fi

	if use contrib; then
		cd  "${WORKDIR}/${PN}_contrib-${PV}" || die
		if use contribxfeatures2d; then
			mv "${WORKDIR}"/*.i "${WORKDIR}/${PN}_contrib-${PV}"/modules/xfeatures2d/src/ || die
		fi
	fi

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
		-DENABLE_DOWNLOAD=$(usex download)
		-DWITH_QUIRC=OFF # Do not have dependencies
		-DWITH_1394=$(usex ieee1394)
	#	-DWITH_AVFOUNDATION=OFF # IOS
		-DWITH_VTK=$(multilib_native_usex vtk)
		-DWITH_EIGEN=$(usex eigen)
		-DWITH_VFW=OFF # Video windows support
		-DWITH_FFMPEG=$(usex ffmpeg)
		-DWITH_GSTREAMER=$(usex gstreamer)
		-DWITH_GSTREAMER_0_10=OFF	# Don't want this
		-DWITH_GTK=$(usex gtk)
		-DWITH_GTK_2_X=$(usex gtk)
		-DWITH_IPP=OFF
		-DWITH_JASPER=OFF
		-DWITH_JPEG=$(usex jpeg)
		-DWITH_WEBP=$(usex webp)
		-DWITH_OPENEXR=$(usex openexr)
		-DWITH_OPENGL=$(usex opengl)
		-DWITH_OPENVX=OFF
		-DWITH_OPENNI=OFF	# Not packaged
		-DWITH_OPENNI2=OFF	# Not packaged
		-DWITH_PNG=$(usex png)
		-DWITH_GDCM=OFF
		-DWITH_PVAPI=OFF
		-DWITH_GIGEAPI=OFF
		-DWITH_ARAVIS=OFF
		-DWITH_QT=$(multilib_native_usex qt5 5 OFF)
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
		#-DWITH_DSHOW=ON			# direct show supp
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
		-DWITH_VA_INTEL=$(usex vaapi)
		-DWITH_GDAL=$(multilib_native_usex gdal)
		-DWITH_GPHOTO2=$(usex gphoto2)
		-DWITH_LAPACK=$(multilib_native_usex lapack)
		-DWITH_ITT=OFF # 3dparty libs itt_notify
	# ===================================================
	# CUDA build components: nvidia-cuda-toolkit takes care of GCC version
	# ===================================================
		-DWITH_CUDA=$(multilib_native_usex cuda)
		-DWITH_CUBLAS=$(multilib_native_usex cuda)
		-DWITH_CUFFT=$(multilib_native_usex cuda)
		-DWITH_NVCUVID=OFF
#		-DWITH_NVCUVID=$(usex cuda)
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
	#	-DBUILD_WITH_STATIC_CRT=OFF
		-DBUILD_WITH_DYNAMIC_IPP=OFF
		-DBUILD_FAT_JAVA_LIB=OFF
	#	-DBUILD_ANDROID_SERVICE=OFF
		-DBUILD_CUDA_STUBS=$(multilib_native_usex cuda)
		-DOPENCV_EXTRA_MODULES_PATH=$(usex contrib "${WORKDIR}/opencv_contrib-${PV}/modules" "")
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
		-DENABLE_PRECOMPILED_HEADERS=$(usex pch)
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
		-DBUILD_PROTOBUF=OFF
		-DPROTOBUF_UPDATE_FILES=ON
	# ===================================================
	# things we want to be hard enabled not worth useflag
	# ===================================================
		-DCMAKE_SKIP_RPATH=ON
		-DOPENCV_DOC_INSTALL_PATH=
	# ==================================================
	# cpu flags, should solve 633900
	#===================================================
		-DOPENCV_CPU_OPT_IMPLIES_IGNORE=ON
		-DCPU_BASELINE=$(printf "%s," "${cpu_flags[@]}")
		-DCPU_DISPATCH=
		-DBUILD_opencv_features2d=$(usex features2d ON OFF)
	)

	# ===================================================
	# OpenCV Contrib Modules
	# ===================================================
	if use contrib; then
		GLOBALCMAKEARGS+=(
			-DBUILD_opencv_dnn=$(usex contribdnn ON OFF)
			-DTINYDNN_ROOT="${WORKDIR}/tiny-dnn-${TINY_DNN_PV}"
			-DBUILD_opencv_dnns_easily_fooled=OFF
			-DBUILD_opencv_xfeatures2d=$(usex contribxfeatures2d ON OFF)
			-DBUILD_opencv_cvv=$(usex contribcvv ON OFF)
			-DBUILD_opencv_hdf=$(multilib_native_usex contribhdf ON OFF)
			-DBUILD_opencv_sfm=$(usex contribsfm ON OFF)
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
		-DBUILD_opencv_python2=OFF
		-DBUILD_opencv_python3=OFF
	)

	cmake-utils_src_configure

	# Copy face_land_model to ${CMAKE_BINARY_DIR}/${OPENCV_TEST_DATA_INSTALL_PATH}
	# TODO patch ocv_download to copy files into destination dirs
	if use contribdnn; then
		mkdir -p "${BUILD_DIR}"/share/OpenCV/testdata/cv/face/ || die
		cp "${WORKDIR}"/face_landmark_model.dat "${BUILD_DIR}"/share/OpenCV/testdata/cv/face/ || die
	fi

}

python_module_compile() {
	local BUILD_DIR=${orig_BUILD_DIR}
	local mycmakeargs=( ${GLOBALCMAKEARGS[@]} )

	# Set all python variables to load the correct Gentoo paths
	mycmakeargs+=(
		# python_setup alters PATH and sets this as wrapper
		# to the correct interpreter we are building for
		-DPYTHON_DEFAULT_EXECUTABLE=python
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
