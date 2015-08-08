# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit scons-utils toolchain-funcs

DESCRIPTION="exFAT filesystem FUSE module"
HOMEPAGE="http://code.google.com/p/exfat/"
SRC_URI="http://docs.google.com/uc?export=download&id=0B7CLI-REKbE3VTdaa0EzTkhYdU0 -> ${P}.tar.gz"

LICENSE="GPL-2+" # COPYING is GPL-2 but ChangeLog says "Relicensed the project from GPLv3+ to GPLv2+"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~m68k ~mips ~ppc64 ~s390 ~sh ~sparc ~x86 ~arm-linux ~x86-linux"
IUSE=""

RDEPEND="sys-fs/fuse"
DEPEND=${RDEPEND}

src_compile() {
	tc-export AR CC RANLIB
	escons CCFLAGS="${CFLAGS} -Wall -std=c99"
}

src_install() {
	dosbin fuse/mount.exfat-fuse
	dosym mount.exfat-fuse /usr/sbin/mount.exfat

	doman */*.8
	dodoc ChangeLog
}

pkg_postinst() {
	elog "You can emerge sys-fs/exfat-utils for dump, label, mkfs and fsck utilities."
}
