# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit elisp-common git-r3 qmake-utils xdg-utils

SITEFILE="50${PN}-gentoo.el"

DESCRIPTION="The Programmers Solid 3D CAD Modeller"
HOMEPAGE="http://www.openscad.org/"
EGIT_REPO_URI="https://github.com/openscad/openscad.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="emacs"

DEPEND="
	dev-cpp/eigen:3
	dev-libs/boost:=
	dev-libs/glib:2
	dev-libs/gmp:0=
	dev-libs/mpfr:0=
	dev-qt/qtconcurrent:5
	dev-qt/qtcore:5
	dev-qt/qtgui:5[-gles2]
	dev-qt/qtopengl:5
	media-gfx/opencsg
	media-libs/fontconfig:1.0
	media-libs/freetype:2
	>=media-libs/glew-2.0.0:*
	media-libs/harfbuzz
	sci-mathematics/cgal:=
	>=x11-libs/qscintilla-2.9.4:=[qt5(+)]
	emacs? ( virtual/emacs )
"
RDEPEND="${DEPEND}"

src_prepare() {
	default

	sed -i "s/\/usr\/local/\/usr/g" ${PN}.pro || die
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
	xdg_mimeinfo_database_update
	xdg_desktop_database_update
}

pkg_postrm() {
	xdg_mimeinfo_database_update
	xdg_desktop_database_update
}
