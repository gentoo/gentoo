# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit libtool

DESCRIPTION="begemot utility function library"
HOMEPAGE="https://people.freebsd.org/~harti/"
SRC_URI="https://people.freebsd.org/~harti/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~amd64-fbsd ~x86-fbsd"

src_prepare() {
	default
	elibtoolize
}

src_compile() {
	emake -j1
}
