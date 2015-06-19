# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-fs/exfat-utils/exfat-utils-1.0.1.ebuild,v 1.4 2013/10/25 13:53:28 ssuominen Exp $

EAPI=5
inherit scons-utils toolchain-funcs

DESCRIPTION="exFAT filesystem utilities"
HOMEPAGE="http://code.google.com/p/exfat/"
SRC_URI="http://exfat.googlecode.com/files/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~hppa ~ia64 ~m68k ~mips ~ppc64 ~s390 ~sh ~sparc x86 ~arm-linux ~x86-linux"
IUSE=""

src_compile() {
	tc-export AR CC RANLIB
	escons CCFLAGS="${CFLAGS}"
}

src_install() {
	dobin dump/dumpexfat label/exfatlabel mkfs/mkexfatfs fsck/exfatfsck
	dosym mkexfatfs /usr/bin/mkfs.exfat
	dosym exfatfsck /usr/bin/fsck.exfat

	doman */*.8
	dodoc ChangeLog
}
