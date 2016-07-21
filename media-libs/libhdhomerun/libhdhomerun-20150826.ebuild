# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils

DESCRIPTION="SiliconDust HDHomeRun Utilties"
HOMEPAGE="http://www.silicondust.com/support/hdhomerun/downloads/linux/"
SRC_URI="http://download.silicondust.com/hdhomerun/${PN}_${PV}.tgz"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
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
