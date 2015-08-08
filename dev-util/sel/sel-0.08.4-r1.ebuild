# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4
inherit toolchain-funcs

DESCRIPTION="A filemanager for shell scripts"
SRC_URI="http://www.rninet.de/darkstar/files/${P}.tar.gz"
HOMEPAGE="http://www.rninet.de/darkstar/sel.html"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ppc s390 sparc x86"
IUSE=""

RDEPEND=">=sys-libs/ncurses-5.1"
DEPEND="${RDEPEND}"

src_prepare () {
	sed -i -e "s:/usr/local/share/sel/help\.txt:/usr/share/sel/help\.txt:" \
		sel.c || die 'sed failed'
}

src_compile() {
	emake CC="$(tc-getCC)" CFLAGS="${CFLAGS}" LDLIBS="-lncurses"
}

src_install () {
	dobin sel
	doman sel.1
	insinto /usr/share/sel
	doins help.txt
	dodoc README.GER
}
