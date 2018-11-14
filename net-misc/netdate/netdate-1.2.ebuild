# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=0

DESCRIPTION="A Utility to synchronize the time with ntp-servers"
HOMEPAGE="ftp://ftp.suse.com/pub/people/kukuk/ipv6/"
SRC_URI="ftp://ftp.suse.com/pub/people/kukuk/ipv6/${P}.tar.bz2"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="amd64 arm ~mips s390 sh sparc x86"
IUSE=""

DEPEND=""

S=${WORKDIR}/${PN}

src_compile() {
	emake || die "make failed"
}

src_install() {
	dobin netdate || die
	doman netdate.8
	dodoc README
}
