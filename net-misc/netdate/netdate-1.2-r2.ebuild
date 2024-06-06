# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Utility to set date and time by ARPA Internet RFC 868"
HOMEPAGE="ftp://ftp.suse.com/pub/people/kukuk/ipv6/"
SRC_URI="ftp://ftp.suse.com/pub/people/kukuk/ipv6/${P}.tar.bz2"
S="${WORKDIR}/${PN}"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="amd64 arm ~mips ~s390 sparc x86"

DOCS=( README )

src_compile(){
	emake CC="$(tc-getCC)"
}

src_install() {
	dobin "${PN}"
	doman "${PN}.8"
	einstalldocs
}
