# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit qmake-utils

MY_P="OpenCSG-${PV}"
DESCRIPTION="The Constructive Solid Geometry rendering library"
HOMEPAGE="http://www.opencsg.org"
SRC_URI="http://www.opencsg.org/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm64 x86"
IUSE="doc"
RESTRICT="test"

RDEPEND="
	dev-libs/libbsd
	media-libs/glew:0=
	virtual/opengl
	x11-libs/libX11
	x11-libs/libXau
	x11-libs/libXdmcp
	x11-libs/libXext
	x11-libs/libxcb:=
"

# qtgui is needed for opengles2 feature by
# /usr/lib64/qt5/mkspecs/feature/unix/opengl.prf
DEPEND="${RDEPEND}
	dev-qt/qtcore:5
	dev-qt/qtgui:5
"

S="${WORKDIR}/${MY_P}"

DOCS=( build.txt changelog.txt )

PATCHES=(
	"${FILESDIR}/${P}-includepath.patch"
)

src_prepare() {
	default

	# removes duplicated headers
	rm -r glew || die "failed to remove bundled glew"
}

src_configure() {
	eqmake5 opencsg.pro INSTALLDIR="${EPREFIX}/usr" LIBDIR="$(get_libdir)"
}

src_compile() {
	# rebuild Makefiles in subdirs
	emake INSTALLDIR="${EPREFIX}/usr" LIBDIR="$(get_libdir)" qmake_all
	emake sub-src
}

src_install() {
	emake -C src INSTALL_ROOT="${ED}" install
	use doc && local HTML_DOCS=( doc/. )
	einstalldocs
}
