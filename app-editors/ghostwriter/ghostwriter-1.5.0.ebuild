# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PLOCALES="cs de en es fr it ja pt_BR ru"

inherit l10n qmake-utils

DESCRIPTION="Cross-platform, aesthetic, distraction-free markdown editor"
HOMEPAGE="http://wereturtle.github.io/ghostwriter/"
SRC_URI="https://github.com/wereturtle/ghostwriter/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

RDEPEND="
	app-text/hunspell
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtprintsupport:5
	dev-qt/qtwebkit:5
	dev-qt/qtwidgets:5
"
DEPEND="${RDEPEND}
	dev-qt/qtconcurrent:5
"

DOCS=( CREDITS.md README.md )

src_prepare() {
	default

	local mylrelease="$(qt5_get_bindir)"/lrelease

	sed -i -e "/^VERSION =/s/\$.*/${PV}/" ghostwriter.pro || die "failed to override version"

	prepare_locale() {
		"${mylrelease}" "translations/${PN}_${1}.ts" || die "failed to prepare ${1} locale"
	}

	l10n_find_plocales_changes translations ${PN}_ .ts
	l10n_for_each_locale_do prepare_locale
}

src_configure() {
	eqmake5 \
		CONFIG+=$(usex debug debug release) \
		PREFIX="${EPREFIX}"/usr
}

src_install() {
	emake INSTALL_ROOT="${D}" install
	einstalldocs
}
