# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit eutils

DEB_PR=11

DESCRIPTION="A set of programs for dealing with numbers from the command line"
HOMEPAGE="http://suso.suso.org/programs/num-utils/"
SRC_URI="
	http://suso.suso.org/programs/num-utils/downloads/${P}.tar.gz
	mirror://debian/pool/main/${PN:0:1}/${PN}/${PN}_${PV}-${DEB_PR}.diff.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~x86"
IUSE=""

src_prepare() {
	epatch "${WORKDIR}"/${PN}_${PV}-${DEB_PR}.diff
	sed \
		-e 's:../orig/num-utils-0.5/::g' \
		-i "${S}"/debian/patches/*.diff || die
	epatch "${S}"/debian/patches/*.diff

	local x
	for x in average bound interval normalize random range round; do
		mv $x num$x || die "renaming $x failed"
	done

	sed \
		-e 's/^RPMDIR/#RPMDIR/' \
		-e 's/COPYING//' \
		-e 's/LICENSE//' \
		-e '/^DOCS/s/MANIFEST//' \
		-i Makefile || die "sed Makefile failed"
}

src_install () {
	emake ROOT="${ED}" install
}

pkg_postinst() {
	elog "All ${PN} programs have been renamed with prefix 'num' to avoid collisions"
}
