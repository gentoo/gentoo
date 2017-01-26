# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit flag-o-matic

DESCRIPTION="A minimal init system for Linux containers"
HOMEPAGE="https://github.com/Yelp/${PN}"
SRC_URI="https://github.com/Yelp/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="static"
RESTRICT="test"

src_prepare() {
	eapply_user
	use static && append-cflags -static
	sed -e "s|^CFLAGS=.*|CFLAGS=-std=gnu99 ${CFLAGS}|" -i Makefile || die
}

src_install() {
	dobin ${PN}
	dodoc README.md
}
