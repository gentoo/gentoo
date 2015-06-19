# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-editors/ersatz-emacs/ersatz-emacs-20060515.ebuild,v 1.10 2013/02/28 16:43:13 ulm Exp $

EAPI=4

inherit eutils toolchain-funcs

DESCRIPTION="A very minimal imitation of the famous GNU Emacs editor"
HOMEPAGE="http://hunter.apana.org.au/~cjb/Code/"
# taken from http://hunter.apana.org.au/~cjb/Code/ersatz.tar.gz
SRC_URI="mirror://gentoo/${P}.tar.gz"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="!app-editors/ee
	sys-libs/ncurses"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S="${WORKDIR}"

src_prepare() {
	epatch "${FILESDIR}"/${P}-gentoo.patch
	sed -i -e "s%/usr/local/share/%/usr/share/doc/${PF}/%" ee.1 \
		|| die "sed failed"
}

src_compile() {
	emake CC="$(tc-getCC)" \
		CFLAGS="${CFLAGS} -Wall" \
		LFLAGS="${LDFLAGS} $("$(tc-getPKG_CONFIG)" --libs ncurses)"
}

src_install() {
	# Note: /usr/bin/ee is "easy edit" on FreeBSD, so if this
	# is ever keyworded *-fbsd the binary has to be renamed.
	dobin ee
	doman ee.1
	dodoc ChangeLog ERSATZ.keys README
}
