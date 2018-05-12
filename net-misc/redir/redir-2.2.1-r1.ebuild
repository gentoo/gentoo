# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils toolchain-funcs

DESCRIPTION="Redir is a port redirector"
HOMEPAGE="http://sammy.net/~sammy/hacks/"
SRC_URI="http://sammy.net/~sammy/hacks/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~mips ~sparc ~x86"

PATCHES=( "${FILESDIR}/${P}-include.patch" )
DOCS=( CHANGES README transproxy.txt )

src_compile() {
	emake \
		CC="$(tc-getCC)" \
		CFLAGS="${CFLAGS}" \
		LDFLAGS="${LDFLAGS}"
}

src_install() {
	dobin "${PN}"
	newman "${PN}.man" "${PN}.1"
}
