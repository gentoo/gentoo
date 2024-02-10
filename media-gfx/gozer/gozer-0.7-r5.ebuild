# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="tool for rendering arbitrary text as graphics, using ttfs and styles"
HOMEPAGE="http://www.linuxbrit.co.uk/gozer/"
SRC_URI="http://www.linuxbrit.co.uk/downloads/${P}.tar.gz"

LICENSE="feh LGPL-2+"
SLOT="0"
KEYWORDS="amd64 ppc x86"

RDEPEND="
	media-libs/giblib
	media-libs/imlib2
"
DEPEND="
	${RDEPEND}
	x11-libs/libXext
"

PATCHES=(
	"${FILESDIR}"/${P}-fix-build-system.patch
	"${FILESDIR}"/${P}-fix-build-with-clang16.patch
)

src_prepare() {
	default

	mv configure.{in,ac} || die
	eautoreconf
}
