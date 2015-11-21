# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
MY_PN="QupZilla"
MY_P=${MY_PN}-${PV}
PLOCALES="ar_SA bg_BG ca_ES cs_CZ de_DE el_GR es_ES es_MX es_VE eu_ES fa_IR fi_FI fr_FR gl_ES he_IL hr_HR hu_HU id_ID it_IT ja_JP ka_GE lg lv_LV nl_NL nqo pl_PL pt_BR pt_PT ro_RO ru_RU sk_SK sr sr@ijekavian sr@ijekavianlatin sr@latin sv_SE tr_TR uk_UA uz@Latn zh_CN zh_TW"
PLUGINS_HASH='1f8122da27362ae14a6e3c029830b51e9bac03be'
PLUGINS_VERSION='2015.01.27' # if there are no updates, we can use the older archive

inherit eutils l10n multilib qmake-utils vcs-snapshot

DESCRIPTION="Qt WebKit web browser"
HOMEPAGE="http://www.qupzilla.com/"
SRC_URI="https://github.com/${MY_PN}/${PN}/releases/download/v${PV}/${MY_P}.tar.xz
	https://github.com/${MY_PN}/${PN}-plugins/archive/${PLUGINS_HASH}.tar.gz -> ${PN}-plugins-${PLUGINS_VERSION}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="dbus debug gnome-keyring kde libressl nonblockdialogs +qt4 qt5"
REQUIRED_USE="^^ ( qt4 qt5 )
	kde? ( qt4 )"

RDEPEND="
	!libressl? ( dev-libs/openssl:0 )
	libressl? ( dev-libs/libressl )
	x11-libs/libX11
	gnome-keyring? ( gnome-base/gnome-keyring )
	kde? ( kde-base/kdelibs:4
		kde-apps/kwalletd:4 )
	qt4? ( >=dev-qt/qtcore-4.8:4
		>=dev-qt/qtgui-4.8:4
		>=dev-qt/qtscript-4.8:4
		>=dev-qt/qtsql-4.8:4[sqlite]
		>=dev-qt/qtwebkit-4.8:4
		dbus? ( >=dev-qt/qtdbus-4.8:4 ) )
	qt5? ( dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtconcurrent:5
		dev-qt/qtprintsupport:5
		dev-qt/qtscript:5
		dev-qt/qtsql:5[sqlite]
		dev-qt/qtwebkit:5
		dbus? ( dev-qt/qtdbus:5 ) )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	qt5? ( dev-qt/linguist-tools:5 )"

DOCS=( AUTHORS CHANGELOG FAQ README.md )
S=${WORKDIR}/${MY_P}

src_prepare() {
	rm_loc() {
		# remove localizations the user has not specified
		sed -i -e "/${1}.ts/d" translations/translations.pri || die
		rm translations/${1}.ts || die
	}

	# patch bundled but changed QTSA for Qt-5.5, see bugs 548470 and 489142
	epatch "${FILESDIR}"/qtsingleapplication-QDataStream.patch

	epatch "${FILESDIR}"/${P}-qt55.patch

	epatch_user

	# remove outdated prebuilt localizations
	rm -rf bin/locale || die

	# remove empty locale
	rm translations/empty.ts || die

	# get extra plugins into qupzilla build tree
	mv "${WORKDIR}"/${PN}-plugins-${PLUGINS_VERSION}/plugins/* "${S}"/src/plugins/ || die

	l10n_find_plocales_changes "translations" "" ".ts"
	l10n_for_each_disabled_locale_do rm_loc
}

src_configure() {
	# see BUILDING document for explanation of options
	export \
		QUPZILLA_PREFIX="${EPREFIX}/usr/" \
		USE_LIBPATH="${EPREFIX}/usr/$(get_libdir)" \
		USE_QTWEBKIT_2_2=true \
		DISABLE_DBUS=$(usex dbus '' 'true') \
		KDE_INTEGRATION=$(usex kde 'true' '') \
		NONBLOCK_JS_DIALOGS=$(usex nonblockdialogs 'true' '')

	if use qt4 ; then
		eqmake4 $(use gnome-keyring && echo "DEFINES+=GNOME_INTEGRATION")
	else
		eqmake5 $(use gnome-keyring && echo "DEFINES+=GNOME_INTEGRATION")
	fi
}

src_install() {
	emake INSTALL_ROOT="${D}" install
	einstalldocs
}

pkg_postinst() {
	if has_version www-plugins/adobe-flash; then
		ewarn "For using adobe flash plugin you may need to run"
		ewarn "    \"paxctl-ng -m /usr/bin/qupzilla\""
	fi
}
