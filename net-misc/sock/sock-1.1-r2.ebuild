# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Shell interface to network sockets"
HOMEPAGE="https://mj.ucw.cz/sw/"
SRC_URI="https://mj.ucw.cz/download/net/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 sparc x86"

src_prepare() {
	default

	# Clang 16, bug #900256
	eautoreconf
}

src_install() {
	dobin ${PN}
	doman ${PN}.1
	einstalldocs
}
