# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils toolchain-funcs

DESCRIPTION="a network benchmarking tool that measures net throughput with NetBIOS and TCP/IP protocols"
HOMEPAGE="http://www.ars.de/ars/ars.nsf/docs/netio"
SRC_URI='http://www.ars.de/ARS/ars.nsf/f24a6a0b94c22d82862566960071bf5a/aa577bc4be573b05c125706d004c75b5/$FILE/netio132.zip'

LICENSE="free-noncomm"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"
IUSE=""
RESTRICT="mirror" # bug #391789 comment #1

DEPEND="app-arch/unzip
	>=sys-apps/sed-4"

S="${WORKDIR}"

src_prepare() {
	edos2unix *.c *.h

	sed -i \
		-e "s|LFLAGS=\"\"|LFLAGS?=\"${LDFLAGS}\"|g" \
		-e 's|\(CC\)=|\1?=|g' \
		-e 's|\(CFLAGS\)=|\1+=|g' \
		Makefile || die
	epatch "${FILESDIR}"/${PN}-1.26-linux-include.patch
}

src_compile() {
	emake \
		CC="$(tc-getCC)" \
		CFLAGS="${CFLAGS}" \
		linux
}

src_install() {
	dobin netio
	dodoc netio.doc
}
