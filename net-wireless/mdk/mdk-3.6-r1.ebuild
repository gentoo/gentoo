# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"
inherit eutils toolchain-funcs

MY_P="${PN}${PV/./-v}"
DESCRIPTION="Wireless injection tool with various functions"
HOMEPAGE="http://homepages.tu-darmstadt.de/~p_larbig/wlan"
SRC_URI="http://homepages.tu-darmstadt.de/~p_larbig/wlan/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE=""

S="${WORKDIR}/${MY_P}"

src_prepare() {
	epatch "${FILESDIR}"/${PV}-makefile.patch
	epatch "${FILESDIR}"/fix_wids_mdk3_v5.patch
}

src_compile() {
	emake CC=$(tc-getCC)
}

src_install() {
	emake DESTDIR="${ED}" install

	insinto /usr/share/${PN}
	doins -r useful_files

	dohtml docs/*
	dodoc AUTHORS CHANGELOG TODO
}
