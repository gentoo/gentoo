# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils toolchain-funcs

DESCRIPTION="A set of command line tools to manipulate Wii/GameCube ISO images and WBFS containers"
HOMEPAGE="http://wit.wiimm.de/"
SRC_URI="https://dev.gentoo.org/~radhermit/distfiles/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+fuse +zlib"

RDEPEND="
	app-arch/bzip2
	fuse? ( sys-fs/fuse )
	zlib? ( sys-libs/zlib )
"
DEPEND="${RDEPEND}"

DOCS="doc/*.txt"

src_prepare() {
	epatch "${FILESDIR}"/${P}-makefile.patch
	epatch "${FILESDIR}"/${P}-no-exec-stack.patch
	epatch "${FILESDIR}"/${P}-sizeof-pointer-memaccess.patch
}

src_compile() {
	export NO_FUSE=$(usex fuse 0 1)
	export NO_ZLIB=$(usex zlib 0 1)

	emake INSTALL_PATH="${D}"/usr CC="$(tc-getCC)"
	emake doc
}
