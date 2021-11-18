# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DEB_PR=1
DESCRIPTION="Graphical output functions for Matlab and Octave"
HOMEPAGE="http://www.epstk.de/"
SRC_URI="mirror://debian/pool/main/${PN:0:1}/${PN}/${PN}_${PV}.orig.tar.bz2
	mirror://debian/pool/main/${PN:0:1}/${PN}/${PN}_${PV}-${DEB_PR}.debian.tar.gz"
S="${WORKDIR}"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~riscv ~x86"
SLOT="0"
IUSE="doc"

RDEPEND="sci-mathematics/octave
	app-text/ghostscript-gpl"

src_prepare() {
	cd eps* || die

	local p
	for p in $(cat "${WORKDIR}"/debian/patches/series); do
		eapply "${WORKDIR}"/debian/patches/${p}
	done

	default
}

src_install() {
	insinto /usr/share/octave/site/m/${PN}
	doins eps*/m/*

	if use doc ; then
		docinto html
		dodoc -r eps*/doc/*
	fi

	insinto /etc
	doins debian/epstk.conf
	dodoc debian/README.Debian debian/changelog
}
