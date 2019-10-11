# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit qt5-build

DESCRIPTION="Customizable input framework and virtual keyboard for Qt"

if [[ ${QT5_BUILD_TYPE} == release ]]; then
	KEYWORDS="amd64 ~arm arm64 x86"
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
		$(usex handwriting CONFIG+=lipi-toolkit '')
		$(usex spell '' CONFIG+=disable-hunspell)
		$(usex xcb '' CONFIG+=disable-desktop)
		CONFIG+="lang-ar_AR lang-bg_BG lang-cs_CZ lang-da_DK lang-de_DE \
			lang-el_GR lang-en_GB lang-en_US lang-es_ES lang-es_MX \
			lang-et_EE lang-fa_FA lang-fi_FI lang-fr_CA lang-fr_FR \
			lang-he_IL lang-hi_IN lang-hr_HR lang-hu_HU lang-id_ID \
			lang-it_IT lang-ms_MY lang-nb_NO lang-nl_NL lang-pl_PL \
			lang-pt_BR lang-pt_PT lang-ro_RO lang-ru_RU lang-sk_SK \
			lang-sl_SI lang-sq_AL lang-sr_SP lang-sv_SE lang-tr_TR \
			lang-uk_UA lang-vi_VN"
	)

	qt5-build_src_configure
}
