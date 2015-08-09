# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

XORG_EAUTORECONF="yes"

inherit xorg-2

MY_P="${P/_p*//}"
MY_P_PATCH="${PN}_${PV/_p/-}"

SRC_URI="mirror://debian/pool/main/x/${PN}/${PN}_${PV/_p*/}.orig.tar.gz
	mirror://debian/pool/main/x/${PN}/${MY_P_PATCH}.diff.gz"
HOMEPAGE="https://packages.debian.org/source/sid/xf86-video-omapfb"

DESCRIPTION="X.org driver for TI OMAP framebuffers"
KEYWORDS="-* arm"
IUSE=""
RDEPEND=""
DEPEND="${RDEPEND}
	x11-proto/fontsproto
	x11-proto/randrproto
	x11-proto/renderproto
	x11-proto/xproto"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	epatch "${WORKDIR}/${MY_P_PATCH}.diff"
	epatch "${FILESDIR}"/000*.patch
	xorg-2_src_prepare
}
