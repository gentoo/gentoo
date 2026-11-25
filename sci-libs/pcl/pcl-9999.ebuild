# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{12..14} )

inherit cmake cuda flag-o-matic python-any-r1 toolchain-funcs

if [[ ${PV} == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/PointCloudLibrary/pcl"
else
	SRC_URI="
		https://github.com/PointCloudLibrary/pcl/archive/${P}.tar.gz
	"
	S="${WORKDIR}/${PN}-${P}"
	KEYWORDS="~amd64 ~arm"
	CMAKE_QA_COMPAT_SKIP="true"
fi

DESCRIPTION="2D/3D image and point cloud processing"
HOMEPAGE="https://pointclouds.org/"

LICENSE="BSD"
SLOT="0/$(ver_cut 1-2)"
IUSE="apps cuda doc examples opengl openmp openni openni2 pcap png +qhull qt6 test tutorials usb vtk cpu_flags_x86_avx cpu_flags_x86_sse"

# vtk has a hard depend on png. so HAVE_PNG is true if you find vtk
REQUIRED_USE="
	openni? ( usb )
	openni2? ( usb )
	tutorials? ( doc )
	vtk? ( png qt6 )
	test? ( vtk )
"

RESTRICT="!test? ( test )"

RDEPEND="
	dev-cpp/eigen:=
	dev-libs/boost:=
	dev-libs/cJSON
	>=sci-libs/flann-1.7.1
	sci-libs/nanoflann
	virtual/zlib:=
	apps? (
		qt6? (
			dev-qt/qtbase:6[concurrent,gui,opengl]
			vtk? (
				sci-libs/vtk[qt6]
			)
		)
	)
	cuda? (
		dev-util/nvidia-cuda-toolkit:=
	)
	opengl? (
		media-libs/freeglut
		virtual/opengl
	)
	openni? (
		dev-libs/OpenNI
	)
	openni2? (
		dev-libs/OpenNI2
	)
	pcap? (
		net-libs/libpcap
	)
	png? (
		media-libs/libpng:=
	)
	qhull? (
		media-libs/qhull:=
	)
	usb? (
		virtual/libusb:1
	)
	vtk? (
		media-libs/glew:=
		sci-libs/vtk:=[imaging,rendering,views]
		virtual/glu
		x11-libs/libX11
	)
"
DEPEND="${RDEPEND}
	!!dev-cpp/metslib
	openmp? (
		|| (
			sys-devel/gcc[openmp]
			llvm-runtimes/clang-runtime[openmp]
		)
	)
	test? (
		dev-cpp/gtest
	)
"
# dev-texlive/texlive-latexextra for anyfontsize.sty
BDEPEND="
	doc? (
		app-text/doxygen[dot]
		$(python_gen_any_dep '
			dev-python/sphinxcontrib-doxylink[${PYTHON_USEDEP}]
		')
		virtual/latex-base
		dev-texlive/texlive-latexextra
	)
	tutorials? (
		$(python_gen_any_dep '
			dev-python/sphinx[${PYTHON_USEDEP}]
			dev-python/sphinx-rtd-theme[${PYTHON_USEDEP}]
			dev-python/sphinxcontrib-doxylink[${PYTHON_USEDEP}]
		')
	)
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}/${PN}-1.12.1-allow-configuration-of-install-dirs.patch"
	"${FILESDIR}/${PN}-1.12.1-fix-hardcoded-relative-directory-of-the-installed-cmake-files.patch"
	"${FILESDIR}/${PN}-1.14.1-tests.patch"
	"${FILESDIR}/${PN}-1.15.1-ASSERT_FLOAT_EQ.patch"
	"${FILESDIR}/${PN}-1.15.1-update-find-vtk.patch"
)

pkg_pretend() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

pkg_setup() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp

	if use doc || use tutorials; then
		python-any-r1_pkg_setup
	fi
}

python_check_deps() {
	{
		use doc &&
			python_has_version "dev-python/sphinxcontrib-doxylink[${PYTHON_USEDEP}]";
	} &&
	{
		use tutorials &&
			python_has_version \
				"dev-python/sphinx[${PYTHON_USEDEP}]" \
				"dev-python/sphinx-rtd-theme[${PYTHON_USEDEP}]" \
				"dev-python/sphinxcontrib-doxylink[${PYTHON_USEDEP}]" \
			;
	}
}

src_prepare() {
	if use cuda; then
		cuda_src_prepare
	fi

	cmake_src_prepare
}

src_configure() {
	append-flags -fno-strict-aliasing

	local mycmakeargs=(
		-DDOC_INSTALL_DIR="share/doc/${PF}"
		-DLIB_INSTALL_DIR="$(get_libdir)"

		# we are mixing static and shared libraries...
		-DCMAKE_POSITION_INDEPENDENT_CODE="yes"
		-DPCL_ALLOW_BOTH_SHARED_AND_STATIC_DEPENDENCIES="no"

		-DPCLCONFIG_INSTALL_DIR="share/cmake/${PN}-$(ver_cut 1-2)"

		-DBUILD_CUDA="$(usex cuda)"
		-DBUILD_GPU="$(usex cuda)"

		-DBUILD_apps="$(usex apps)"

		-DBUILD_benchmarks="no"

		-DBUILD_examples="$(usex examples)"
		-DBUILD_global_tests="$(usex test)"

		-DBUILD_simulation="yes"
		-DBUILD_surface="yes"
		-DBUILD_surface_on_nurbs="yes"
		-DBUILD_tools="yes"
		-DBUILD_tracking="yes"
		-DBUILD_visualization="$(usex vtk)"

		-DPCL_ENABLE_CCACHE="no"

		-DPCL_ENABLE_MARCHNATIVE="no"
		-DPCL_ENABLE_AVX="$(usex cpu_flags_x86_avx)"
		-DPCL_ENABLE_SSE="$(usex cpu_flags_x86_sse)"

		-DPCL_DISABLE_GPU_TESTS="$(usex !cuda)"
		-DPCL_DISABLE_VISUALIZATION_TESTS="$(usex !vtk)"

		-DWITH_CUDA="$(usex cuda)"
		-DWITH_DAVIDSDK="no"
		-DWITH_DOCS="$(usex doc)"
		-DWITH_DSSDK="no"
		-DWITH_ENSENSO="no"
		-DWITH_GLEW="yes"
		-DWITH_LIBUSB="$(usex usb)"
		-DWITH_OPENGL="$(usex opengl)"
		-DWITH_OPENMP="$(usex openmp)"
		-DWITH_OPENNI2="$(usex openni2)"
		-DWITH_OPENNI="$(usex openni)"
		-DWITH_PCAP="$(usex pcap)"
		-DWITH_PNG="$(usex png)"
		-DWITH_QHULL="$(usex qhull)"
		-DWITH_QT="$(usex qt6 QT6 NO)"
		-DWITH_RSSDK2="no"
		-DWITH_RSSDK="no"
		-DWITH_SYSTEM_CJSON="yes"
		-DWITH_SYSTEM_ZLIB="yes"
		-DWITH_TUTORIALS="$(usex tutorials)"
		-DWITH_VTK="$(usex vtk)"

		# TODO expects <suitesparse/cholmod.h> #979607
		# surface/src/on_nurbs/on_nurbs.cmake
		-DUSE_UMFPACK="no"
	)

	if use apps; then
		mycmakeargs+=(
			-DBUILD_apps_3d_rec_framework="$(usex vtk "$(usex openni)")"
			-DBUILD_apps_cloud_composer="yes"
			-DBUILD_apps_in_hand_scanner="$(usex qt6 "$(usex opengl "$(usex openni)")")"
			-DBUILD_apps_modeler="yes"
			-DBUILD_apps_point_cloud_editor="yes"
		)

		if use cuda; then
			mycmakeargs+=(
				-DBUILD_cuda_common="yes"
				-DBUILD_cuda_features="yes"
				-DBUILD_cuda_sample_consensus="yes"
				-DBUILD_cuda_segmentation="yes"

				-DBUILD_gpu_features="yes"
				-DBUILD_gpu_kinfu="no" # uses textures which was removed in CUDA 12
				-DBUILD_gpu_kinfu_large_scale="no" # uses textures which was removed in CUDA 12
				-DBUILD_gpu_people="no" # uses textures which was removed in CUDA 12
			)
		fi
	fi

	if use cuda; then
		mycmakeargs+=(
			-DBUILD_cuda_apps="$(usex openni "$(usex vtk)")" # Requires cuda_io.
			-DBUILD_cuda_io="$(usex openni)" # Requires external library openni.
			-DBUILD_gpu_surface="yes"
			-DBUILD_gpu_tracking="yes"
		)

		cuda_add_sandbox
		addpredict "/dev/char/"

		local -x CUDAHOSTCXX="$(cuda_gccdir)"

		if [[ -v CUDAARCHS ]]; then
			mycmakeargs+=(
				-DCUDA_ARCH_BIN="${CUDAARCHS}"
			)
		fi
	fi

	cmake_src_configure
}

src_test() {
	if use cuda; then
		cuda_add_sandbox -w
	fi

	BUILD_DIR="${BUILD_DIR}/test" cmake_src_test
}
