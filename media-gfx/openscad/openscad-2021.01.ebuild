# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit elisp-common qmake-utils xdg

SITEFILE="50${PN}-gentoo.el"

DESCRIPTION="The Programmers Solid 3D CAD Modeller"
HOMEPAGE="https://www.openscad.org/"
SRC_URI="https://github.com/${PN}/${PN}/releases/download/${P}/${P}.src.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="emacs"
# tests are not fully working and need cmake which isn't yet
# officially supported.
RESTRICT="test"

RDEPEND="
	dev-cpp/eigen:3
	dev-libs/boost:=
	dev-libs/double-conversion:=
	dev-libs/glib:2
	dev-libs/gmp:0=
	dev-libs/hidapi
	dev-libs/libspnav
	dev-libs/libxml2
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
	x11-libs/cairo
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
"

PATCHES=( "${FILESDIR}"/${P}-0001-Gentoo-specific-Disable-ccache-building.patch )

src_prepare() {
	default
	if has_version ">=media-libs/lib3mf-2"; then
		eapply "${FILESDIR}/${P}-0002-fix-to-find-lib3mf-2.patch"
	fi
}

src_configure() {
	if has ccache ${FEATURES}; then
		eqmake5 "PREFIX = ${EROOT}/usr" "CONFIG += ccache" "${PN}.pro"
	else
		eqmake5 "PREFIX = ${EROOT}/usr" "${PN}.pro"
	fi
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

	mv -i "${ED}"/usr/share/openscad/locale "${ED}"/usr/share || die "failed to move locales"
	ln -sf ../locale "${ED}"/usr/share/openscad/locale || die

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
