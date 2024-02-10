# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools desktop flag-o-matic

DESCRIPTION="A NeoGeo emulator"
HOMEPAGE="https://code.google.com/p/gngeo/"
SRC_URI="https://gngeo.googlecode.com/files/${P}.tar.gz
	https://storage.googleapis.com/google-code-archive/v2/code.google.com/gngeo/logo.png -> ${PN}.png"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
	media-libs/libsdl[joystick,opengl,sound,video]
	sys-libs/zlib[minizip]
	virtual/opengl
"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-execstacks.patch
	"${FILESDIR}"/${P}-zlib.patch
	"${FILESDIR}"/${P}-concurrentMake.patch
	"${FILESDIR}"/${P}-cflags.patch
	"${FILESDIR}"/${P}-fcommon.patch
)

src_prepare() {
	default
	mv configure.in configure.ac || die
	eautoreconf
	append-cflags -std=gnu89 # build with gcc5 (bug #571056)
}

src_configure() {
	econf --disable-i386asm
}

src_install() {
	DOCS=( AUTHORS FAQ NEWS README* TODO sample_gngeorc )
	default
	doicon "${DISTDIR}"/${PN}.png
	make_desktop_entry ${PN}
}
