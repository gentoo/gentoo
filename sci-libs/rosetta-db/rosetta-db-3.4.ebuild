# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-libs/rosetta-db/rosetta-db-3.4.ebuild,v 1.1 2013/03/19 08:06:37 jlec Exp $

EAPI=5

inherit eutils

MY_PN="${PN%-db}"
MY_P="${MY_PN}${PV}_database"

DESCRIPTION="Essential database for rosetta"
HOMEPAGE="http://www.rosettacommons.org"
SRC_URI="${MY_P}.tgz"

LICENSE="rosetta"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RESTRICT="fetch binchecks strip"

S="${WORKDIR}"/${MY_PN}_database

pkg_nofetch() {
	einfo "Go to ${HOMEPAGE} and get ${A}"
	einfo "which must be placed in ${DISTDIR}"
}

src_install() {
	esvn_clean
	insinto /usr/share/${PN}
	doins -r *

	cat >> "${T}"/41rosetta-db <<- EOF
	ROSETTA3_DB="${EPREFIX}/usr/share/${PN}"
	EOF
	doenvd "${T}"/41rosetta-db
}
