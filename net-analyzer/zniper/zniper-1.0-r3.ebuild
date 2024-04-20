# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Displays and kill active TCP connections seen by the selected interface"
HOMEPAGE="http://www.signedness.org/tools/"
SRC_URI="https://dev.gentoo.org/~jsmolic/distfiles/${P}.tgz"
S="${WORKDIR}/zniper"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="
	net-libs/libpcap
	sys-libs/ncurses:=
"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

src_prepare() {
	default
	sed -i \
		-e 's| -o | $(LDFLAGS)&|g' \
		-e 's|@make|@$(MAKE)|g' \
		-e 's|-lncurses|$(shell $(PKG_CONFIG) --libs ncurses)|g' \
		Makefile || die
	tc-export PKG_CONFIG
}

src_compile() {
	emake \
		CC="$(tc-getCC)" \
		CFLAGS="${CFLAGS}" \
		linux_x86
}

src_install() {
	dobin zniper
	doman zniper.1
}
