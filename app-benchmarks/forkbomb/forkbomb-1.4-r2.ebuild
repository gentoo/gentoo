# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Controlled fork() bomber for testing heavy system load"
HOMEPAGE="http://home.tiscali.cz:8080/~cz210552/forkbomb.html"
SRC_URI="http://home.tiscali.cz:8080/~cz210552/distfiles/${P}.tar.gz"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64 ~x86"

src_prepare() {
	sed -i '/^all/s/tags//' Makefile || die
	default
}

src_install() {
	dobin ${PN}
	doman ${PN}.8
}
