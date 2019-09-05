# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit toolchain-funcs

DESCRIPTION="Program to move the mouse cursor"
HOMEPAGE="http://www.ishiboo.com/~nirva/Projects/xwarppointer/"
SRC_URI="http://www.ishiboo.com/~nirva/Projects/xwarppointer/${PN}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ppc x86"

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
	emake CC="$(tc-getCC)"
}

src_install() {
	dobin "${PN}"
	dodoc README
}
