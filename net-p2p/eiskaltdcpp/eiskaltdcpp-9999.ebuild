# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LUA_COMPAT=( lua5-1 lua5-2 )

PLOCALES="be bg cs da de el en es eu fr hu ie it pl pt_BR ru sk sr sr@latin sv_SE tr uk vi zh_CN"

inherit cmake l10n lua-single xdg-utils toolchain-funcs
[[ ${PV} = *9999* ]] && inherit git-r3

DESCRIPTION="Qt/DC++ based client for DirectConnect and ADC protocols"
HOMEPAGE="https://github.com/eiskaltdcpp/eiskaltdcpp"

LICENSE="GPL-2 GPL-3"
SLOT="0"
IUSE="cli daemon dbus +dht examples gold gtk idn javascript libcanberra libnotify lua +minimal pcre +qt5 spell sqlite upnp"

REQUIRED_USE="
	dbus? ( qt5 )
	javascript? ( qt5 )
	libcanberra? ( gtk )
	libnotify? ( gtk )
	lua? ( ${LUA_REQUIRED_USE} )
	spell? ( qt5 )
	sqlite? ( qt5 )
"

if [[ ${PV} != *9999* ]]; then
	SRC_URI="mirror://sourceforge/project/${PN}/Sources/${P}.tar.xz"
	KEYWORDS="~amd64 ~x86"
else
	EGIT_REPO_URI="https://github.com/${PN}/${PN}.git"
	KEYWORDS=""
fi

RDEPEND="
	app-arch/bzip2
	dev-libs/openssl:0=
	sys-apps/attr
	sys-libs/zlib
	virtual/libiconv
	virtual/libintl
	cli? (
		dev-lang/perl
		dev-perl/Data-Dump
		dev-perl/Term-ShellUI
		virtual/perl-Getopt-Long
		dev-perl/JSON-RPC
	)
	daemon? (
		dev-libs/jsoncpp:=
	)
	gtk? (
		dev-libs/glib:2
		x11-libs/gtk+:3
		x11-libs/pango
		x11-themes/hicolor-icon-theme
		libcanberra? ( media-libs/libcanberra )
		libnotify? ( x11-libs/libnotify )
	)
	idn? ( net-dns/libidn )
	lua? ( ${LUA_DEPS} )
	pcre? ( dev-libs/libpcre )
	qt5? (
		dev-qt/qtconcurrent:5
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtmultimedia:5
		dev-qt/qtnetwork:5
		dev-qt/qtwidgets:5
		dev-qt/qtxml:5
		dbus? ( dev-qt/qtdbus:5 )
		javascript? (
			dev-qt/qtdeclarative:5
			dev-qt/qtscript:5
		)
		spell? ( app-text/aspell )
		sqlite? ( dev-qt/qtsql:5[sqlite] )
	)
	upnp? ( net-libs/miniupnpc )
"
BDEPEND="
	gold? ( sys-devel/binutils[gold] )
"
DEPEND="${RDEPEND}
	sys-devel/gettext
	virtual/pkgconfig
	qt5? ( dev-qt/linguist-tools:5 )
"

DOCS=( AUTHORS ChangeLog.txt )

CMAKE_REMOVE_MODULES_LIST="FindASPELL FindLua"

pkg_setup() {
	use lua && lua-single_pkg_setup
}

src_prepare() {
	cmake_src_prepare
	l10n_find_plocales_changes 'eiskaltdcpp-qt/translations' '' '.ts'
}

src_configure() {
	local mycmakeargs=(
		-DLIB_INSTALL_DIR="$(get_libdir)"
		-Dlinguas="$(l10n_get_locales)"
		-DCREATE_MO=ON
		-DUSE_GTK=OFF
		-DUSE_LIBGNOME2=OFF
		-DUSE_QT=OFF
		-DUSE_QT_QML=OFF
		-DNO_UI_DAEMON=$(usex daemon)
		-DDBUS_NOTIFY=$(usex dbus)
		-DWITH_DHT=$(usex dht)
		-DWITH_EXAMPLES=$(usex examples)
		-DUSE_GTK3=$(usex gtk)
		-DUSE_IDNA=$(usex idn)
		-DUSE_JS=$(usex javascript)
		-DUSE_LIBCANBERRA=$(usex libcanberra)
		-DUSE_LIBNOTIFY=$(usex libnotify)
		-DWITH_DEV_FILES=$(usex !minimal)
		-DPERL_REGEX=$(usex pcre)
		-DUSE_QT5=$(usex qt5)
		-DUSE_ASPELL=$(usex spell)
		-DLOCAL_ASPELL_DATA=OFF
		-DUSE_QT_SQLITE=$(usex sqlite)
		-DUSE_MINIUPNP=$(usex upnp)
		-DFORCE_XDG=ON
		-DENABLE_STACKTRACE=OFF
		-DUSE_GOLD=$(usex gold)
		-DLOCAL_JSONCPP=OFF
		-DBUILD_STATIC=OFF
		-DINSTALL_QT_TRANSLATIONS=OFF
		-DCOMPRESS_MANPAGES=OFF
		-DUSE_CLI_JSONRPC=$(usex cli)
		-DJSONRPC_DAEMON=$(usex daemon)
	)
	if use lua; then
		mycmakeargs+=(
			-DLUA_SCRIPT=ON
			-DWITH_LUASCRIPTS=$(usex examples)
			-DLUA_VERSION=$(ver_cut 1-2 $(lua_get_version))
		)
	else
		mycmakeargs+=(
			-DLUA_SCRIPT=OFF
			-DWITH_LUASCRIPTS=OFF
		)
	fi
	if use qt5 || use gtk; then
		mycmakeargs+=(
			-DWITH_EMOTICONS=ON
			-DWITH_SOUNDS=ON
		)
	else
		mycmakeargs+=(
			-DWITH_EMOTICONS=OFF
			-DWITH_SOUNDS=OFF
		)
	fi
	cmake_src_configure
}

pkg_postinst() {
	xdg_desktop_database_update
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_icon_cache_update
}
