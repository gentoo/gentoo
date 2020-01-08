# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit elisp-common qmake-utils xdg

# 2015.03-3
MY_VER=$(ver_cut 1-2) # version component
MY_REL=$(ver_cut 4) # release component, 'p' being the third component
MY_PV=${MY_VER}-${MY_REL}
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
	dev-qt/qtgui:5[-gles2]
	dev-qt/qtopengl:5
	media-gfx/opencsg
	media-libs/fontconfig:1.0
	media-libs/freetype:2
	>=media-libs/glew-2.0.0:*
	media-libs/harfbuzz
	sci-mathematics/cgal:=
	>=x11-libs/qscintilla-2.9.4:=[qt5(+)]
	emacs? ( >=app-editors/emacs-23.1:* )
"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/${PN}-2015.03_p2_uic_tr_fix.patch"
	"${FILESDIR}/${PN}-2015.03_p3_fix-boost-1.70.0-build.patch"
)

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
