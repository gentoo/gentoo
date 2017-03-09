# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=4
inherit eutils

DEB_PR=1
DESCRIPTION="Graphical output functions for Matlab and Octave"
HOMEPAGE="http://www.epstk.de/"
SRC_URI="mirror://debian/pool/main/${PN:0:1}/${PN}/${PN}_${PV}.orig.tar.bz2
	mirror://debian/pool/main/${PN:0:1}/${PN}/${PN}_${PV}-${DEB_PR}.debian.tar.gz"

LICENSE="GPL-2"
KEYWORDS="~x86 ~amd64"
SLOT="0"
IUSE="doc"

RDEPEND="sci-mathematics/octave
	app-text/ghostscript-gpl"
DEPEND=""

S="${WORKDIR}"

src_prepare() {
	local p
	cd eps*
	for p in $(cat "${WORKDIR}"/debian/patches/series); do
		epatch "${WORKDIR}"/debian/patches/${p}
	done
}

src_install () {
	insinto /usr/share/octave/site/m/${PN}
	doins eps*/m/*
	use doc && dohtml -r eps*/doc/*
	insinto /etc
	doins debian/epstk.conf
	dodoc debian/README.Debian debian/changelog
}
