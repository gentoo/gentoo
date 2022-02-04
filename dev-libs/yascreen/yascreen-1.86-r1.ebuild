# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Yet Another Screen Library - curses replacement"
HOMEPAGE="https://github.com/bbonev/yascreen"
SRC_URI="https://github.com/bbonev/yascreen/releases/download/v${PV}/${P}.tar.xz"

LICENSE="LGPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

PATCHES=(
	"${FILESDIR}/${P}-fix-install.patch"
)

src_prepare() {
	default
	sed -e '/INSTALL/s/-Ds/-D/' \
		-e '/INSTALL/s/-s//' \
		-e "s:/usr/local:${EPREFIX}/usr:" \
		-e "s:/lib/:/$(get_libdir)/:" \
		-i Makefile.main || die
}

src_compile() {
	emake CC="$(tc-getCC)" AR="$(tc-getAR)" RANLIB="$(tc-getRANLIB)" NO_FLTO=1
}

src_install() {
	default
	find "${D}" -name '*.a' -delete || die
}
