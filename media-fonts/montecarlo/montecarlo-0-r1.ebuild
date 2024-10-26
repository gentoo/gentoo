# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PN="MonteCarlo"
inherit font

DESCRIPTION="Monospace font, created by programmers, for programmers"
HOMEPAGE="https://www.bok.net/MonteCarlo/"
SRC_URI="https://www.bok.net/${MY_PN}/downloads/${MY_PN}-PCF.tgz
	bdf? ( https://www.bok.net/${MY_PN}/downloads/${MY_PN}-BDF.tgz )"
S="${WORKDIR}"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~loong ~x86"
IUSE="bdf"

src_install() {
	insinto /usr/share/fonts/${PN}/
	doins "${MY_PN}"-PCF/*
	use bdf && doins "${MY_PN}"-BDF/*
	font_xfont_config
}
