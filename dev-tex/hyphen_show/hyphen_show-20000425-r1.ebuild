# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

MY_PN=${PN//_/-}
DESCRIPTION="Show hyphenations in DVI files"
HOMEPAGE="https://packages.debian.org/stable/tex/hyphen-show"
SRC_URI="mirror://debian/pool/main/h/${MY_PN}/${MY_PN}_${PV}.orig.tar.gz"

LICENSE="GPL-1+"
SLOT="0"
KEYWORDS="amd64 ~ppc64 x86"

S=${WORKDIR}/${MY_PN}-${PV}
PATCHES=("${FILESDIR}"/${PN}-gcc34.patch)

src_compile() {
	$(tc-getCC) ${CFLAGS} ${LDFLAGS} hyphen_show.c -o hyphen_show || die
}

src_install() {
	dobin hyphen_show
	doman hyphen_show.1
	dodoc README.hyphen_show
}
