# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="2"

inherit eutils toolchain-funcs

DESCRIPTION="Redir is a port redirector"
HOMEPAGE="http://sammy.net/~sammy/hacks/"
SRC_URI="http://sammy.net/~sammy/hacks/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha ~amd64 ~hppa ~mips sparc x86"
IUSE=""

DEPEND=""
RDEPEND=""

src_configure() {
	epatch "${FILESDIR}/${P}-include.patch"
}

src_compile() {
	emake \
		CC="$(tc-getCC)" \
		CFLAGS="${CFLAGS}" \
		LDFLAGS="${LDFLAGS}" || \
		die "emake failed"
}

src_install() {
	dobin redir || die "dobin failed"
	newman redir.man redir.1 || die "doman failed"
	dodoc CHANGES README transproxy.txt || die "dodoc failed"
}
