# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PLOCALES="ar_SA bg_BG ca_ES cs_CZ da_DK de_DE el_GR es_419 es_ES es_MX es_VE
	eu_ES fa_IR fi_FI fr_FR gl_ES he_IL hr_HR hu_HU id_ID is it_IT ja_JP
	ka_GE lg lt lv_LV nb_NO nl_NL nqo pl_PL pt_BR pt_PT ro_RO ru_RU sk_SK
	sl_SI sr sr@ijekavian sr@ijekavianlatin sr@latin sv_SE tr_TR uk_UA
	uz@Latn zh_CN zh_HK zh_TW"

PLUGINS_HASH="80fea7df7765fdf9c9c64fdb667052b25f1c0a22"
PLUGINS_VERSION="2017.03.26" # if there are no updates, we can use the older archive

inherit gnome2-utils l10n qmake-utils xdg-utils

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/QupZilla/${PN}.git"
else
	MY_P=QupZilla-${PV}
	SRC_URI="https://github.com/QupZilla/${PN}/releases/download/v${PV}/${MY_P}.tar.xz"
	KEYWORDS="~amd64 ~arm ~x86"
	S=${WORKDIR}/${MY_P}
fi

DESCRIPTION="A cross-platform web browser using QtWebEngine"
HOMEPAGE="https://www.qupzilla.com/"
SRC_URI+=" https://github.com/QupZilla/${PN}-plugins/archive/${PLUGINS_HASH}.tar.gz -> ${PN}-plugins-${PLUGINS_VERSION}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
IUSE="dbus debug gnome-keyring kwallet libressl nonblockdialogs"

COMMON_DEPEND="
	>=dev-qt/qtcore-5.8:5
	>=dev-qt/qtdeclarative-5.8:5[widgets]
	>=dev-qt/qtgui-5.8:5
	>=dev-qt/qtnetwork-5.8:5[ssl]
	>=dev-qt/qtprintsupport-5.8:5
	>=dev-qt/qtsql-5.8:5[sqlite]
	>=dev-qt/qtwebchannel-5.8:5
	>=dev-qt/qtwebengine-5.8:5[widgets]
	>=dev-qt/qtwidgets-5.8:5
	>=dev-qt/qtx11extras-5.8:5
	x11-libs/libxcb:=
	dbus? ( >=dev-qt/qtdbus-5.8:5 )
	gnome-keyring? ( gnome-base/gnome-keyring )
	kwallet? ( kde-frameworks/kwallet:5 )
	libressl? ( dev-libs/libressl:= )
	!libressl? ( dev-libs/openssl:0= )
"
DEPEND="${COMMON_DEPEND}
	>=dev-qt/linguist-tools-5.8:5
	>=dev-qt/qtconcurrent-5.8:5
	virtual/pkgconfig
"
RDEPEND="${COMMON_DEPEND}
	>=dev-qt/qtsvg-5.8:5
"

DOCS=( AUTHORS BUILDING.md CHANGELOG FAQ README.md )

src_unpack() {
	if [[ ${PV} == *9999 ]]; then
		git-r3_src_unpack
	fi
	default
}

src_prepare() {
	# get extra plugins into qupzilla build tree
	mv "${WORKDIR}"/${PN}-plugins-${PLUGINS_HASH}/plugins/* src/plugins/ || die

	rm_loc() {
		# remove localizations the user has not specified
		sed -i -e "/${1}.ts/d" translations/translations.pri || die
		rm translations/${1}.ts || die
	}

	# remove outdated prebuilt localizations
	rm -rf bin/locale || die

	# remove empty locale
	rm translations/empty.ts || die

	l10n_find_plocales_changes translations '' .ts
	l10n_for_each_disabled_locale_do rm_loc

	default
}

src_configure() {
	# see BUILDING document for explanation of options
	export \
		QUPZILLA_PREFIX="${EPREFIX}/usr" \
		USE_LIBPATH="${EPREFIX}/usr/$(get_libdir)" \
		DEBUG_BUILD=$(usex debug true '') \
		DISABLE_DBUS=$(usex dbus '' true) \
		GNOME_INTEGRATION=$(usex gnome-keyring true '') \
		KDE_INTEGRATION=$(usex kwallet true '') \
		NONBLOCK_JS_DIALOGS=$(usex nonblockdialogs true '')

	eqmake5
}

src_install() {
	emake INSTALL_ROOT="${D}" install
	einstalldocs
}

pkg_postinst() {
	xdg_desktop_database_update
	gnome2_icon_cache_update
}

pkg_postrm() {
	xdg_desktop_database_update
	gnome2_icon_cache_update
}
