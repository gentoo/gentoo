# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit autotools flag-o-matic libtool gnome2-utils ltprune

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

PATCHES=(
	"${FILESDIR}"/${P}-gentoo-r1.patch
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
		itlocaledir='/usr/share/locale' \
		pixmapsdir='/usr/share/pixmaps' \
		desktopdir='/usr/share/applications' \
		install
	dodoc AUTHORS NEWS README
	prune_libtool_files
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
