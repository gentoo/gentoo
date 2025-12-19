# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools flag-o-matic

MY_PN="adflib"

DESCRIPTION="Extract files from Amiga adf disk images"
HOMEPAGE="http://lclevy.free.fr/adflib/"
SRC_URI="http://lclevy.free.fr/${MY_PN}/${MY_PN}-${PV}.tar.bz2"
S="${WORKDIR}/${MY_PN}-${PV}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~hppa ppc x86"

PATCHES=( "${FILESDIR}"/${PN}-0.7.12-CVE-2016-1243_CVE-2016-1244.patch )

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	append-cflags -std=gnu17 #bug #943902
	econf
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die
}
