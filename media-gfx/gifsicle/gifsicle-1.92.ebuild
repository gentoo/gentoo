# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Create, manipulate, and optimize GIF images and animations"
HOMEPAGE="https://www.lcdf.org/~eddietwo/gifsicle/ https://github.com/kohler/gifsicle"
SRC_URI="https://www.lcdf.org/~eddietwo/${PN}/${P}.tar.gz"

LICENSE="GPL-2 MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"
IUSE="X"

RDEPEND="
	X? (
		x11-libs/libX11
		x11-libs/libXt
	)
"
DEPEND="
	${RDEPEND}
	X? ( x11-base/xorg-proto )
"
DOCS=(
	NEWS.md
	README.md
)

src_configure() {
	econf $(usex X "" "--disable-gifview")
}
