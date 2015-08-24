# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

MY_P=${P/gnap-dev/gnap-sources}
S="${WORKDIR}/gnap-${PV}"
DESCRIPTION="Gentoo-based Network Appliance building system development tools"
HOMEPAGE="https://embedded.gentoo.org/gnap.xml"

SRC_URI="mirror://gentoo/${MY_P}.tar.bz2
	!minimal? (	mirror://gentoo/gnap-stageseed-${PV}.tar.bz2
		mirror://gentoo/gnap-portagesnapshot-${PV}.tar.bz2 )"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="minimal"

RDEPEND=">=dev-util/catalyst-2.0_rc40
	sys-fs/squashfs-tools
	app-cdr/cdrtools"

src_unpack() {
	unpack ${MY_P}.tar.bz2
}

src_install() {
	dobin gnap_make
	doman gnap_make.1

	dodir /usr/lib/gnap
	tar jc -f ${D}/usr/lib/gnap/gnap-specs.tar.bz2 -C specs .
	if ! use minimal; then
		insinto /usr/lib/gnap
		newins ${DISTDIR}/gnap-stageseed-${PV}.tar.bz2 gnap-stage3seed.tar.bz2
		newins ${DISTDIR}/gnap-portagesnapshot-${PV}.tar.bz2 gnap-portagesnapshot.tar.bz2
	fi
}
