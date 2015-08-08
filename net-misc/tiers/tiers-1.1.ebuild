# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit eutils

MY_P="${PN}${PV}"
DESCRIPTION="Random network topography generator"
HOMEPAGE="http://www.isi.edu/nsnam/ns/ns-topogen.html#tiers"
SRC_URI="http://www.isi.edu/nsnam/dist/topogen/${MY_P}.tar.gz
		 http://www.isi.edu/nsnam/dist/topogen/tiers2ns-lan.awk"

LICENSE="mapm"
SLOT="0"
KEYWORDS="~amd64 ~ppc x86"
IUSE=""

DEPEND="sys-devel/gcc"
RDEPEND="virtual/awk
	sci-visualization/gnuplot"

S=${WORKDIR}/${PN}${PV}

src_unpack() {
	unpack ${MY_P}.tar.gz
	cd "${S}"

	epatch "${FILESDIR}"/${MY_P}-gccfixes.patch
	epatch "${FILESDIR}"/${P}-gcc43.patch
	sed -e '1a\#!/bin/sh' -e '1d' -e "s|-f |-f /usr/share/${PN}/|g" -i "${S}"/bin/strip4gnuplot3.5
}

src_compile() {
	cd "${S}"/src
	emake CFLAGS="${CFLAGS}" CONFIGFILE="/etc/tiers-gnuplot.conf" EXEC="../bin/tiers-gnuplot" || die
	# cleanup for a sec
	rm *.o
	emake CFLAGS="${CFLAGS}" CONFIGFILE="/etc/tiers.conf" EXEC="../bin/tiers" || die
}

src_install() {
	dobin bin/tiers bin/tiers-gnuplot bin/strip4gnuplot3.5
	insinto /etc
	newins src/tiers_config.generic tiers.conf
	newins src/tiers_config.gnuplot tiers-gnuplot.conf
	insinto /usr/share/${PN}
	doins bin/*.awk "${DISTDIR}"/tiers2ns-lan.awk
	dodoc CHANGES COPYRIGHT README docs/*
}
