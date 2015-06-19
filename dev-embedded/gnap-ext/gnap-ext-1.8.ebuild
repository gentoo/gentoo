# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-embedded/gnap-ext/gnap-ext-1.8.ebuild,v 1.1 2005/08/10 11:24:23 koon Exp $

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
	unpack gnap-extensions-${PV}.tar
}

src_install() {
	dobin gnap_remaster
	doman gnap_remaster.1

	dodir /usr/lib/gnap
	insinto /usr/lib/gnap
	if ! use minimal; then
		newins ${DISTDIR}/gnap-basefs-${PV}.tar.bz2 gnap-basefs.tar.bz2
	fi
	dodir /usr/lib/gnap/extensions
	insinto /usr/lib/gnap/extensions
	doins ${WORKDIR}/gnapext_*.tbz2
}
