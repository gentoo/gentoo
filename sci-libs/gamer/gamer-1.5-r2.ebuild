# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="Geometry-preserving Adaptive MeshER"
HOMEPAGE="http://fetk.org/codes/gamer/index.html"
SRC_URI="http://www.fetk.org/codes/download/${P}.tar.gz"
S="${WORKDIR}/${PN}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
IUSE="doc"

RDEPEND=">=dev-libs/maloc-1.4"
DEPEND="${RDEPEND}"
BDEPEND="
	doc? (
		app-doc/doxygen
		media-gfx/graphviz
	)"

PATCHES=(
	"${FILESDIR}"/1.4-multilib.patch
	"${FILESDIR}"/1.4-doc.patch
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf $(usex doc '' '--with-doxygen= --with-dot=')
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die
}
