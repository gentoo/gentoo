# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-embedded/gnap/gnap-2.0.ebuild,v 1.2 2013/09/15 23:14:29 chithanh Exp $

MY_P="${P/gnap/gnap-tools}"
S="${WORKDIR}/${MY_P}"
DESCRIPTION="Gentoo-based Network Appliance building system"
HOMEPAGE="http://embedded.gentoo.org/gnap.xml"

SRC_URI="mirror://gentoo/${MY_P}.tar.bz2
	!minimal? ( mirror://gentoo/${PN}-core-${PV}.tar )"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="minimal"

RDEPEND="app-cdr/cdrtools
	sys-fs/dosfstools
	<sys-boot/syslinux-5"

src_unpack() {
	unpack ${MY_P}.tar.bz2
}

src_install() {
	dobin gnap_overlay
	doman gnap_overlay.1

	dodoc README.upgrading

	dodir /usr/lib/gnap
	insinto /usr/lib/gnap
	if ! use minimal; then
		newins "${DISTDIR}"/${PN}-core-${PV}.tar ${PN}-core.tar
		doins -r mbr
		doins -r examples
	fi
}
