# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="A shell interface to network sockets"
SRC_URI="ftp://atrey.karlin.mff.cuni.cz/pub/local/mj/net/${P}.tar.gz"
HOMEPAGE="http://atrey.karlin.mff.cuni.cz/~mj/linux.shtml"
KEYWORDS="amd64 sparc x86"
LICENSE="GPL-2"
SLOT="0"

src_install () {
	dobin "${PN}"
	doman "${PN}.1"
	einstalldocs
}
