# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit scons-utils toolchain-funcs #udev

DESCRIPTION="exFAT filesystem FUSE module"
HOMEPAGE="https://code.google.com/p/exfat/"
SRC_URI="https://exfat.googlecode.com/files/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~hppa ~ia64 ~m68k ~mips ~ppc64 ~s390 ~sh ~sparc x86 ~arm-linux ~x86-linux"
IUSE=""

RDEPEND="sys-fs/fuse"
DEPEND=${RDEPEND}

src_compile() {
	tc-export AR CC RANLIB
	escons CCFLAGS="${CFLAGS}"
}

src_install() {
	dosbin fuse/mount.exfat-fuse
	dosym mount.exfat-fuse /usr/sbin/mount.exfat

	doman */*.8
	dodoc ChangeLog

	#This shouldn't really be required. Comment it out for now.
	#udev_dorules "${FILESDIR}"/99-exfat.rules
}

pkg_postinst() {
	elog "You can emerge sys-fs/exfat-utils for dump, label, mkfs and fsck utilities."
}
