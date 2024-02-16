# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# USE_{DRACO,FFMPEG,FREEIMAGE,FREETYPE,GLES2,OPENGL,OPENVR,RAPIDJSON,TBB,TK,VTK,XLIB}

EAPI=8

inherit cmake

MY_SLOT="$(ver_cut 1-2)"
MY_PV="$(ver_rs 3 '-')"

DESCRIPTION="Development platform for CAD/CAE, 3D surface/solid modeling and data exchange"
HOMEPAGE="https://www.opencascade.com"
SRC_URI="https://git.dev.opencascade.org/gitweb/?p=occt.git;a=snapshot;h=185d29b92f6764ffa9fc195b7dbe7bba3c4ac855;sf=tgz -> ${P}.tar.gz"
S="${WORKDIR}/occt-185d29b"

LICENSE="|| ( Open-CASCADE-LGPL-2.1-Exception-1.0 LGPL-2.1 )"
SLOT="0/${MY_SLOT}"
KEYWORDS="amd64 ~arm ~arm64 ~riscv ~x86"
IUSE="doc examples ffmpeg freeimage gles2 json optimize tbb vtk"

REQUIRED_USE="?? ( optimize tbb )"

# There's no easy way to test. Testing needs a rather big environment
# properly set up.
RESTRICT="test"

# ffmpeg: https://tracker.dev.opencascade.org/view.php?id=32871
RDEPEND="
	dev-lang/tcl:=
	dev-lang/tk:=
	media-libs/fontconfig
	media-libs/freetype:2
	virtual/opengl
	x11-libs/libX11
	examples? (
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtquickcontrols2:5
		dev-qt/qtwidgets:5
		dev-qt/qtxml:5
	)
	ffmpeg? ( <media-video/ffmpeg-5:= )
	freeimage? ( media-libs/freeimage )
	tbb? ( dev-cpp/tbb:= )
	vtk? ( <sci-libs/vtk-9.3.0:=[rendering] )
"
DEPEND="
	${RDEPEND}
	x11-base/xorg-proto
	json? ( dev-libs/rapidjson )
	vtk? ( dev-libs/utfcpp )
"
BDEPEND="
	doc? ( app-text/doxygen )
	examples? ( dev-qt/linguist-tools:5 )
"

PATCHES=(
	"${FILESDIR}"/${PN}-7.5.1-0005-fix-write-permissions-on-scripts.patch
	"${FILESDIR}"/${PN}-7.5.1-0006-fix-creation-of-custom.sh-script.patch
	"${FILESDIR}"/${PN}-7.7.0-add-missing-include-limits.patch
	"${FILESDIR}"/${PN}-7.7.0-fix-installation-of-cmake-config-files.patch
	"${FILESDIR}"/${PN}-7.7.0-avoid-pre-stripping-binaries.patch
	"${FILESDIR}"/${PN}-7.7.0-build-against-vtk-9.2.patch
	"${FILESDIR}"/${PN}-7.7.0-musl.patch
)

src_prepare() {
	cmake_src_prepare

	sed -e 's|/lib\$|/'$(get_libdir)'\$|' \
		-i adm/templates/OpenCASCADEConfig.cmake.in || die

	# There is an OCCT_UPDATE_TARGET_FILE cmake macro that fails due to some
	# assumptions it makes about installation paths. Rather than fixing it, just
	# get rid of the mechanism altogether - its purpose is to allow a
	# side-by-side installation of release and debug libraries.
	sed -e 's|\\${OCCT_INSTALL_BIN_LETTER}||' \
		-i adm/cmake/occt_toolkit.cmake || die
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_DOC_Overview=$(usex doc)
		-DBUILD_Inspector=$(usex examples)
		-DBUILD_RELEASE_DISABLE_EXCEPTIONS=OFF # bug #847916

		-DINSTALL_DIR_BIN="$(get_libdir)/${PN}/bin"
		-DINSTALL_DIR_CMAKE="$(get_libdir)/cmake/${PN}"
		-DINSTALL_DIR_DATA="share/${PN}/data"
		-DINSTALL_DIR_DOC="share/doc/${PF}"
		-DINSTALL_DIR_INCLUDE="include/${PN}"
		-DINSTALL_DIR_LIB="$(get_libdir)/${PN}"
		-DINSTALL_DIR_RESOURCE="share/${PN}/resources"
		-DINSTALL_DIR_SAMPLES="share/${PN}/samples"
		-DINSTALL_DIR_SCRIPT="$(get_libdir)/${PN}/bin"
		-DINSTALL_DIR_WITH_VERSION=OFF
		-DINSTALL_SAMPLES=$(usex examples)
		-DINSTALL_TEST_CASES=NO

		-DUSE_D3D=NO
		# no package yet in tree
		-DUSE_DRACO=OFF
		# has no function in 7.7.0_beta
		# see https://dev.opencascade.org/content/occt-770-beta-version-available#comment-23733
		-DUSE_EIGEN=OFF
		-DUSE_FFMPEG=$(usex ffmpeg)
		-DUSE_FREEIMAGE=$(usex freeimage)
		-DUSE_FREETYPE=ON
		-DUSE_GLES2=$(usex gles2)
		# no package in tree
		-DUSE_OPENVR=OFF
		-DUSE_RAPIDJSON=$(usex json)
		-DUSE_TBB=$(usex tbb)
		-DUSE_VTK=$(usex vtk)
		-DUSE_XLIB=ON
		# suppress CMake dev warnings
		-Wno-dev
	)

	use doc && mycmakeargs+=( -DINSTALL_DOC_Overview=ON )

	if use examples; then
		mycmakeargs+=(
			-D3RDPARTY_QT_DIR="${ESYSROOT}"/usr
			-DBUILD_SAMPLES_QT=ON
		)
	fi

	if use tbb; then
		mycmakeargs+=( -D3RDPARTY_TBB_DIR="${ESYSROOT}"/usr )
	fi

	if use vtk; then
		local vtk_ver=$(best_version "sci-libs/vtk")
		vtk_ver=${vtk_ver#sci-libs/vtk-}
		vtk_ver=$(ver_cut 1-2 ${vtk_ver})
		mycmakeargs+=(
			-D3RDPARTY_VTK_DIR="${ESYSROOT}"/usr
			-D3RDPARTY_VTK_INCLUDE_DIR="${ESYSROOT}"/usr/include/vtk-${vtk_ver}
			-D3RDPARTY_VTK_LIBRARY_DIR="${ESYSROOT}"/usr/$(get_libdir)
		)
	fi

	cmake_src_configure

	sed -e "s|lib/|$(get_libdir)/|" \
		-e "s|VAR_CASROOT|${EPREFIX}/usr|" \
		< "${FILESDIR}"/${PN}.env.in > "${T}"/99${PN} || die

	# use TBB for memory allocation optimizations
	if use tbb; then
		sed -e 's|^#MMGT_OPT=0$|MMGT_OPT=2|' -i "${T}"/99${PN} || die
	fi

	# use internal optimized memory manager and don't clear memory with this
	# memory manager.
	if use optimize ; then
		sed -e 's|^#MMGT_OPT=0$|MMGT_OPT=1|' \
			-e 's|^#MMGT_CLEAR=1$|MMGT_CLEAR=0|' \
			-i "${T}"/99${PN} || die
	fi
}

src_install() {
	cmake_src_install

	doenvd "${T}/99${PN}"

	docompress -x /usr/share/doc/${PF}/overview/html
}
