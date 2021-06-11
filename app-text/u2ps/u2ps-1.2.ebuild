# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="A text to PostScript converter like a2ps, but supports UTF-8"
HOMEPAGE="https://github.com/arsv/u2ps"
SRC_URI="https://github.com/arsv/${PN}/releases/download/${PV}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ~x86"

DEPEND="app-text/ghostscript-gpl"
RDEPEND="${DEPEND}"
BDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/${PN}-1.1-nostrip.patch"
	"${FILESDIR}/${PN}-1.2-respect-ldflags.patch"
)

src_configure() {
	# this isnt autoconf, so econf fails...
	tc-export CC
	./configure \
		--prefix="${EPREFIX}"/usr \
		--datadir="${EPREFIX}"/usr/share \
		--mandir="${EPREFIX}"/usr/share/man \
		--with-gs="${EPREFIX}"/usr/bin/gs \
		|| die 'configure failed'
}
