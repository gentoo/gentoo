# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="library that provides an easy API to Linux serial ports"
HOMEPAGE="http://ezv24.sourceforge.net"
SRC_URI="mirror://sourceforge/ezv24/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~alpha amd64 ppc sparc x86"

HTML_DOCS=( api-html/. )

PATCHES=(
	"${FILESDIR}"/${P}-build.patch
	"${FILESDIR}"/${P}-test.patch
)

src_prepare() {
	tc-export AR CC RANLIB
	default
	sed -i -e 's:__LINUX__:__linux__:' *.c *.h || die
}

src_install() {
	export NO_LDCONFIG="stupid"
	emake DESTDIR="${D}" PREFIX="${EPREFIX}/usr" \
		LIBDIR="${EPREFIX}/usr/$(get_libdir)" install
	einstalldocs
}
