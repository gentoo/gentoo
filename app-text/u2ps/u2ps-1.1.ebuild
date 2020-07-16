# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="A text to PostScript converter like a2ps, but supports UTF-8"
HOMEPAGE="https://github.com/arsv/u2ps"
SRC_URI="https://github.com/arsv/${PN}/releases/download/${PV}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="app-text/ghostscript-gpl"
RDEPEND="${DEPEND}"
BDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}/${P}-nostrip.patch" )

src_configure() {
	# this isnt autoconf, so econf fails...
	./configure \
		--prefix=/usr \
		--datadir=/usr/share \
		--mandir=/usr/share/man \
		--with-gs=/usr/bin/gs \
		|| die 'configure failed'
}
