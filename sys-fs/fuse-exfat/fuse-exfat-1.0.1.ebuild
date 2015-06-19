# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-fs/fuse-exfat/fuse-exfat-1.0.1.ebuild,v 1.5 2013/10/19 03:47:28 vapier Exp $

EAPI=5
inherit scons-utils toolchain-funcs #udev

DESCRIPTION="exFAT filesystem FUSE module"
HOMEPAGE="http://code.google.com/p/exfat/"
SRC_URI="http://exfat.googlecode.com/files/${P}.tar.gz"

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
