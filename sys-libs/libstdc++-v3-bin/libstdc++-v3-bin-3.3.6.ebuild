# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-libs/libstdc++-v3-bin/libstdc++-v3-bin-3.3.6.ebuild,v 1.3 2007/12/24 19:32:16 armin76 Exp $

DESCRIPTION="Compatibility package for running binaries linked against a pre gcc 3.4 libstdc++"
HOMEPAGE="http://gcc.gnu.org/libstdc++/"
SRC_URI="ia64? ( mirror://gentoo/${PN}-ia64-${PV}.tbz2 )
	ppc64? ( mirror://gentoo/${PN}-ppc64-${PV}.tbz2 )"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="ia64 ppc64"
IUSE=""

DEPEND=""
RDEPEND="sys-libs/glibc"

RESTRICT="strip"

src_install() {
	cp -pPR "${WORKDIR}"/* "${D}"/ || die "copying files failed!"
}
