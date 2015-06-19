# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-cdr/cddetect/cddetect-2.1.ebuild,v 1.3 2012/01/03 10:33:56 ssuominen Exp $

EAPI=4
inherit toolchain-funcs

DESCRIPTION="A tool for detecting the type of a CD/DVD without mounting it"
HOMEPAGE="http://www.bellut.net/projects.html"
SRC_URI="http://www.bellut.net/files/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

S=${WORKDIR}

src_prepare() {
	sed -i -e '1i#include <limits.h>' ${PN}.c || die #337628
}

src_compile() {
	emake CC="$(tc-getCC)" CFLAGS="-Wall ${CFLAGS}"
}

src_install() {
	dobin ${PN}
}
