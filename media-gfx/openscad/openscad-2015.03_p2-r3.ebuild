# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit elisp-common qmake-utils xdg-utils

MY_PV="2015.03-2"
SITEFILE="50${PN}-gentoo.el"

DESCRIPTION="The Programmers Solid 3D CAD Modeller"
HOMEPAGE="http://www.openscad.org/"
SRC_URI="http://files.openscad.org/${PN}-${MY_PV}.src.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="emacs"

DEPEND="
	dev-cpp/eigen:3
	dev-libs/boost:=
	dev-libs/glib:2
	dev-libs/gmp:0=
	dev-libs/mpfr:0=
	dev-qt/qtconcurrent:5
	dev-qt/qtcore:5
	dev-qt/qtgui:5
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

PATCHES=( "${FILESDIR}/${P}_uic_tr_fix.patch" )

S="${WORKDIR}/${PN}-${MY_PV}"

src_prepare() {
	default

	#Use our CFLAGS (specifically don't force x86)
	sed -i "s/QMAKE_CXXFLAGS_RELEASE = .*//g" ${PN}.pro  || die
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
