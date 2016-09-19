# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit eutils

MY_PN=VBoxGuestAdditions
MY_PV="${PV/beta/BETA}"
MY_PV="${MY_PV/rc/RC}"
MY_P=${MY_PN}_${MY_PV}

DESCRIPTION="CD image containing guest additions for VirtualBox"
HOMEPAGE="http://www.virtualbox.org/"
SRC_URI="http://download.virtualbox.org/virtualbox/${MY_PV}/${MY_P}.iso"

LICENSE="GPL-2+ LGPL-2.1+ MIT SGI-B-2.0 CDDL"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

RDEPEND="!app-emulation/virtualbox-bin
	!=app-emulation/virtualbox-9999"

S="${WORKDIR}"

src_unpack() {
	return 0
}

src_install() {
	insinto /usr/share/${PN/-additions}
	newins "${DISTDIR}"/${MY_P}.iso ${MY_PN}.iso
}
