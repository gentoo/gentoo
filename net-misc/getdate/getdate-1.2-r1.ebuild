# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

MY_PN="${PN}_rfc868"
MY_P="${MY_PN}-${PV}"

inherit toolchain-funcs

DESCRIPTION="Network Date/Time Query and Set Local Date/Time Utility"
HOMEPAGE="http://www.ibiblio.org/pub/Linux/system/network/misc/"
SRC_URI="http://www.ibiblio.org/pub/Linux/system/network/misc/${MY_P}.tar.gz"

LICENSE="GPL-1+"
SLOT="0"
KEYWORDS="amd64 ~mips ppc x86"
IUSE=""

S="${WORKDIR}/${MY_P}"

src_prepare() {
	sed -i -e "/errno.h/ a\#include <string.h>" getdate.c || die
	# Respect CFLAGS
	sed -i -e "/CFLAGS/d" Makefile || die
}

src_compile() {
	emake CC="$(tc-getCC)"
}

src_install() {
	dobin getdate
	doman getdate.8
	dodoc README getdate-cron
}
