# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

MY_PN="adflib"

DESCRIPTION="Extract files from Amiga adf disk images"
HOMEPAGE="http://lclevy.free.fr/adflib/"
SRC_URI="http://lclevy.free.fr/${MY_PN}/${MY_PN}-${PV}.tar.bz2"
S="${WORKDIR}/${MY_PN}-${PV}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~hppa ppc x86 ~x86-linux ~ppc-macos ~sparc-solaris ~x86-solaris"

PATCHES=( "${FILESDIR}"/${PN}-0.7.12-CVE-2016-1243_CVE-2016-1244.patch )

src_prepare() {
	default
	eautoreconf
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die
}
