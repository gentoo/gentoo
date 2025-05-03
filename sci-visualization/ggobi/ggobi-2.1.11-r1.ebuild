# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools xdg

DESCRIPTION="Visualization program for exploring high-dimensional data"
HOMEPAGE="http://www.ggobi.org/"
# source code release is not well published
#SRC_URI="http://www.ggobi.org/downloads/${P}.tar.bz2"
SRC_URI="mirror://debian/pool/main/g/${PN}/${PN}_${PV}.orig.tar.bz2"

LICENSE="CPL-1.0"
SLOT="0"
KEYWORDS="amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc minimal nls"

RDEPEND="
	dev-libs/libxml2:2=
	media-gfx/graphviz
	x11-libs/gtk+:2"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${PN}-2.1.8-plugindir.patch
	"${FILESDIR}"/${PN}-2.1.9-as-needed.patch
	"${FILESDIR}"/${PN}-2.1.10-desktop.patch
	"${FILESDIR}"/${PN}-2.1.11-Wformat-security.patch
)

src_prepare() {
	default
	sed -e 's|ND_coord_i|ND_coord|' \
		-i plugins/GraphLayout/graphviz.c || die
	rm m4/libtool.m4 m4/lt*m4 plugins/*/aclocal.m4 || die

	# need the ${S} for recursivity lookup
	AT_M4DIR="${S}"/m4 eautoreconf
}

src_configure() {
	econf \
		--disable-rpath \
		$(use_enable nls) \
		$(use_with !minimal all-plugins)
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
