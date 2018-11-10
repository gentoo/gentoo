# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

CMAKE_IN_SOURCE_BUILD=1
PLOCALES="cs_CZ de_DE es_ES fi_FI fr_CA fr_FR it_IT ko_KR nl_NL pl_PL pt_BR ru_RU uk_UA zh_CN"
inherit cmake-utils flag-o-matic l10n vcs-snapshot

DESCRIPTION="A viewer for comic book archives containing jpeg/png images"
HOMEPAGE="http://qcomicbook.org/"
SRC_URI="https://github.com/stolowski/QComicBook/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE="debug"

DEPEND="app-text/poppler[qt5]
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtprintsupport:5
	dev-qt/qtwidgets:5
	dev-qt/qtx11extras:5"
RDEPEND="${DEPEND}"

DOCS=( AUTHORS ChangeLog NEWS README THANKS TODO )

src_prepare() {
	rm_loc() {
	        rm "i18n/${PN}_${1}.ts" || die "removing ${1} locale failed"
	}
	rm "i18n/${PN}_en_EN.ts" || die 'removing redundant english locale failed'
	l10n_find_plocales_changes "i18n" "${PN}_" ".ts"
	l10n_for_each_disabled_locale_do rm_loc

	# fix desktop file
	sed -i \
		-e '/^Encoding/d' \
		-e '/^Icon/s/.png//' \
		-e '/^Categories/s/Application;//' \
		"data/${PN}.desktop" || die 'sed on desktop file failed'

	cmake-utils_src_prepare
}

src_configure() {
	use !debug && append-cppflags -DQT_NO_DEBUG_OUTPUT
	cmake-utils_src_configure
}

pkg_postinst() {
	elog "For using QComicBook with compressed archives you may want to install:"
	elog "    app-arch/p7zip"
	elog "    app-arch/unace"
	elog "    app-arch/unrar or app-arch/rar"
	elog "    app-arch/unzip"
}
