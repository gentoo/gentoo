# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit elisp-common git-r3 qmake-utils xdg

SITEFILE="50${PN}-gentoo.el"

DESCRIPTION="The Programmers Solid 3D CAD Modeller"
HOMEPAGE="https://www.openscad.org/"
EGIT_REPO_URI="https://github.com/openscad/openscad.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="ccache emacs"
RESTRICT="test"

RDEPEND="
	dev-cpp/eigen:3
	dev-libs/boost:=
	dev-libs/double-conversion:=
	dev-libs/glib:2
	dev-libs/gmp:0=
	dev-libs/hidapi
	dev-libs/libspnav
	dev-libs/libzip:=
	dev-libs/mpfr:0=
	dev-qt/qtconcurrent:5
	dev-qt/qtcore:5
	dev-qt/qtdbus:5
	dev-qt/qtgui:5[-gles2-only]
	dev-qt/qtmultimedia:5
	dev-qt/qtnetwork:5
	dev-qt/qtopengl:5
	dev-qt/qtwidgets:5
	media-gfx/opencsg
	media-libs/fontconfig
	media-libs/freetype
	>=media-libs/glew-2.0.0:0=
	media-libs/harfbuzz:=
	media-libs/lib3mf
	sci-mathematics/cgal:=
	>=x11-libs/qscintilla-2.10.3:=
	emacs? ( >=app-editors/emacs-23.1:* )
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-util/itstool
	sys-devel/bison
	sys-devel/flex
	sys-devel/gettext
	virtual/pkgconfig
	ccache? ( dev-util/ccache )
"

src_prepare() {
	default

	# fix path prefix
	sed -i "s/\/usr\/local/\/usr/g" ${PN}.pro || die

	# disable ccache
	if ! use ccache; then
		eapply "${FILESDIR}/${P}-0002-Gentoo-specific-Disable-ccache-building.patch"
	fi
}

src_configure() {
	eqmake5 "${PN}.pro"
}

src_compile() {
	default

	if use emacs ; then
		elisp-compile contrib/*.el
	fi
}

src_install() {
	emake install INSTALL_ROOT="${D}"

	if use emacs; then
		elisp-site-file-install "${FILESDIR}/${SITEFILE}"
		elisp-install ${PN} contrib/*.el contrib/*.elc
	fi

	einstalldocs
}

pkg_postinst() {
	use emacs && elisp-site-regen
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
}

pkg_postrm() {
	use emacs && elisp-site-regen
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
}
