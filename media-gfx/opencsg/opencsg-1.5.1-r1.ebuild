# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit qmake-utils

MY_P="OpenCSG-${PV}"

DESCRIPTION="The Constructive Solid Geometry rendering library"
HOMEPAGE="https://www.opencsg.org"
SRC_URI="https://www.opencsg.org/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="GPL-2+"
SLOT="0/1.5"
KEYWORDS="amd64 ~arm64 ~ppc64 ~riscv x86"
IUSE="doc"
RESTRICT="test"

RDEPEND="
	media-libs/glew:0=
	virtual/opengl
"

# qtgui is needed for opengles2 feature by
# /usr/lib64/qt5/mkspecs/feature/unix/opengl.prf
DEPEND="${RDEPEND}
	dev-qt/qtcore:5
	dev-qt/qtgui:5
"

DOCS=( build.txt changelog.txt )

PATCHES=( "${FILESDIR}"/${PN}-1.4.2-includepath.patch )

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
