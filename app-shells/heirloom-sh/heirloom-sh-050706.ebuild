# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-shells/heirloom-sh/heirloom-sh-050706.ebuild,v 1.2 2013/05/10 07:49:18 patrick Exp $

inherit flag-o-matic toolchain-funcs

# slightly broken
RESTRICT="test"

DESCRIPTION="Heirloom Bourne Shell, derived from OpenSolaris code SVR4/SVID3"
HOMEPAGE="http://heirloom.sourceforge.net/sh.html"
SRC_URI="mirror://sourceforge/heirloom/${P}.tar.bz2"

LICENSE="CDDL"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND=""

src_compile() {
	append-cppflags -D_GNU_SOURCE
	emake \
		"CFLAGS=${CFLAGS}" \
		"CPPFLAGS=${CPPFLAGS}" \
		"LDFLAGS=${LDFLAGS}" \
		"LARGEF=" \
		"CC=$(tc-getCC)" || die
}

src_install() {
	exeinto /bin
	newexe sh jsh
	newman sh.1 jsh.1
}
