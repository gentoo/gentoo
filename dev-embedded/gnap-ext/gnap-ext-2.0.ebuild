# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

MY_P="${P/gnap-ext/gnap-tools}"
S="${WORKDIR}/${MY_P}"
DESCRIPTION="Gentoo-based Network Appliance extensions and remastering tool"
HOMEPAGE="http://embedded.gentoo.org/gnap.xml"

SRC_URI="mirror://gentoo/${MY_P}.tar.bz2
	!minimal? ( mirror://gentoo/gnap-basefs-${PV}.tar.bz2
				mirror://gentoo/gnap-extensions-${PV}.tar )"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="minimal"

RDEPEND="sys-fs/squashfs-tools"

src_unpack() {
	unpack ${MY_P}.tar.bz2
	if ! use minimal; then
		unpack gnap-extensions-${PV}.tar
	fi
}

src_install() {
	dobin gnap_remaster
	doman gnap_remaster.1

	if ! use minimal; then
		dodir /usr/lib/gnap
		insinto /usr/lib/gnap
		newins ${DISTDIR}/gnap-basefs-${PV}.tar.bz2 gnap-basefs.tar.bz2
		dodir /usr/lib/gnap/extensions
		insinto /usr/lib/gnap/extensions
		doins ${WORKDIR}/gnapext_*.tbz2
	fi
}
