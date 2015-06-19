# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-benchmarks/forkbomb/forkbomb-1.4.ebuild,v 1.2 2008/12/31 06:26:44 mr_bones_ Exp $

DESCRIPTION="Controlled fork() bomber for testing heavy system load"
HOMEPAGE="http://home.tiscali.cz:8080/~cz210552/forkbomb.html"
SRC_URI="http://home.tiscali.cz:8080/~cz210552/distfiles/${P}.tar.gz"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

src_unpack() {
	unpack ${A}
	cd "${S}"
	sed -i '/^all/s/tags//' Makefile || die "sed failed"
}

src_install() {
	dobin ${PN} || die "dobin failed"
	doman ${PN}.8
}
