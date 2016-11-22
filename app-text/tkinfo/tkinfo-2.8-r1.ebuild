# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DESCRIPTION="Info Browser in TK"
HOMEPAGE="http://math-www.uni-paderborn.de/~axel/tkinfo/"
SRC_URI="http://math-www.uni-paderborn.de/~axel/tkinfo/${P}.tar.gz"

KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~sparc ~x86"
IUSE=""
LICENSE="freedist"
SLOT="0"

RDEPEND="dev-lang/tk"
DEPEND="sys-apps/sed"

src_prepare() {
	default
	sed -i \
		-e "1 s:^.*:#!/usr/bin/wish:" tkinfo || \
			die "sed tkinfo failed"
}

src_install () {
	dobin "${PN}"
	doman "${PN}.1"
	dodoc README
}
