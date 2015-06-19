# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-biology/kalign/kalign-2.03-r1.ebuild,v 1.4 2011/12/18 20:18:56 phajdan.jr Exp $

EAPI=4

inherit toolchain-funcs

DESCRIPTION="Global and progressive multiple sequence alignment"
HOMEPAGE="http://msa.cgb.ki.se/"
SRC_URI="mirror://debian/pool/main/k/kalign/${PN}_${PV}.orig.tar.gz"

LICENSE="GPL-2"
SLOT="0"
IUSE=""
KEYWORDS="amd64 x86"

S="${WORKDIR}"/${PN}

src_prepare() {
	sed \
		-e "s/\$(CFLAGS) \$(OBJECTS)/\$(LDFLAGS) &/" \
		-i Makefile.in || die
}

src_compile() {
	emake CC="$(tc-getCC)" CFLAGS="${CFLAGS}"
}

src_install() {
	dobin ${PN}
	dodoc README
}
