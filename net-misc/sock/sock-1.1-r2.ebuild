# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="A shell interface to network sockets"
HOMEPAGE="http://atrey.karlin.mff.cuni.cz/~mj/linux.shtml"
SRC_URI="ftp://atrey.karlin.mff.cuni.cz/pub/local/mj/net/${P}.tar.gz"

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
