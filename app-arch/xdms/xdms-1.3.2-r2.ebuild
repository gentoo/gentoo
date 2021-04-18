# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic toolchain-funcs

DESCRIPTION="xDMS - Amiga DMS disk image decompressor"
HOMEPAGE="https://zakalwe.fi/~shd/foss/xdms"
SRC_URI="https://zakalwe.fi/~shd/foss/xdms/${P}.tar.bz2"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="amd64 ~hppa ppc x86"

PATCHES=(
	"${FILESDIR}"/${PN}-1.3.2-respect-DESTDIR.patch
	"${FILESDIR}"/${PN}-1.3.2-dont-compress-man-pages.patch
)

src_prepare() {
	default

	sed -i Makefile.in \
		-e "s:COPYING::" \
		-e "s:share/doc/xdms-{VERSION}:share/doc/${PF}:" || die

	sed -i -e "s:-O2::" src/Makefile.in || die
}

src_configure() {
	tc-export CC

	if [[ ${CHOST} == *-darwin* ]] ; then
		# Needed to avoid typical "Undefined symbols for architecture x86_64"
		append-ldflags -undefined dynamic_lookup
	fi

	./configure --prefix="${EPREFIX}"/usr || die
}
