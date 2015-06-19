# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-process/schedtool/schedtool-1.3.0-r1.ebuild,v 1.8 2014/08/10 20:11:39 slyfox Exp $

EAPI=4

inherit toolchain-funcs

DESCRIPTION="A tool to query or alter a process' scheduling policy"
HOMEPAGE="http://freequaos.host.sk/schedtool"
SRC_URI="http://freequaos.host.sk/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT=0
KEYWORDS="amd64 ~mips ppc x86 ~amd64-linux ~x86-linux"
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
