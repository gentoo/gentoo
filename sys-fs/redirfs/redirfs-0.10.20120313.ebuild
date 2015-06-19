# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-fs/redirfs/redirfs-0.10.20120313.ebuild,v 1.1 2012/10/30 14:27:18 bicatali Exp $

EAPI=4

inherit linux-mod

KEYWORDS="~amd64 ~x86"
SRC_URI="http://dev.gentoo.org/~bicatali/distfiles/${P}.tar.bz2"

DESCRIPTION="Layer between virtual file system switch and file system drivers"
HOMEPAGE="http://www.redirfs.org/"

LICENSE="GPL-3"
SLOT="0"
IUSE=""

DEPEND=""
RDEPEND=""

pkg_setup() {
	SRCDIR="${S}/src/redirfs"
	MODULE_NAMES="redirfs(misc:${SRCDIR})"
	BUILD_PARAMS="-C ${KERNEL_DIR} M=${SRCDIR}"
	BUILD_TARGETS="redirfs.ko"
	linux-mod_pkg_setup
}

src_install() {
	linux-mod_src_install
	insinto ${KERNEL_DIR}/include/linux
	doins ${SRCDIR}/redirfs.h
	dodoc ${SRCDIR}/{CHANGELOG,README,TODO}
}
