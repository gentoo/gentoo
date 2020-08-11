# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
WX_GTK_VER="3.0"
PLOCALES="ca cs da de el en es fi fr gl hu it ja kab nb pl pt_BR ru tr uk zh_CN zh_TW"
inherit cmake-utils wxwidgets l10n xdg

DESCRIPTION="Graphical frontend to Maxima, using the wxWidgets toolkit"
HOMEPAGE="https://wxmaxima-developers.github.io/wxmaxima/"
SRC_URI="https://github.com/wxMaxima-developers/wxmaxima/archive/Version-${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
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
		rm "${S}"/locales/wxMaxima/${1}.po || die "rm ${1}.po failed"
		rm -f "${S}"/locales/manual/${1}.po
		rm -f "${S}"/locales/wxwin/${1}.po
		rm -f "${S}"/info/${PN}.${1}.md
		rm -f "${S}"/info/${PN}.${1}.html
	}
	l10n_find_plocales_changes "${S}"/locales/wxMaxima '' '.po'
	l10n_for_each_disabled_locale_do rm_po
}

src_install() {
	docompress -x /usr/share/doc/${PF}
	cmake-utils_src_install
}
