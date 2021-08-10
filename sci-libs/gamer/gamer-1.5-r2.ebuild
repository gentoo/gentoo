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
		media-gfx/graphviz
		app-doc/doxygen
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
	export FETK_INCLUDE="${ESYSROOT}"/usr/include
	export FETK_LIBRARY="${ESYSROOT}"/usr/$(get_libdir)

	econf \
		--disable-static \
		--disable-triplet \
		--with-doxygen=$(usex doc "${BROOT}"/usr/bin/doxygen '') \
		--with-dot=$(usex doc "${BROOT}"/usr/bin/dot '')
}

src_install() {
	default

	# no static archives
	find "${ED}" -name '*.la' -delete || die
}
