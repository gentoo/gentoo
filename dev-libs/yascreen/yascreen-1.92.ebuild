# Copyright 2021-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Yet Another Screen Library - curses replacement"
HOMEPAGE="https://github.com/bbonev/yascreen"
SRC_URI="https://github.com/bbonev/yascreen/releases/download/v${PV}/${P}.tar.xz"

LICENSE="LGPL-3+"
SLOT="0/1"
KEYWORDS="~amd64 ~x86"

src_prepare() {
	default
	sed -e '/INSTALL/s/-Ds/-D/' \
		-e '/INSTALL.*libyascreen.a/d' -e 's/libyascreen.a//' -i Makefile.main || die
	grep -q -F "SOVERM:=1" Makefile.main || die "subslot changed"
}

src_compile() {
	emake CC="$(tc-getCC)" PREFIX="${EPREFIX}/usr" LIBDIR="/$(get_libdir)/" NO_FLTO=1
}

src_install() {
	emake DESTDIR="${D}" PREFIX="${EPREFIX}/usr" LIBDIR="/$(get_libdir)/" install
	einstalldocs
}
