# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit linux-mod

if [[ ${PV} == "9999" ]] ; then
		inherit git-2
		KEYWORDS=""
		EGIT_REPO_URI="git://www.redirfs.org/git/fhrbata/redirfs.git"
		SRCDIR="${S}/src/redirfs"
else
		KEYWORDS="~amd64 ~x86"
		SRC_URI="http://www.redirfs.org/packages/${P}.tar.gz"
fi

DESCRIPTION="Layer between virtual file system switch and file system drivers"
HOMEPAGE="http://www.redirfs.org/"

LICENSE="GPL-3"
SLOT="0"
IUSE=""

DEPEND=""
RDEPEND=""

pkg_setup() {
	MODULE_NAMES="redirfs(misc:${SRCDIR})"
	BUILD_PARAMS="-C ${KERNEL_DIR} M=${SRCDIR}"
	BUILD_TARGETS="redirfs.ko"
	linux-mod_pkg_setup
}

src_install() {
	linux-mod_src_install
	insinto /usr/include
	doins ${SRCDIR}/redirfs.h
	dodoc ${SRCDIR}/{CHANGELOG,README,TODO}
}
