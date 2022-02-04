# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit edos2unix flag-o-matic toolchain-funcs

MY_P=OpenCTM-${PV}

DESCRIPTION="OpenCTM - the Open Compressed Triangle Mesh"
HOMEPAGE="http://openctm.sourceforge.net"
SRC_URI="https://downloads.sourceforge.net/project/openctm/${MY_P}/${MY_P}-src.tar.bz2 -> ${P}-src.tar.bz2"
S="${WORKDIR}/${MY_P}"

LICENSE="GPL-2"
SLOT="0/1"
KEYWORDS="~amd64 ~x86"

DEPEND="
	dev-libs/tinyxml
	media-libs/freeglut
	media-libs/glew:0=
	media-libs/pnglite
	sys-libs/zlib
	virtual/jpeg:0
	virtual/opengl
	x11-libs/gtk+:2
"
RDEPEND="${DEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}/${P}-escape-hyphens-in-ctmconv-man-page.patch"
	"${FILESDIR}/${P}-link-ctmviewer-with-libGLU.patch"
	"${FILESDIR}/${P}-use-system-libs.patch"
	"${FILESDIR}/${P}-do-not-set-rpath.patch"
	"${FILESDIR}/${P}-link-ctmviewer-only-with-necessary-gtk-libs.patch"
	"${FILESDIR}/${P}-link-ctmviewer-with-libGL.patch"
	"${FILESDIR}/${P}-create-lib-with-correct-soname-and-symlinks.patch"
	"${FILESDIR}/${P}-fix-install-paths.patch"
	"${FILESDIR}/${P}-respect-flags.patch"
	"${FILESDIR}/${P}-no-strip.patch"
)

src_prepare() {
	edos2unix lib/Makefile.linux

	default
}

src_compile() {
	tc-export PKG_CONFIG

	emake CC=$(tc-getCC) CXX="$(tc-getCXX)" -f Makefile.linux
}

src_install() {
	emake DESTDIR="${ED}" LIBDIR="${ED}/usr/$(get_libdir)" -f Makefile.linux install
}
