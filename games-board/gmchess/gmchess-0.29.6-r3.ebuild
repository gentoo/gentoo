# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit autotools flag-o-matic xdg

DESCRIPTION="Chinese chess with gtkmm and c++"
HOMEPAGE="https://github.com/lerosua/gmchess"
SRC_URI="https://${PN}.googlecode.com/files/${P}.tar.bz2"
RESTRICT="test"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-cpp/gtkmm:2.4"
RDEPEND=${DEPEND}
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${P}-gentoo-r1.patch
	"${FILESDIR}"/${P}_fix_build_segfault.patch
)

src_prepare() {
	default
	mv configure.{in,ac}
	eautoreconf
}

src_configure() {
	append-cxxflags -std=c++11
	econf \
		--disable-static \
		--localedir='/usr/share/locale'
}

src_install() {
	emake DESTDIR="${D}" \
		localedir="${EPREFIX}"/usr/share/locale \
		pixmapsdir="${EPREFIX}"/usr/share/pixmaps \
		desktopdir="${EPREFIX}"/usr/share/applications \
		install
	dodoc AUTHORS NEWS README
	find "${ED}" -name "*.la" -delete || die
}
