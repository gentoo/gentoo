# Copyright 2003-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs

DESCRIPTION="copies DVD .vob files to harddisk, decrypting them on the way"
HOMEPAGE="http://lpn.rnbhq.org/"
SRC_URI="http://lpn.rnbhq.org/download/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 sparc x86"
IUSE=""

DEPEND="media-libs/libdvdread:0="
RDEPEND=""

src_configure() {
	tc-export CC
	./configure.sh --with-lfs || die "Configure failed"
}

src_install() {
	dobin vobcopy
	doman vobcopy.1
	dodoc Changelog README Release-Notes TODO alternative_programs.txt
}
