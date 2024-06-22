# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Info Browser in TK"
HOMEPAGE="http://math-www.uni-paderborn.de/~axel/tkinfo/"
SRC_URI="http://math-www.uni-paderborn.de/~axel/${PN}/${P}.tar.gz"

LICENSE="Old-MIT GPL-1+"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~sparc ~x86"

RDEPEND="dev-lang/tk"

src_prepare() {
	default
	sed -e "1 s:^.*:#!/usr/bin/env wish:" \
		-i tkinfo || die "sed tkinfo failed"
}

src_install() {
	dobin tkinfo
	doman tkinfo.1
}
