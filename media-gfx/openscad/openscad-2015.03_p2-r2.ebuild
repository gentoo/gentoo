# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit elisp-common eutils qmake-utils

MY_PV="2015.03-2"
SITEFILE="50${PN}-gentoo.el"

DESCRIPTION="The Programmers Solid 3D CAD Modeller"
HOMEPAGE="http://www.openscad.org/"
SRC_URI="http://files.openscad.org/${PN}-${MY_PV}.src.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
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

S="${WORKDIR}/${PN}-${MY_PV}"

src_prepare() {
	#Use our CFLAGS (specifically don't force x86)
	sed -i "s/QMAKE_CXXFLAGS_RELEASE = .*//g" ${PN}.pro  || die
	sed -i "s/\/usr\/local/\/usr/g" ${PN}.pro || die

	eapply_user
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
