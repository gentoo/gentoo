# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit xdg

DESCRIPTION="Visualization program for exploring high-dimensional data"
HOMEPAGE="http://www.ggobi.org/"
# source code release is not well published
#SRC_URI="http://www.ggobi.org/downloads/${P}.tar.bz2"
SRC_URI="https://github.com/ggobi/ggobi/releases/download/${PV}/${P}.tar.gz"

LICENSE="CPL-1.0"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc minimal nls"

RDEPEND="
	dev-libs/libxml2:2
	media-gfx/graphviz
	x11-libs/gtk+:2"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${PN}-2.1.10-desktop.patch
)

src_prepare() {
	default

	# need the ${S} for recursivity lookup
	#AT_M4DIR="${S}"/m4 eautoreconf
}

src_configure() {
	econf \
		--disable-rpath \
		$(use_enable nls)
}

src_compile() {
	emake all ggobirc
}

src_install() {
	default

	insinto /etc/xdg/ggobi
	doins ggobirc

	if ! use doc; then
		rm "${ED}"/usr/share/doc/${PF}/*.pdf || die
	fi

	# no static archives
	find "${ED}" -name '*.la' -delete || die
}
