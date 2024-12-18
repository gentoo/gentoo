# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

WX_GTK_VER="3.2-gtk3"
PLOCALES="ca cs da de el en es fi fr gl hu it ja kab nb pl pt_BR ru tr uk zh_CN zh_TW"
inherit cmake plocale wxwidgets xdg

DESCRIPTION="Graphical frontend to Maxima, using the wxWidgets toolkit"
HOMEPAGE="https://wxmaxima-developers.github.io/wxmaxima/"
SRC_URI="https://github.com/wxMaxima-developers/wxmaxima/archive/Version-${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}"/${PN}-Version-${PV}

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="test webkit"
RESTRICT="!test? ( test )"

DEPEND="
	dev-libs/libxml2:2
	x11-libs/wxGTK:${WX_GTK_VER}[webkit?]"
RDEPEND="${DEPEND}
	media-fonts/jsmath
	sci-visualization/gnuplot[wxwidgets]
	sci-mathematics/maxima"

src_prepare() {
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
	plocale_find_changes locales/wxMaxima '' '.po'
	plocale_for_each_disabled_locale rm_po
}

src_configure() {
	setup-wxwidgets

	local mycmakeargs=(
		-DWXM_UNIT_TESTS=$(usex test)
		-DWXM_DISABLE_WEBVIEW=$(usex webkit OFF ON)
	)

	cmake_src_configure
}

src_test() {
	# Just run the unit tests manually for now as tests fail in a non-descriptive
	# way even with virtualx
	# bug #736695
	cd "${BUILD_DIR}/test/unit_tests" || die

	local tests=(
		AFontSize
	)

	local test
	for test in "${tests[@]}" ; do
		./test_${test} || die "Unit test ${test} failed!"
	done
}

src_install() {
	docompress -x /usr/share/doc/${PF}
	cmake_src_install
}
