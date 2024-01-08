# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# TODO's
# package and unbundle manifold
# set up proper testing
# set up OFFLINE_DOCS and add doc USE flag

EAPI=8

inherit cmake git-r3 optfeature xdg

DESCRIPTION="The Programmers Solid 3D CAD Modeller"
HOMEPAGE="https://www.openscad.org/"
SRC_URI=""
EGIT_REPO_URI="https://github.com/openscad/openscad.git"

# Code is GPL-3+, MCAD library is LGPL-2.1
LICENSE="GPL-3+ LGPL-2.1"
SLOT="0"
KEYWORDS=""
IUSE="cairo dbus egl experimental gamepad gui hidapi mimalloc spacenav"
RESTRICT="test" # 32 out 1300+ tests fail

REQUIRED_USE="
	dbus? ( gui )
	gamepad? ( gui )
	spacenav? ( gui )
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
	media-libs/glew:0=
	media-libs/harfbuzz:=
	media-libs/lib3mf:=
	sci-mathematics/cgal:=
	virtual/opengl
	cairo? ( x11-libs/cairo )
	gui? (
		dev-qt/qtconcurrent:5
		dev-qt/qtcore:5
		dev-qt/qtgui:5[-gles2-only]
		dev-qt/qtmultimedia:5
		dev-qt/qtnetwork:5
		dev-qt/qtopengl:5
		dev-qt/qtsvg:5
		dev-qt/qtwidgets:5
		x11-libs/libX11
		x11-libs/qscintilla:=
		dbus? ( dev-qt/qtdbus:5 )
		gamepad? ( dev-qt/qtgamepad:5 )
	)
	hidapi? ( dev-libs/hidapi )
	mimalloc? ( dev-libs/mimalloc:= )
	spacenav? ( dev-libs/libspnav )
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-util/itstool
	sys-devel/bison
	app-alternatives/lex
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

src_configure() {
	local mycmakeargs=(
		-DCLANG_TIDY=OFF
		-DENABLE_CAIRO=$(usex cairo)
		-DENABLE_EGL=$(usex egl)
		-DENABLE_HIDAPI=$(usex hidapi)
		# needs python deps, unbundle first before enabling
		-DENABLE_MANIFOLD=OFF
		-DENABLE_SPNAV=$(usex spacenav)
		-DENABLE_TESTS=OFF
		-DEXPERIMENTAL=$(usex experimental)
		-DHEADLESS=$(usex gui OFF ON)
		-DOFFLINE_DOCS=OFF
		-DUSE_CCACHE=OFF
		-DUSE_MIMALLOC=$(usex mimalloc)
	)

	if use gui; then
		mycmakeargs+=(
			-DENABLE_GAMEPAD=$(usex gamepad)
			-DENABLE_QTDBUS=$(usex dbus)
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
