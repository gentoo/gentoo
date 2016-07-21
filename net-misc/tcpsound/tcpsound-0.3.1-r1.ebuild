# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils toolchain-funcs

DESCRIPTION="Play sounds in response to network traffic"
LICENSE="BSD"
HOMEPAGE="http://www.ioplex.com/~miallen/tcpsound/"
SRC_URI="${HOMEPAGE}dl/${P}.tar.gz"
SLOT="0"
KEYWORDS="amd64 x86"

DEPEND="
	dev-libs/libmba
	media-libs/libsdl
	net-analyzer/tcpdump
"
RDEPEND="${DEPEND}"

DOCS=( README.txt elaborate.conf )

src_prepare() {
	epatch \
		"${FILESDIR}"/${P}-makefile.patch \
		"${FILESDIR}"/${P}-misc.patch
}

src_compile() {
	emake CC="$(tc-getCC)"
}
