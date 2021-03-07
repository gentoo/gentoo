# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="A (semi-)random e-mail signature rotator"
HOMEPAGE="http://signify.sf.net/"
SRC_URI="mirror://debian/pool/main/s/${PN}/${PN}_${PV}-1.tar.gz"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64 ppc sparc x86"

RDEPEND="dev-lang/perl"
DEPEND="${RDEPEND}"

S=${WORKDIR}/${PN}

src_prepare() {
	default
	sed -i 's/head -1/head -n1/' Makefile || die
}

src_install() {
	emake PREFIX="${ED%/}"/usr MANDIR="${ED%/}"/usr/share/man install
	einstalldocs

	docinto examples
	dodoc examples/{Columned,Complex,Simple,SimpleOrColumned}
	docompress -x /usr/share/doc/${PF}/examples
}
