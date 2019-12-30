# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PLOCALES="cs_CZ de_DE el es fr hr_HR ia it ja pt_BR ru sv zh_CN zh_TW"
inherit desktop l10n qmake-utils

DESCRIPTION="View Your Mind, a mindmap tool"
HOMEPAGE="https://www.insilmaril.de/vym/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="dbus"

RDEPEND="
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtprintsupport:5
	dev-qt/qtscript:5
	dev-qt/qtsvg:5
	dev-qt/qtxml:5
	dbus? ( dev-qt/qtdbus:5 )
"
DEPEND="
	${RDEPEND}
	dev-qt/linguist-tools:5
"
DOCS=( README.md doc/vym.pdf )

src_prepare() {
	default

	if has es ${LINGUAS-es} ; then
		DOCS+=( doc/vym_es.pdf )
	fi
	if has fr ${LINGUAS-fr} ; then
		DOCS+=( doc/vym_fr.pdf )
	fi

	remove_locale() {
		sed -i \
			-e "/TRANSLATIONS += lang\/vym.${1}.ts/d" \
			vym.pro || die
	}

	gunzip doc/vym.1.gz || die

	#remove dead en translation
	rm lang/vym.en.ts || die
	remove_locale en

	l10n_find_plocales_changes lang ${PN}. .ts
	l10n_for_each_disabled_locale_do remove_locale

	"$(qt5_get_bindir)"/lrelease vym.pro || die
}

src_configure() {
	eqmake5 vym.pro \
		PREFIX="${EPREFIX}"/usr \
		DATADIR="${EPREFIX}"/usr/share \
		$(usex dbus "" NO_DBUS=1 )
}

src_install() {
	emake INSTALL_ROOT="${D}" install

	einstalldocs

	doman doc/vym.1

	make_desktop_entry vym vym /usr/share/vym/icons/vym.png Education
}
