# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit eutils

DESCRIPTION="Wrapper to use lufs modules with fuse kernel support"
SRC_URI="mirror://sourceforge/fuse/${P}.tar.gz"
HOMEPAGE="http://fuse.sourceforge.net/"
LICENSE="GPL-2"
DEPEND="!<sys-fs/lufs-0.9.7-r3
		>=sys-fs/fuse-1.3"
KEYWORDS="x86 ppc ~amd64"
SLOT="0"
IUSE=""

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch ${FILESDIR}/lufis-allow-uid-and-gid-addon.patch
}

src_install() {
	dobin lufis
	dodoc README COPYING ChangeLog

	insinto /usr/include/lufs/
	doins fs.h
	doins proto.h
}
