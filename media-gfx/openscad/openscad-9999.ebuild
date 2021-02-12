# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake elisp-common git-r3 xdg

SITEFILE="50${PN}-gentoo.el"

DESCRIPTION="The Programmers Solid 3D CAD Modeller"
HOMEPAGE="https://www.openscad.org/"
SRC_URI=""
EGIT_REPO_URI="https://github.com/openscad/openscad.git"

# Code is GPL-3+, MCAD library is LGPL-2.1
LICENSE="GPL-3+ LGPL-2.1"
SLOT="0"
KEYWORDS=""
IUSE="cairo dbus emacs gamepad headless spacenav"
RESTRICT="test" # 32 out 1300+ tests fail

REQUIRED_USE="
	headless? ( !dbus !gamepad !spacenav )
"

RDEPEND="
	dev-cpp/eigen:3
	dev-libs/boost:=
	dev-libs/double-conversion:=
	dev-libs/glib:2
	dev-libs/libxml2
	dev-libs/libzip:=
	media-gfx/opencsg
	media-libs/fontconfig
	media-libs/freetype
	media-libs/glew:0=
	media-libs/harfbuzz:=
	media-libs/lib3mf
	sci-mathematics/cgal:=
	virtual/opengl
	cairo? ( x11-libs/cairo )
	emacs? ( app-editors/emacs:* )
	!headless? (
		dev-qt/qtconcurrent:5
		dev-qt/qtcore:5
		dev-qt/qtgui:5[-gles2-only]
		dev-qt/qtmultimedia:5
		dev-qt/qtnetwork:5
		dev-qt/qtopengl:5
		dev-qt/qtwidgets:5
		x11-libs/qscintilla:=
		dbus? ( dev-qt/qtdbus:5 )
		gamepad? ( dev-qt/qtgamepad:5 )
	)
	spacenav? ( dev-libs/libspnav )
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-util/itstool
	sys-devel/bison
	sys-devel/flex
	sys-devel/gettext
	virtual/pkgconfig
"

DOCS=(
	RELEASE_NOTES.md
	doc/TODO.txt
	doc/contributor_copyright.txt
	doc/hacking.md
	doc/testing.txt
)

src_prepare() {
	if has_version ">=media-libs/lib3mf-2"; then
		eapply "${FILESDIR}/${P}-0001-fix-to-find-lib3mf-2.patch"
	fi
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DCLANG_TIDY=OFF
		-DENABLE_CAIRO=$(usex cairo)
		-DENABLE_SPNAV=$(usex spacenav)
		-DENABLE_TESTS=OFF
		-DHEADLESS=$(usex headless)
		-DUSE_CCACHE=OFF
	)

	if use !headless; then
		mycmakeargs+=(
			-DENABLE_GAMEPAD=$(usex gamepad)
			-DENABLE_QTDBUS=$(usex dbus)
		)
	fi

	cmake_src_configure
}

src_compile() {
	cmake_src_compile

	if use emacs ; then
		elisp-compile contrib/*.el
	fi
}

src_install() {
	DOCS+=( doc/*.pdf )
	cmake_src_install

	mv -i "${ED}"/usr/share/openscad/locale "${ED}"/usr/share || die "failed to move locales"
	ln -sf ../locale "${ED}"/usr/share/openscad/locale || die

	rm -r "${ED}"/usr/share/openscad/libraries/MCAD/.{git,gitignore} || die

	if use emacs; then
		elisp-site-file-install "${FILESDIR}/${SITEFILE}"
		elisp-install ${PN} contrib/*.el contrib/*.elc
	fi
}

pkg_postinst() {
	use emacs && elisp-site-regen
	xdg_desktop_database_update
	xdg_icon_cache_update
	xdg_mimeinfo_database_update
}

pkg_postrm() {
	use emacs && elisp-site-regen
	xdg_desktop_database_update
	xdg_icon_cache_update
	xdg_mimeinfo_database_update
}
