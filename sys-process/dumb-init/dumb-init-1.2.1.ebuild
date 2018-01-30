# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit flag-o-matic toolchain-funcs

DESCRIPTION="A minimal init system for Linux containers"
HOMEPAGE="https://github.com/Yelp/dumb-init"
SRC_URI="https://github.com/Yelp/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="static"
RESTRICT="test"

src_prepare() {
	default
	use static && append-cflags -static
	sed -e "s|^CFLAGS=.*|CFLAGS=-std=gnu99 ${CFLAGS}|" -i Makefile || die
}

src_compile() {
	CC=$(tc-getCC) emake
}

src_install() {
	dobin ${PN}
	dodoc README.md
}
