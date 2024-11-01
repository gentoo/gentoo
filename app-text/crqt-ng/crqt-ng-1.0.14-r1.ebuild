# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PLOCALES="bg cs hu nl ru uk"
inherit cmake plocale xdg

DESCRIPTION="Cross-platform e-book reader"
HOMEPAGE="https://gitlab.com/coolreader-ng/crqt-ng"
SRC_URI="https://gitlab.com/coolreader-ng/${PN}/-/archive/${PV}/${P}.tar.bz2"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~arm64 x86"
IUSE="+qt6 +gif +svg +chm +harfbuzz +libunibreak +fribidi +zstd +libutf8proc"

CDEPEND=">=app-text/crengine-ng-0.9.7:0=[png,jpeg,fontconfig,gif=,svg=,chm=,harfbuzz=,fribidi=,zstd=,libutf8proc=]
	qt6? (
		dev-qt/qtbase:6[gui,widgets]
	)
	!qt6? (
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtwidgets:5
	)"
RDEPEND="${CDEPEND}"
BDEPEND="${CDEPEND}
	qt6? (
		dev-qt/qttools:6[linguist]
	)
	!qt6? (
		dev-qt/linguist-tools:5
	)"

src_prepare() {
	cmake_src_prepare
	xdg_environment_reset

	# locales
	plocale_find_changes "${S}"/src/i18n 'crqt_' '.ts'
	sed -e "s|set(LANGUAGES .*)|set(LANGUAGES $(plocale_get_locales))|i" \
		-i "${S}"/src/CMakeLists.txt \
		|| die "sed CMakeLists.txt failed"
}

src_configure() {
	CMAKE_USE_DIR="${S}"
	CMAKE_BUILD_TYPE="Release"
	local mycmakeargs
	if use qt6; then
		mycmakeargs=(-DUSE_QT=QT6)
	else
		mycmakeargs=(-DUSE_QT=QT5)
	fi
	cmake_src_configure
}
