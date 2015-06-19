# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/lcdsplash/lcdsplash-0.3.ebuild,v 1.3 2010/10/08 02:04:46 leio Exp $

inherit multilib

DESCRIPTION="splash Gentoo boot information on LCD's"
HOMEPAGE="http://www.gentoo.org/"
SRC_URI="mirror://gentoo/${P}.tar.bz2
	http://dev.gentoo.org/~vapier/dist/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="hppa ~mips x86"
IUSE=""

DEPEND="mips? ( sys-apps/lcdutils )"

S=${WORKDIR}/${PN}

src_install() {
	insinto /sbin
	doins splash-functions.sh || die "splash"
	insinto /$(get_libdir)/rcscripts/lcdsplash
	doins -r modules/* || die "modules"

	insinto /etc
	doins lcdsplash.conf || die "conf"

	dodoc README
}
