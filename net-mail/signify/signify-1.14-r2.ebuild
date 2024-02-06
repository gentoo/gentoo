# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="A (semi-)random e-mail signature rotator"
HOMEPAGE="https://signify.sourceforge.net/"
SRC_URI="mirror://debian/pool/main/s/${PN}/${PN}_${PV}-1.tar.gz"
S="${WORKDIR}/${PN}"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"

RDEPEND="!app-crypt/signify
	dev-lang/perl"
DEPEND="${RDEPEND}"

src_prepare() {
	default
	sed -i 's/head -1/head -n1/' Makefile || die
}

src_compile(){ :; }

src_install() {
	emake PREFIX="${ED}"/usr MANDIR="${ED}"/usr/share/man install
	einstalldocs

	docinto examples
	dodoc examples/{Columned,Complex,Simple,SimpleOrColumned}
	docompress -x /usr/share/doc/${PF}/examples
}
