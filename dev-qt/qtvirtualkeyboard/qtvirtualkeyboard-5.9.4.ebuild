# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit qt5-build

DESCRIPTION="Virtual keyboard plugin for the Qt5 framework"

if [[ ${QT5_BUILD_TYPE} == release ]]; then
	KEYWORDS="~amd64 ~arm ~x86"
fi

# TODO: unbudle libraries for more layouts
IUSE="handwriting +spell +xcb"

DEPEND="
	~dev-qt/qtcore-${PV}
	~dev-qt/qtdeclarative-${PV}
	~dev-qt/qtgui-${PV}
	~dev-qt/qtsvg-${PV}
	spell? ( app-text/hunspell:= )
	xcb? ( x11-libs/libxcb:= )
"
RDEPEND="${DEPEND}"

src_configure() {
	local myqmakeargs=(
		$(usex handwriting CONFIG+=lipi-toolkit "")
		$(usex spell "" CONFIG+=disable-hunspell)
		$(usex xcb "" CONFIG+=disable-desktop)
		CONFIG+="lang-ar_AR lang-da_DK lang-de_DE lang-en_GB \
                        lang-es_ES lang-fa_FA lang-fi_FI lang-fr_FR \
                        lang-hi_IN lang-it_IT lang-nb_NO lang-pl_PL \
                        lang-pt_PT lang-ro_RO lang-ru_RU lang-sv_SE"
	)

	qt5-build_src_configure
}
