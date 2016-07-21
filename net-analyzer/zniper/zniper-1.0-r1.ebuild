# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit toolchain-funcs

DESCRIPTION="Displays and kill active TCP connections seen by the selected interface"
HOMEPAGE="http://www.signedness.org/tools/"
SRC_URI="https://dev.gentoo.org/~jer/${P}.tgz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"

DEPEND="
	net-libs/libpcap
	sys-libs/ncurses
"
RDEPEND="
	${DEPEND}
	virtual/pkgconfig
"

S=${WORKDIR}/"zniper"

src_prepare() {
	sed -i \
		-e 's| -o | $(LDFLAGS)&|g' \
		-e 's|@make|@$(MAKE)|g' \
		-e 's|-lncurses|$(shell $(PKG_CONFIG) --libs ncurses)|g' \
		Makefile || die
	tc-export PKG_CONFIG
}

src_compile() {
	emake \
		CC=$(tc-getCC) \
		CFLAGS="${CFLAGS}" \
		linux_x86
}

src_install() {
	dobin zniper
	doman zniper.1
}
