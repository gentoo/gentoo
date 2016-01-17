# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit toolchain-funcs

DESCRIPTION="A tool to query or alter a process' scheduling policy"
HOMEPAGE="http://freequaos.host.sk/schedtool"
SRC_URI="http://freequaos.host.sk/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT=0
KEYWORDS="amd64 ~arm ~mips ppc x86 ~amd64-linux ~x86-linux"
IUSE=""

src_prepare() {
	sed -i '/^CFLAGS=/d;/^install:/s/install-doc//' Makefile || die
}

src_compile() {
	emake CC="$(tc-getCC)"
}

src_install() {
	emake DESTPREFIX="${ED}"/usr install
	dodoc CHANGES INSTALL PACKAGERS README SCHED_DESIGN TODO TUNING
}
