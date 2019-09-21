# Copyright 1999-2019 Gentoo Authors
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
	zlib? ( sys-libs/zlib:0= )
"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

DOCS="doc/*.txt"

PATCHES=(
	"${FILESDIR}"/${P}-makefile.patch
	"${FILESDIR}"/${PN}-2.30a-no-exec-stack.patch
)

S=${WORKDIR}/${MY_P}

src_compile() {
	export NO_FUSE=$(usex fuse 0 1)
	export NO_ZLIB=$(usex zlib 0 1)

	emake INSTALL_PATH="${D}"/usr CC="$(tc-getCC)"
	emake doc
}
