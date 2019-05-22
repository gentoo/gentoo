# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=0

inherit libtool

DESCRIPTION="begemot utility function library"
HOMEPAGE="https://people.freebsd.org/~harti/"
SRC_URI="https://people.freebsd.org/~harti/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~amd64-fbsd ~x86-fbsd"
IUSE=""

DEPEND=""

src_compile() {
	elibtoolize
	econf || die "econf failed"
	emake -j1 || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"

	dodoc README
}
