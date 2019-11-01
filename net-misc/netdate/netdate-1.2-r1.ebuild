# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="utility to synchronize the time with ntp-servers"
HOMEPAGE="ftp://ftp.suse.com/pub/people/kukuk/ipv6/"
SRC_URI="ftp://ftp.suse.com/pub/people/kukuk/ipv6/${P}.tar.bz2"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="amd64 arm ~mips s390 sh sparc x86"

S="${WORKDIR}/${PN}"

DOCS=( README )

src_install() {
	dobin "${PN}"
	doman "${PN}.8"
	einstalldocs
}
