# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Info Browser in TK"
HOMEPAGE="http://math-www.uni-paderborn.de/~axel/tkinfo/"
SRC_URI="http://math-www.uni-paderborn.de/~axel/${PN}/${P}.tar.gz"

LICENSE="Old-MIT GPL-1+"
SLOT="0"
KEYWORDS="alpha amd64 hppa ia64 ppc sparc x86"

RDEPEND="dev-lang/tk"
DEPEND="sys-apps/sed"

DOCS=( README )

src_prepare() {
	default
	sed -i \
		-e "1 s:^.*:#!/usr/bin/wish:" tkinfo || \
			die "sed tkinfo failed"
}

src_install () {
	dobin "${PN}"
	doman "${PN}.1"
}
