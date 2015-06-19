# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-fonts/montecarlo/montecarlo-0.ebuild,v 1.2 2014/08/10 21:14:01 slyfox Exp $

EAPI="4"

inherit font

MY_PN="MonteCarlo"
DESCRIPTION="monospace font, created by programmers, for programmers"
HOMEPAGE="http://www.bok.net/MonteCarlo/"
SRC_URI="http://www.bok.net/${MY_PN}/downloads/${MY_PN}-PCF.tgz
	bdf? ( http://www.bok.net/${MY_PN}/downloads/${MY_PN}-BDF.tgz )"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="bdf"

DEPEND=""
RDEPEND=""

S="${WORKDIR}"

src_install() {
	insinto /usr/share/fonts/${PN}/
	doins "${MY_PN}"-PCF/*
	use bdf && doins "${MY_PN}"-BDF/*
	font_xfont_config
}
