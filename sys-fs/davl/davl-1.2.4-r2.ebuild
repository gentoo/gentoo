# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit toolchain-funcs

DESCRIPTION="Visualizes the fragmentation status of ext2/3 filesystems"
HOMEPAGE="http://davl.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=x11-libs/gtk+-2.6:2"
DEPEND="${RDEPEND}
	>=sys-fs/e2fsprogs-1.41.7-r1
	virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${PN}-1.2.1-asneeded.patch
	"${FILESDIR}"/${P}-fragment.patch
)

src_compile() {
	emake CC="$(tc-getCC)"
}

src_install() {
	dobin src/{cdavl/cdavl,gdavl/gdavl}
	dodoc README
	doman doc/*.8
}
