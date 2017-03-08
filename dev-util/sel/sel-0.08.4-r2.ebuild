# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs

DESCRIPTION="A filemanager for shell scripts"
SRC_URI="http://www.rninet.de/darkstar/files/${P}.tar.gz"
HOMEPAGE="http://www.rninet.de/darkstar/sel.html"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~ppc ~s390 ~sparc ~x86"

RDEPEND="sys-libs/ncurses:0="

DOCS=( "help.txt" README.GER whatsnew )

src_prepare () {
	default
	sed -i \
		-e "s:/usr/local/share/sel/help\.txt:/usr/share/sel/help\.txt:" \
		"${PN}.c" || die 'sed failed'
}

src_compile() {
	emake CC="$(tc-getCC)" CFLAGS="${CFLAGS}" LDLIBS="-lncurses"
}

src_install () {
	dobin "${PN}"
	doman "${PN}.1"
	einstalldocs
}
