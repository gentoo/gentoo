# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-office/upwork/upwork-4.0.53.0.ebuild,v 1.1 2015/05/15 18:17:08 titanofold Exp $

EAPI=5

inherit rpm eutils

# Binary only distribution
QA_PREBUILT="*"

DESCRIPTION="Project collaboration and tracking software for upwork.com"
HOMEPAGE="https://www.upwork.com/"
SRC_URI="amd64? ( http://updates.team.odesk.com/binaries/v4_0_53_0_p5TnmGwLv5sZSuKB/${PN}_x86_64.rpm -> ${P}_x86_64.rpm )
		 x86? ( http://updates.team.odesk.com/binaries/v4_0_53_0_p5TnmGwLv5sZSuKB/${PN}_i386.rpm -> ${P}_i386.rpm )
"
LICENSE="ODESK"
SLOT="0"
KEYWORDS="~amd64 ~x86"

S=${WORKDIR}

RDEPEND="
	dev-libs/libgcrypt:11
	media-libs/alsa-lib
	sys-libs/libcap
	virtual/udev
	x11-libs/gtk+:2
	x11-libs/gtkglext
"

src_prepare() {
	epatch "${FILESDIR}/${PN}-desktop.patch"
}

src_install() {
	# Wrapper to the real executable
	dobin usr/bin/upwork

	insinto /usr/share
	doins -r usr/share/upwork
	dosym /usr/lib/libudev.so /usr/share/upwork/libudev.so.0

	# Make this executable because it's the real executable
	fperms 0755 /usr/share/upwork/upwork

	domenu usr/share/applications/upwork.desktop
	doicon usr/share/pixmaps/upwork.png
}
