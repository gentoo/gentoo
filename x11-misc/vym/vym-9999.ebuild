# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PLOCALES="cs_CZ de_DE el es fr hr_HR ia it ja pt_BR ru sv zh_CN zh_TW"
inherit desktop git-r3 plocale qmake-utils

DESCRIPTION="View Your Mind, a mindmap tool"
HOMEPAGE="https://www.insilmaril.de/vym/"
EGIT_REPO_URI="https://git.code.sf.net/p/vym/code"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="dbus"

RDEPEND="
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtprintsupport:5
	dev-qt/qtsvg:5
	dev-qt/qtxml:5
	dbus? ( dev-qt/qtdbus:5 )
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	dev-qt/qtcore:5
	dev-qt/linguist-tools:5
"
DOCS=( README.md )

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

	plocale_find_changes lang ${PN}. .ts
	plocale_for_each_disabled_locale remove_locale

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
