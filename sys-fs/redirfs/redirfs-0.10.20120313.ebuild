# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit linux-mod

KEYWORDS="~amd64 ~x86"
SRC_URI="https://dev.gentoo.org/~bicatali/distfiles/${P}.tar.bz2"

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
