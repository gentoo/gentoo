# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils toolchain-funcs

DESCRIPTION="A console program to recover files based on their headers and footers"
HOMEPAGE="http://foremost.sourceforge.net/"
#SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"
# starting to hate sf.net ...
SRC_URI="http://foremost.sourceforge.net/pkg/${P}.tar.gz"

KEYWORDS="amd64 ppc x86"
IUSE=""
LICENSE="public-domain"
SLOT="0"
PATCHES=("${FILESDIR}/${PN}-1.4-config-location.patch"
		"${FILESDIR}/${PN}-1.5.7-format-security.patch"
		"${FILESDIR}/${PN}-1.5.7-set-but-unused.patch")

src_compile() {
	emake RAW_FLAGS="${CFLAGS} -Wall ${LDFLAGS}" RAW_CC="$(tc-getCC) -DVERSION=\\\"${PV}\\\"" \
		CONF=/etc
}

src_install() {
	dobin foremost
	gunzip foremost.8.gz
	doman foremost.8
	insinto /etc
	doins foremost.conf
	dodoc README CHANGES
}
