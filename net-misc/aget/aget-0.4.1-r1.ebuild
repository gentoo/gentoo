# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=3

inherit eutils toolchain-funcs

DESCRIPTION="multithreaded HTTP download accelerator"
HOMEPAGE="http://www.enderunix.org/aget/"
SRC_URI="http://www.enderunix.org/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm ~mips ~ppc ppc64 ~sparc x86 ~amd64-linux ~x86-linux"
IUSE=""

src_prepare() {
	epatch "${FILESDIR}"/${PF}.patch
}

src_compile() {
	emake CC="$(tc-getCC)" || die
}

src_install() {
	emake DESTDIR="${ED}" install || die
	dodoc AUTHORS ChangeLog README* THANKS TODO || die
}
