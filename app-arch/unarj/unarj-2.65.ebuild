# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit eutils toolchain-funcs

DESCRIPTION="Utility for opening arj archives"
HOMEPAGE="http://www.arjsoftware.com/"
SRC_URI="mirror://freebsd/ports/local-distfiles/ache/${P}.tgz"

LICENSE="arj"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 sparc x86 ~x86-fbsd ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos ~sparc-solaris ~x86-solaris"
IUSE=""

src_unpack() {
	unpack ${A}
	cd "${S}"

	epatch "${FILESDIR}"/${P}-CAN-2004-0947.patch
	epatch "${FILESDIR}"/${P}-sanitation.patch
	epatch "${FILESDIR}"/${P}-gentoo-fbsd.patch
}

src_compile() {
	tc-export CC
	emake || die
}

src_install() {
	dobin unarj || die 'dobin failed'
	dodoc unarj.txt technote.txt || die 'dodoc failed'
}
