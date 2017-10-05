# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Synchronize two directory trees in a fast way"
HOMEPAGE="https://sourceforge.net/projects/mirdir/"
SRC_URI="mirror://sourceforge/${PN}/${P}-Unix.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

S="${WORKDIR}/${P}-UNIX"

src_prepare() {
	default
	# Disable stripping, bug 239939
	sed -i -e 's:strip .*::' Makefile.in || die
}

src_install() {
	dobin "bin/${PN}"
	doman "${PN}.1"
	einstalldocs
}
