# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-fs/redirfs/redirfs-0.8.ebuild,v 1.2 2012/05/28 22:11:20 bicatali Exp $

inherit linux-mod

DESCRIPTION="Layer between virtual file system switch and file system drivers"
HOMEPAGE="http://www.redirfs.org"
SRC_URI="http://www.redirfs.org/packages/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND=""

pkg_setup() {
	linux-mod_pkg_setup
	MODULE_NAMES="redirfs(misc:)"
	BUILD_TARGETS="redirfs.ko"
	BUILD_PARAMS="-C ${KERNEL_DIR} M=${S} modules"
}

src_install() {
	dodoc CHANGELOG INSTALL README TODO
	linux-mod_src_install
	insinto /usr/include
	doins redirfs.h
}
