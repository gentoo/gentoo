# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

SRC_URI="https://github.com/bartobri/no-more-secrets/archive/v${PV}.tar.gz -> ${P}.tar.gz"
KEYWORDS="~amd64"
DESCRIPTION="Recreate decrypting text from 1992 movie 'Sneakers'"
HOMEPAGE="https://github.com/bartobri/no-more-secrets"
LICENSE="GPL-3"
SLOT=0
DEPEND="sys-libs/ncurses:0="
RDEPEND="${DEPEND}"

src_prepare() {
	sed -i	-e 's#CC =#CC ?=#' \
		-e 's#prefix =#prefix ?=#' \
		-e 's#CFLAGS =#CFLAGS ?=#' Makefile || die
	default
}

src_compile() {
	CC="$(tc-getCC)" CFLAGS="${CFLAGS}" emake
}

src_install() {
	prefix="/usr" DESTDIR="${ED}" emake install
}
