# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Library that provides an easy API to Linux serial ports"
HOMEPAGE="https://ezv24.sourceforge.net"
SRC_URI="https://downloads.sourceforge.net/ezv24/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~alpha amd64 ~ppc ~sparc ~x86"

HTML_DOCS=( api-html/. )

PATCHES=(
	"${FILESDIR}"/${P}-build.patch
	"${FILESDIR}"/${P}-test.patch
	"${FILESDIR}"/${P}-clang16-build-fix.patch
)

src_prepare() {
	default

	tc-export AR CC RANLIB
	sed -i -e 's:__LINUX__:__linux__:' *.c *.h || die
}

src_install() {
	export NO_LDCONFIG="stupid"
	emake DESTDIR="${D}" PREFIX="${EPREFIX}/usr" \
		LIBDIR="${EPREFIX}/usr/$(get_libdir)" install
	einstalldocs

	find "${ED}" -name '*.a' -delete || die
}
