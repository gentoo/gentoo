# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake flag-o-matic virtualx

DESCRIPTION="Development platform for CAD/CAE, 3D surface/solid modeling and data exchange"
HOMEPAGE="https://www.opencascade.com"

MY_PN="OCCT"

MY_TEST_PV="7.8.0"
MY_TEST_PV2="${MY_TEST_PV//./_}"

SRC_URI="
	test? ( https://github.com/Open-Cascade-SAS/${MY_PN}/releases/download/V${MY_TEST_PV2}/${PN}-dataset-${MY_TEST_PV}.tar.xz )
"

if [[ ${PV} = *9999* ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/Open-Cascade-SAS/${MY_PN}.git"
else
	MY_PV="${PV//./_}"
	SRC_URI+="
		https://github.com/Open-Cascade-SAS/${MY_PN}/archive/refs/tags/V${MY_PV}.tar.gz -> ${P}.tar.gz
	"
	S="${WORKDIR}/${MY_PN}-${MY_PV}"
	KEYWORDS="~amd64 ~arm ~arm64 ~riscv ~x86"
fi

LICENSE="|| ( Open-CASCADE-LGPL-2.1-Exception-1.0 LGPL-2.1 )"
SLOT="0/$(ver_cut 1-2)"
IUSE="X debug doc examples ffmpeg freeimage freetype gles2-only +gui jemalloc json +opengl optimize tbb test testprograms tk vtk"

REQUIRED_USE="
	?? ( optimize tbb )
	?? ( opengl gles2-only )
	test? ( freeimage json opengl )
"

# There's no easy way to test. Testing needs a rather big environment properly set up.
RESTRICT="!test? ( test )"

# ffmpeg: https://tracker.dev.opencascade.org/view.php?id=32871
RDEPEND="
	dev-lang/tcl:=
	tk? ( dev-lang/tk:= )
	dev-libs/double-conversion
	freetype? (
		media-libs/fontconfig
		media-libs/freetype:2
	)
	opengl? (
		media-libs/libglvnd
	)
	X? (
		x11-libs/libX11
	)
	gui? (
		examples? (
			dev-qt/qtcore:5
			dev-qt/qtgui:5
			dev-qt/qtquickcontrols2:5
			dev-qt/qtwidgets:5
			dev-qt/qtxml:5
		)
	)
	ffmpeg? ( <media-video/ffmpeg-5:= )
	freeimage? ( media-libs/freeimage )
	jemalloc? ( dev-libs/jemalloc )
	tbb? ( dev-cpp/tbb:= )
	vtk? (
		sci-libs/vtk:=[rendering]
		tbb? (
			sci-libs/vtk:=[tbb,-cuda]
		)
	)
"
DEPEND="
	${RDEPEND}
	X? ( x11-base/xorg-proto )
	json? ( dev-libs/rapidjson )
"
BDEPEND="
	doc? ( app-text/doxygen[dot] )
	gui? (
		examples? ( dev-qt/linguist-tools:5 )
	)
	test? ( dev-tcltk/thread )
"

PATCHES=(
	"${FILESDIR}/${PN}-7.5.1-0005-fix-write-permissions-on-scripts.patch"
	"${FILESDIR}/${PN}-7.5.1-0006-fix-creation-of-custom.sh-script.patch"
	"${FILESDIR}/${PN}-7.7.0-fix-installation-of-cmake-config-files.patch"
	"${FILESDIR}/${PN}-7.7.0-avoid-pre-stripping-binaries.patch"
	"${FILESDIR}/${PN}-7.7.0-build-against-vtk-9.2.patch"
	"${FILESDIR}/${PN}-7.7.0-musl.patch"
	"${FILESDIR}/${PN}-7.7.0-jemalloc-lib-type.patch"
	"${FILESDIR}/${PN}-7.8.0-cmake-min-version.patch"
	"${FILESDIR}/${PN}-7.8.0-tests.patch"
)

src_unpack() {
	if [[ ${PV} = *9999* ]] ; then
		git-r3_src_unpack
	else
		unpack "${P}.tar.gz"
	fi

	if use test; then
		mkdir "${WORKDIR}/data"
		pushd "${WORKDIR}/data" > /dev/null || die
		# should be in paths indicated by CSF_TestDataPath environment variable,
		# or in subfolder data in the script directory
		unpack "${PN}-dataset-${MY_TEST_PV}.tar.xz"
		popd > /dev/null || die
	fi
}

src_prepare() {
	cmake_src_prepare

	sed -e 's|/lib\$|/'"$(get_libdir)"'\$|' \
		-i adm/templates/OpenCASCADEConfig.cmake.in || die

	# There is an OCCT_UPDATE_TARGET_FILE cmake macro that fails due to some
	# assumptions it makes about installation paths. Rather than fixing it, just
	# get rid of the mechanism altogether - its purpose is to allow a
	# side-by-side installation of release and debug libraries.
	sed -e 's|\\${OCCT_INSTALL_BIN_LETTER}||' \
		-i adm/cmake/occt_toolkit.cmake || die
}

src_configure() {
	# -Werror=odr
	# https://bugs.gentoo.org/862912
	# https://tracker.dev.opencascade.org/view.php?id=33091
	filter-lto

	local mycmakeargs=(
		-D3RDPARTY_DIR="${ESYSROOT}/usr"
		-DBUILD_CPP_STANDARD="C++17"
		-DBUILD_SOVERSION_NUMBERS=2

		-DBUILD_DOC_Overview="$(usex doc)"
		-DBUILD_Inspector="$(usex gui)"

		-DBUILD_ENABLE_FPE_SIGNAL_HANDLER="$(usex debug)"
		-DBUILD_USE_PCH="no"
		# -DBUILD_OPT_PROFILE="Default" # Production
		# -DBUILD_RESOURCES="yes"
		# -DBUILD_YACCLEX="yes"

		-DBUILD_RELEASE_DISABLE_EXCEPTIONS="no" # bug #847916
		-DINSTALL_DIR="${EPREFIX}/usr"
		-DINSTALL_DIR_BIN="$(get_libdir)/${PN}/bin"
		-DINSTALL_DIR_CMAKE="$(get_libdir)/cmake/${PN}"
		-DINSTALL_DIR_DATA="share/${PN}/data"
		-DINSTALL_DIR_DOC="share/doc/${PF}"
		-DINSTALL_DIR_INCLUDE="include/${PN}"
		-DINSTALL_DIR_LIB="$(get_libdir)/${PN}"
		-DINSTALL_DIR_RESOURCE="share/${PN}/resources"
		-DINSTALL_DIR_SAMPLES="share/${PN}/samples"
		-DINSTALL_DIR_SCRIPT="$(get_libdir)/${PN}/bin"
		-DINSTALL_DIR_TESTS="share/${PN}/tests"
		-DINSTALL_DIR_WITH_VERSION="no"
		-DINSTALL_SAMPLES="$(usex examples)"

		-DINSTALL_TEST_CASES="$(usex testprograms)"

		# no package yet in tree
		-DUSE_DRACO="no"
		-DUSE_FFMPEG="$(usex ffmpeg)"
		-DUSE_FREEIMAGE="$(usex freeimage)"
		-DUSE_FREETYPE="$(usex freetype)"
		# Indicates whether OpenGL ES 2.0 should be used in OCCT visualization module
		-DUSE_GLES2="$(usex gles2-only)"
		# Indicates whether OpenGL desktop should be used in OCCT visualization module
		-DUSE_OPENGL="$(usex opengl)"
		# no package in tree
		-DUSE_OPENVR="no"
		-DUSE_RAPIDJSON="$(usex json)"
		-DUSE_TBB="$(usex tbb)"
		-DUSE_TK="$(usex tk)"
		-DUSE_VTK="$(usex vtk)"
		-DUSE_XLIB="$(usex X)"
	)

	# Select using memory manager tool.
	if ! use jemalloc && ! use tbb; then
		mycmakeargs+=( -DUSE_MMGR_TYPE=NATIVE )
	elif use jemalloc && ! use tbb; then
		mycmakeargs+=( -DUSE_MMGR_TYPE=JEMALLOC )
	elif ! use jemalloc && use tbb; then
		mycmakeargs+=( -DUSE_MMGR_TYPE=TBB )
	elif use jemalloc && use tbb; then
		mycmakeargs+=( -DUSE_MMGR_TYPE=FLEXIBLE )
	fi

	if use doc; then
		mycmakeargs+=(
			-DINSTALL_DOC_Overview="yes"
			-D3RDPARTY_SKIP_DOT_EXECUTABLE="no"
		)
	fi

	if use gui; then
		mycmakeargs+=(
			-D3RDPARTY_QT_DIR="${ESYSROOT}/usr"
			-DBUILD_SAMPLES_QT="$(usex examples)"
		)
	fi

	if use jemalloc; then
		mycmakeargs+=(
			-D3RDPARTY_JEMALLOC_INCLUDE_DIR="${ESYSROOT}/usr/include/jemalloc"
		)
	fi

	if use tbb; then
		mycmakeargs+=(
			-D3RDPARTY_TBB_DIR="${ESYSROOT}/usr"
		)
	fi

	if use vtk; then
		local vtk_ver
		vtk_ver="$(best_version "sci-libs/vtk")"
		vtk_ver=$(ver_cut 1-2 "${vtk_ver#sci-libs/vtk-}")
		mycmakeargs+=(
			-D3RDPARTY_VTK_INCLUDE_DIR="${ESYSROOT}/usr/include/vtk-${vtk_ver}"
			-D3RDPARTY_VTK_LIBRARY_DIR="${ESYSROOT}/usr/$(get_libdir)"
		)
	fi

	cmake_src_configure

	sed -e "s|lib/|$(get_libdir)/|" \
		-e "s|VAR_CASROOT|${EPREFIX}/usr|" \
		< "${FILESDIR}/${PN}.env.in" > "${T}/99${PN}" || die

	# use TBB for memory allocation optimizations
	if use tbb; then
		sed -e 's|^#MMGT_OPT=0$|MMGT_OPT=2|' -i "${T}/99${PN}" || die
	fi

	# use internal optimized memory manager and don't clear memory with this
	# memory manager.
	if use optimize ; then
		sed -e 's|^#MMGT_OPT=0$|MMGT_OPT=1|' \
			-e 's|^#MMGT_CLEAR=1$|MMGT_CLEAR=0|' \
			-i "${T}/99${PN}" || die
	fi
}

src_test() {
	echo "export CSF_OCCTDataPath=${WORKDIR}/data" >> "${BUILD_DIR}/custom.sh" || die

	if has_version media-fonts/dejavu; then
		cp "${ESYSROOT}/usr/share/fonts/dejavu/DejaVuSans.ttf" "${WORKDIR}/data/" # no die here as this isn't fatal
	fi

	local test_file=${T}/testscript.tcl

	local draw_opts=(
		i # see ${BUILD_DIR}/custom*.sh
		# -b # batch mode (no GUI, no viewers)
		-v # no GUI, use virtual (off-screen) windows for viewers
	)

	local test_names=(
		"demo draw bug30430" # prone to dying due to cpu limit
	)
	local test_opts=( # run single tests
		-overwrite
	)
	for test_name in "${test_names[@]}"; do
		cat >> "${test_file}" <<- _EOF_ || die
			test ${test_name} -outfile "${BUILD_DIR}/test_results/${test_name// /\/}.html" ${test_opts[@]}
		_EOF_
	done

	local testgrid_opts=()

	local SKIP_TESTS=()

	if [[ "${OCCT_OPTIONAL_TESTS}" != "true" ]]; then
		SKIP_TESTS+=(
			'blend complex F4'
			'bugs'
			'geometry circ2d3Tan '{CircleCircleLin_11,CircleLinPoint_11}
			'heal checkshape bug32448_1'
			'hlr exact_hlr bug25813_2'

			'hlr poly_hlr '{bug25813_2,bug25813_3,bug25813_4,Plate}
			'lowalgos intss bug'{565,567_1,25950,27431,29807_i1003,29807_i2006,29807_i3003,29807_i5002,30703}
			'lowalgos proximity '{A4,A5}
			'opengl background bug27836'
			'opengl drivers opengles'
			'opengles3'

			'demo draw bug30430'
		)

		local DEL_TESTS=(
			'opengl/data/background/bug27836'
			'perf/mesh/bug26965'
			'v3d/trsf/bug26029'
		)

		for test in "${DEL_TESTS[@]}"; do
			rm "${CMAKE_USE_DIR}/tests/${test}" || die
		done
	fi

	if ! use vtk; then
		SKIP_TESTS+=(
			'vtk'
		)
		echo "IGNORE /Could not open: libTKIVtkDraw/skip VTK" >> "${CMAKE_USE_DIR}/tests/opengl/parse.rules"
	fi

	if [[ -n "${SKIP_TESTS[*]}" ]]; then
		testgrid_opts+=( -exclude "$(IFS=',' ; echo "${SKIP_TESTS[*]}")" )
	fi

	testgrid_opts+=(
		# -refresh 5
		-overwrite
	)
	cat >> "${test_file}" <<- _EOF_ || die
		testgrid -outdir "${BUILD_DIR}/test_results" ${testgrid_opts[@]}
	_EOF_

	# # regenerate summary in case we have to
	# cat >> "${test_file}" <<- _EOF_ || die
	# 	testsummarize "${BUILD_DIR}/test_results"
	# _EOF_

	# Work around zink warnings
	export LIBGL_ALWAYS_SOFTWARE="true"

	export CASROOT="${BUILD_DIR}"

	virtx \
	"${BUILD_DIR}/draw.sh" \
		"${draw_opts[@]}" \
		-f "${test_file}"

	if [[ ! -f "${BUILD_DIR}/test_results/tests.log" ]]; then
		eerror "tests never ran!"
		die
	fi
	failed_tests="$(grep ": FAILED" "${BUILD_DIR}/test_results/tests.log")"
	if [[ -n ${failed_tests} ]]; then
		eerror "Failed tests:"
		eerror "${failed_tests}"
		die
	fi
}

src_install() {
	cmake_src_install

	doenvd "${T}/99${PN}"

	docompress -x "/usr/share/doc/${PF}/overview/html"
}
