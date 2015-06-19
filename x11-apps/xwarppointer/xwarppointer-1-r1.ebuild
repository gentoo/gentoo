# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-apps/xwarppointer/xwarppointer-1-r1.ebuild,v 1.1 2010/09/28 17:35:31 jer Exp $

EAPI="2"

inherit toolchain-funcs

DESCRIPTION="Program to move the mouse cursor"
HOMEPAGE="http://www.ishiboo.com/~nirva/Projects/xwarppointer/"
SRC_URI="http://www.ishiboo.com/~nirva/Projects/xwarppointer/${PN}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

DEPEND="x11-libs/libX11"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}"

src_prepare() {
	sed -i Makefile \
		-e 's|^X11HOME=.*|X11HOME=/usr/X11R6|' \
		-e 's|^CFLAGS=|CFLAGS+=|' \
		-e 's| -o | $(LDFLAGS)&|' \
		|| die 'setting X11HOME failed'
}

src_compile() {
	emake CC=$(tc-getCC) || die
}

src_install() {
	dobin xwarppointer || die "install failed"
	dodoc README
}
