# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PN="QComicBook"
CMAKE_IN_SOURCE_BUILD=1
PLOCALES="cs_CZ de_DE es_ES fi_FI fr_CA fr_FR it_IT ko_KR nl_NL pl_PL pt_BR ru_RU uk_UA zh_CN"
inherit cmake flag-o-matic plocale xdg

DESCRIPTION="Viewer for comic book archives containing jpeg/png images"
HOMEPAGE="https://github.com/stolowski/QComicBook"
SRC_URI="https://github.com/stolowski/${MY_PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE="debug"

RDEPEND="
	app-text/poppler[qt5]
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtprintsupport:5
	dev-qt/qtwidgets:5
	dev-qt/qtx11extras:5"
DEPEND="${RDEPEND}"
BDEPEND="dev-qt/linguist-tools:5"

DOCS=( AUTHORS ChangeLog NEWS README THANKS TODO )

S="${WORKDIR}/${MY_PN}-${PV}"

src_prepare() {
	rm_loc() {
		rm "i18n/${PN}_${1}.ts" || die "removing ${1} locale failed"
	}
	rm "i18n/${PN}_en_EN.ts" || die 'removing redundant english locale failed'
	plocale_find_changes "i18n" "${PN}_" ".ts"
	plocale_for_each_disabled_locale rm_loc

	# fix desktop file
	sed -e '/^Encoding/d' \
		-e '/^Icon/s/.png//' \
		-e '/^Categories/s/Application;//' \
		-i data/${PN}.desktop || die 'sed on desktop file failed'

	cmake_src_prepare
}

src_configure() {
	use !debug && append-cppflags -DQT_NO_DEBUG_OUTPUT
	cmake_src_configure
}

pkg_postinst() {
	xdg_pkg_postinst
	elog "For using QComicBook with compressed archives you may want to install:"
	elog "    app-arch/p7zip"
	elog "    app-arch/unace"
	elog "    app-arch/unrar or app-arch/rar"
	elog "    app-arch/unzip"
}
