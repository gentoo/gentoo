# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PLOCALES="ar_SA bg_BG ca_ES cs_CZ de_DE el_GR es_ES es_MX es_VE eu_ES fa_IR
	fi_FI fr_FR gl_ES he_IL hr_HR hu_HU id_ID it_IT ja_JP ka_GE lg lv_LV
	nl_NL nqo pl_PL pt_BR pt_PT ro_RO ru_RU sk_SK sr sr@ijekavian
	sr@ijekavianlatin sr@latin sv_SE tr_TR uk_UA uz@Latn zh_CN zh_TW"
PLUGINS_HASH='7b037cc326921cefbfc6b5e54e2091eb4191e73f'
PLUGINS_VERSION='2015.10.02' # if there are no updates, we can use the older archive

inherit l10n qmake-utils

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/QupZilla/${PN}.git"
else
	MY_P=QupZilla-${PV}
	SRC_URI="https://github.com/QupZilla/${PN}/releases/download/v${PV}/${MY_P}.tar.xz"
	KEYWORDS="~amd64 ~x86"
	S=${WORKDIR}/${MY_P}
fi

DESCRIPTION="A cross-platform web browser using QtWebEngine"
HOMEPAGE="http://www.qupzilla.com/"
SRC_URI+=" https://github.com/QupZilla/${PN}-plugins/archive/${PLUGINS_HASH}.tar.gz -> ${PN}-plugins-${PLUGINS_VERSION}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
IUSE="dbus debug gnome-keyring kde libressl nonblockdialogs"

RDEPEND="
	>=dev-qt/qtconcurrent-5.6:5
	>=dev-qt/qtcore-5.6:5
	>=dev-qt/qtdeclarative-5.6:5[widgets]
	>=dev-qt/qtgui-5.6:5
	>=dev-qt/qtnetwork-5.6:5[ssl]
	>=dev-qt/qtprintsupport-5.6:5
	>=dev-qt/qtsql-5.6:5[sqlite]
	>=dev-qt/qtwebchannel-5.6:5
	>=dev-qt/qtwebengine-5.6:5[widgets]
	>=dev-qt/qtwidgets-5.6:5
	>=dev-qt/qtx11extras-5.6:5
	x11-libs/libxcb:=
	dbus? ( >=dev-qt/qtdbus-5.6:5 )
	gnome-keyring? ( gnome-base/gnome-keyring )
	kde? ( kde-frameworks/kwallet:5 )
	libressl? ( dev-libs/libressl:= )
	!libressl? ( dev-libs/openssl:0 )
"
DEPEND="${RDEPEND}
	>=dev-qt/linguist-tools-5.6:5
	virtual/pkgconfig
"

DOCS=( AUTHORS BUILDING CHANGELOG FAQ README.md )

src_unpack() {
	if [[ ${PV} == *9999 ]]; then
		git-r3_src_unpack
	fi
	default
}

src_prepare() {
	# get extra plugins into qupzilla build tree
	mv "${WORKDIR}"/${PN}-plugins-${PLUGINS_HASH}/plugins/* "${S}"/src/plugins/ || die

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
		KDE_INTEGRATION=$(usex kde true '') \
		NONBLOCK_JS_DIALOGS=$(usex nonblockdialogs true '')

	eqmake5
}

src_install() {
	emake INSTALL_ROOT="${D}" install
	einstalldocs
}
