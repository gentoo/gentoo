# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic toolchain-funcs

DESCRIPTION="A program to scan through a MPEG file and count the number of GOPs and frames"
HOMEPAGE="http://www.iamnota.net/mpglen/"
SRC_URI="mirror://gentoo/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

S="${WORKDIR}/${PN}"

src_prepare() {
	default

	# awful Makefile, just rely on implicit rules
	rm Makefile || die
}

src_configure() {
	append-lfs-flags
	tc-export CC
}

src_compile() {
	emake mpglen
}

src_install () {
	dobin ${PN}
	dodoc AUTHORS Changelog README
}
