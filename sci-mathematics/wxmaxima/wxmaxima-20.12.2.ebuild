# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
WX_GTK_VER="3.0-gtk3"
PLOCALES="ca cs da de el en es fi fr gl hu it ja kab nb pl pt_BR ru tr uk zh_CN zh_TW"
inherit cmake wxwidgets l10n xdg

DESCRIPTION="Graphical frontend to Maxima, using the wxWidgets toolkit"
HOMEPAGE="https://wxmaxima-developers.github.io/wxmaxima/"
SRC_URI="https://github.com/wxMaxima-developers/wxmaxima/archive/Version-${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
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
	cmake_src_prepare

	sed -e "s|GPL.txt ||g" -e "s|share/doc/${PN}|share/doc/${PF}|g" -i CMakeLists.txt \
		|| die "sed CMakeLists.txt failed"
	sed -e "s|share/doc/${PN}|share/doc/${PF}|g" -i info/CMakeLists.txt \
		|| die "sed info/CMakeLists.txt failed"

	# locales
	rm_po() {
		rm locales/wxMaxima/${1}.po || die "rm ${1}.po failed"
		rm -f locales/manual/${1}.po
		rm -f info/${PN}.${1}.md
		rm -f info/${PN}.${1}.html
		sed -e "\\|/${1}/wxmaxima.1|d" -i data/CMakeLists.txt
	}
	l10n_find_plocales_changes locales/wxMaxima '' '.po'
	l10n_for_each_disabled_locale_do rm_po
}

src_install() {
	docompress -x /usr/share/doc/${PF}
	cmake_src_install
}
