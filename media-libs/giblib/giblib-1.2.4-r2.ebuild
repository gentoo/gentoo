# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="A graphics library built on top of imlib2"
HOMEPAGE="http://freshmeat.sourceforge.net/projects/giblib http://www.linuxbrit.co.uk/giblib/"
SRC_URI="http://www.linuxbrit.co.uk/downloads/${P}.tar.gz"

LICENSE="feh"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~arm64 ~hppa ~mips ppc ppc64 ~riscv sparc x86"

RDEPEND="
	media-libs/freetype
	media-libs/imlib2:=[X]
	x11-libs/libX11
	x11-libs/libXext
"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${PN}-1.2.4-fix-build-system.patch
	"${FILESDIR}"/${PN}-1.2.4-use-pkg-config-imlib2.patch
)

src_prepare() {
	default

	rm configure.in || die
	eautoreconf
}

src_install() {
	default

	# no static archives
	find "${ED}" -name '*.la' -delete || die
}
