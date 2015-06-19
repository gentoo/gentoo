# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/mail-filter/normalizemime/normalizemime-1.19.ebuild,v 1.2 2009/09/02 08:56:53 vapier Exp $

inherit toolchain-funcs

DESCRIPTION="Helper program to normalize MIME encoded messages"
HOMEPAGE="http://hyvatti.iki.fi/~jaakko/spam/"
SRC_URI="mirror://gentoo/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86 ~x86-fbsd"
IUSE=""

src_compile() {
	tc-export CC
	emake normalizemime || die
}

src_install() {
	dobin normalizemime || die
}
