# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit elisp-common eutils git-r3 qmake-utils

SITEFILE="50${PN}-gentoo.el"

DESCRIPTION="The Programmers Solid 3D CAD Modeller"
HOMEPAGE="http://www.openscad.org/"
EGIT_REPO_URI="https://github.com/openscad/openscad.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="emacs"

DEPEND="media-gfx/opencsg
	sci-mathematics/cgal
	dev-qt/qtcore:4
	dev-qt/qtgui:4[-egl]
	dev-qt/qtopengl:4[-egl]
	dev-cpp/eigen:3
	dev-libs/glib:2
	dev-libs/gmp:0=
	dev-libs/mpfr:0=
	dev-libs/boost:=
	media-libs/fontconfig:1.0
	media-libs/freetype:2
	media-libs/glew:*
	media-libs/harfbuzz
	x11-libs/qscintilla:=[qt4(-)]
	emacs? ( virtual/emacs )"
RDEPEND="${DEPEND}"

src_prepare() {
	sed -i "s/\/usr\/local/\/usr/g" ${PN}.pro || die

	default
}

src_configure() {
	eqmake4 "${PN}.pro"
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
