# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/xtoolwait/xtoolwait-1.3-r2.ebuild,v 1.5 2012/05/14 15:21:02 ssuominen Exp $

EAPI=4
inherit toolchain-funcs

DESCRIPTION="Xtoolwait notably decreases the startup time of an X session"
HOMEPAGE="http://ftp.x.org/contrib/utilities/xtoolwait-1.3.README"
SRC_URI="http://ftp.x.org/contrib/utilities/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

RDEPEND="x11-libs/libX11
	x11-libs/libXext"
DEPEND="${RDEPEND}
	app-text/rman
	x11-misc/imake
	x11-proto/xproto"

src_prepare() {
	xmkmf || die
	sed -i \
		-e '/CC = /d' -e '/EXTRA_LDOPTIONS = /d' \
		Makefile || die
}

src_compile() {
	emake \
		CC="$(tc-getCC)" \
		CCOPTIONS="${CFLAGS}" \
		EXTRA_LDOPTIONS="${LDFLAGS}"
}

src_install() {
	emake \
		BINDIR=/usr/bin \
		MANPATH=/usr/share/man \
		DOCDIR=/usr/share/doc/${PF} \
		DESTDIR="${D}" \
		install{,.man}

	dodoc CHANGES README
}
