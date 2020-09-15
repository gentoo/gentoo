# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Libary for OpenGL applications with easy-to-code scene setup and selection"
HOMEPAGE="http://www.bioinformatics.org/ghemical/"
SRC_URI="http://www.bioinformatics.org/ghemical/download/current/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"

RDEPEND="
	virtual/opengl
	media-libs/freeglut"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=( "${FILESDIR}"/gcc-4.3.patch )

src_configure() {
	econf --disable-static
}

src_install() {
	default

	# no static archives
	find "${ED}" -name '*.la' -delete || die
}
