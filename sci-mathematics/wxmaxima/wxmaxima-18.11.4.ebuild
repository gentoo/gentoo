# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
WX_GTK_VER="3.0"
PLOCALES="ca cs da de el es fi fr gl hu it ja kab nb pl pt_BR ru tr uk zh_CN zh_TW"
inherit cmake-utils wxwidgets l10n xdg-utils gnome2-utils

DESCRIPTION="Graphical frontend to Maxima, using the wxWidgets toolkit"
HOMEPAGE="http://wxmaxima-developers.github.io/wxmaxima/"
SRC_URI="https://github.com/wxMaxima-developers/wxmaxima/archive/Version-${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""
S="${WORKDIR}"/${PN}-Version-${PV}

DEPEND="
	dev-libs/libxml2:2
	x11-libs/wxGTK:${WX_GTK_VER}"
RDEPEND="${DEPEND}
	media-fonts/jsmath
	sci-visualization/gnuplot[wxwidgets]
	sci-mathematics/maxima"

src_prepare() {
	setup-wxwidgets
	cmake-utils_src_prepare

	sed -e "s|share/doc/${PN}|share/doc/${PF}|g" -i "${S}"/info/CMakeLists.txt \
		|| die "sed info/CMakeLists.txt failed"

	# locales
	rm_po() {
		rm "${S}"/locales/${1}.po || die "rm ${1}.po failed"
	}
	l10n_find_plocales_changes "${S}"/locales '' '.po'
	l10n_for_each_disabled_locale_do rm_po
}

pkg_postinst() {
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
	gnome2_icon_cache_update
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
	gnome2_icon_cache_update
}
