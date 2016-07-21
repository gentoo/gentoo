# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="2"

inherit eutils toolchain-funcs

DESCRIPTION="control magnetic tape drive operation"
HOMEPAGE="http://www.ibiblio.org/pub/linux/system/backup/"
SRC_URI="http://www.ibiblio.org/pub/linux/system/backup/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 hppa ia64 ~mips ppc ppc64 sparc x86"
IUSE=""

src_prepare() {
	sed -i -e "s:-O2:${CFLAGS}:g" Makefile
}

src_compile() {
	# Builds straight from .c to final binary
	emake CC="$(tc-getCC)" CFLAGS="${CFLAGS} ${LDFLAGS}" || die
}

src_install() {
	dosbin mt stinit || die
	doman mt.1 stinit.8
	dodoc README* stinit.def.examples
}
