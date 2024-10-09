# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake flag-o-matic optfeature virtualx xdg

COMMIT=709b93bed24a265f842c09794a88d7fe95c95197
MCAD_COMMIT=bd0a7ba3f042bfbced5ca1894b236cea08904e26

DESCRIPTION="The Programmers Solid 3D CAD Modeller"
HOMEPAGE="https://openscad.org/"
SRC_URI="https://github.com/openscad/openscad/archive/${COMMIT}.tar.gz -> ${P}.tar.gz
	test? ( https://github.com/openscad/MCAD/archive/${MCAD_COMMIT}.tar.gz -> ${PN}-MCAD-${MCAD_COMMIT}.tar.gz )"
# doc downloads are not versioned and found at:
# https://files.openscad.org/documentation/
S="${WORKDIR}/${PN}-${COMMIT}"

# Code is GPL-3+, MCAD library is LGPL-2.1
LICENSE="GPL-3+ LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64"
IUSE="dbus experimental gamepad +gui hidapi mimalloc pdf qt6 spacenav test"
RESTRICT="test mirror"  # many tests fail

REQUIRED_USE="
	dbus? ( gui )
	gamepad? ( gui )
	spacenav? ( gui )
	qt6? ( !gamepad )
"

RDEPEND="
	dev-cpp/eigen:3
	dev-libs/boost:=
	dev-libs/double-conversion:=
	dev-libs/glib:2
	dev-libs/libxml2
	dev-libs/libzip:=
	media-gfx/opencsg:=
	media-libs/fontconfig
	media-libs/freetype
	media-libs/harfbuzz:=
	media-libs/lib3mf:=
	sci-mathematics/cgal:=
	virtual/opengl
	experimental? (
		dev-cpp/tbb
		>=sci-mathematics/manifold-3.0.0_pre2040919
	)
	gui? (
		qt6? (
			dev-qt/qt5compat:6
			dev-qt/qtbase:6[concurrent,dbus?,-gles2-only,network,opengl,widgets]
			dev-qt/qtmultimedia:6
			dev-qt/qtsvg:6
			x11-libs/qscintilla:=[qt6]
		)
		!qt6? (
			dev-qt/qtconcurrent:5
			dev-qt/qtcore:5
			dev-qt/qtgui:5[-gles2-only]
			dev-qt/qtmultimedia:5
			dev-qt/qtnetwork:5
			dev-qt/qtopengl:5
			dev-qt/qtsvg:5
			dev-qt/qtwidgets:5
			x11-libs/qscintilla:0=
			dbus? ( dev-qt/qtdbus:5 )
			gamepad? ( dev-qt/qtgamepad:5 )
		)
	)
	hidapi? ( dev-libs/hidapi )
	mimalloc? ( dev-libs/mimalloc:= )
	pdf? ( x11-libs/cairo )
	spacenav? ( dev-libs/libspnav )
"
DEPEND="${RDEPEND}"
BDEPEND="
	app-alternatives/yacc
	app-alternatives/lex
	dev-util/itstool
	dev-util/sanitizers-cmake
	sys-devel/gettext
	virtual/pkgconfig
"

DOCS=(
	README.md
	RELEASE_NOTES.md
	doc/TODO.txt
	doc/contributor_copyright.txt
	doc/hacking.md
	doc/testing.txt
	doc/translation.txt
)

PATCHES=( "${FILESDIR}/sanitizers-cmake.patch" )

src_prepare() {
	if use test; then
		mv -f "${WORKDIR}/MCAD-${MCAD_COMMIT}"/* "${S}/libraries/MCAD/" || die
	fi

	cmake_src_prepare
}

src_configure() {
	# -Werror=odr
	# https://github.com/openscad/openscad/issues/5239
	filter-lto

	local mycmakeargs=(
		-DOPENSCAD_COMMIT=${COMMIT:0:9}
		-DOPENSCAD_VERSION=${PV:0:4}.${PV:4:2}.${PV:6:2}
		-DCLANG_TIDY=OFF
		-DENABLE_CAIRO=$(usex pdf)
		-DENABLE_EGL=ON
		-DENABLE_GLX=OFF
		-DENABLE_TBB=$(usex experimental)
		-DENABLE_TESTS=$(usex test)
		-DEXPERIMENTAL=$(usex experimental)
		-DHEADLESS=$(usex gui OFF ON)
		-DUSE_BUILTIN_MANIFOLD=OFF
		-DUSE_CCACHE=OFF
		-DUSE_GLAD=ON
		-DUSE_LEGACY_RENDERERS=OFF
		-DUSE_MIMALLOC=$(usex mimalloc)
		-DUSE_QT6=$(usex qt6)
	)

	if use gui; then
		mycmakeargs+=(
			-DENABLE_GAMEPAD=$(usex gamepad)
			-DENABLE_HIDAPI=$(usex hidapi)
			-DENABLE_QTDBUS=$(usex dbus)
			-DENABLE_SPNAV=$(usex spacenav)
		)
	fi

	cmake_src_configure
}

src_install() {
	DOCS+=( doc/*.pdf )
	cmake_src_install

	mv -i "${ED}"/usr/share/openscad/locale "${ED}"/usr/share || die "failed to move locales"
	dosym -r /usr/share/locale /usr/share/openscad/locale
}

src_test() {
	xdg_environment_reset
	pushd "${BUILD_DIR}" > /dev/null || die
	virtx ctest -j "$(makeopts_jobs "${MAKEOPTS}" 999)"
	popd > /dev/null || die
}

pkg_postinst() {
	xdg_desktop_database_update
	xdg_icon_cache_update
	xdg_mimeinfo_database_update

	optfeature "support scad major mode in GNU Emacs" app-emacs/scad-mode
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_icon_cache_update
	xdg_mimeinfo_database_update
}
