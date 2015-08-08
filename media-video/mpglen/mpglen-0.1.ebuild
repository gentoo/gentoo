# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit flag-o-matic toolchain-funcs

DESCRIPTION="A program to scan through a MPEG file and count the number of GOPs and frames"
HOMEPAGE="http://www.iamnota.net/mpglen/"
SRC_URI="http://www.iamnota.net/mpglen/${PN}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

S=${WORKDIR}/${PN}

src_unpack() {
	unpack ${A}
	cd "${S}"
	echo 'all: mpglen' > Makefile
	append-lfs-flags
}

src_compile() {
	tc-export CC
	emake || die "emake failed"
}

src_install () {
	dobin ${PN} || die
	dodoc AUTHORS Changelog README
}
