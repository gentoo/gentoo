# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

MY_P="wiimms-iso-tools.source-${PV}"

DESCRIPTION="command line tools to manipulate Wii/GameCube ISO images and WBFS containers"
HOMEPAGE="https://wit.wiimm.de/"
SRC_URI="https://download.wiimm.de/source/wiimms-iso-tools/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="+fuse +zlib"

RDEPEND="
	app-arch/bzip2:0=
	fuse? ( sys-fs/fuse:0= )
	zlib? ( sys-libs/zlib:0= )"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

S="${WORKDIR}/${MY_P}"

PATCHES=(
	"${FILESDIR}"/${P}-makefile.patch
	"${FILESDIR}"/${P}-no-exec-stack.patch
	"${FILESDIR}"/${P}-fno-common.patch
)

src_configure() {
	export NO_FUSE=$(usex fuse 0 1)
	export NO_ZLIB=$(usex zlib 0 1)

	tc-export CC PKG_CONFIG
}

src_compile() {
	emake INSTALL_PATH="${ED}"/usr
	emake doc
}

src_install() {
	default
	dodoc doc/*.txt
}
