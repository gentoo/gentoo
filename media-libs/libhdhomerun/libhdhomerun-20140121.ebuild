# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/libhdhomerun/libhdhomerun-20140121.ebuild,v 1.1 2014/05/04 01:27:42 cardoe Exp $

EAPI=5

inherit eutils

DESCRIPTION="SiliconDust HDHomeRun Utilties"
HOMEPAGE="http://www.silicondust.com/support/hdhomerun/downloads/linux/"
SRC_URI="http://download.silicondust.com/hdhomerun/${PN}_${PV}.tgz"

LICENSE="LGPL-3+"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}"

src_prepare() {
	epatch "${FILESDIR}/dont-strip.patch"
}

src_configure() {
	:
}

src_install() {
	dobin hdhomerun_config
	dolib libhdhomerun.so

	insinto /usr/include/hdhomerun
	doins *.h
}
