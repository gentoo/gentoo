# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/libomxil-bellagio/libomxil-bellagio-0.9.3.ebuild,v 1.3 2014/12/10 09:56:37 ago Exp $

EAPI=5
XORG_MULTILIB=yes
XORG_EAUTORECONF=yes

inherit xorg-2

DESCRIPTION="An Open Source implementation of the OpenMAX Integration Layer"
HOMEPAGE="http://omxil.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN:3:5}/${P}.tar.gz mirror://ubuntu/pool/universe/${PN:0:4}/${PN}/${PN}_${PV}-1ubuntu2.debian.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="+audioeffects +clocksrc debug doc +videoscheduler"

RDEPEND=""
DEPEND="doc? ( app-doc/doxygen )
	${RDEPEND}"

src_prepare() {
	PATCHES=(
		"${WORKDIR}"/debian/patches/*.patch
		"${FILESDIR}"/${P}-dynamicloader-linking.patch
		"${FILESDIR}"/${P}-parallel-build.patch
		"${FILESDIR}"/${P}-version.patch
	)
	xorg-2_src_prepare
}

src_configure() {
	XORG_CONFIGURE_OPTIONS="
		--docdir="${EPREFIX}"/usr/share/doc/${PF} \
		$(use_enable audioeffects) \
		$(use_enable clocksrc) \
		$(use_enable debug) \
		$(use_enable doc) \
		$(use_enable videoscheduler)
	"
	xorg-2_src_configure
}
