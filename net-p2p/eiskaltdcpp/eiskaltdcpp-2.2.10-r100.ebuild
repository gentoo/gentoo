# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LUA_COMPAT=( lua5-1 )

PLOCALES="be bg cs de el en es eu fr hu it pl pt_BR ru sk sr@latin sr sv_SE uk vi zh_CN"

inherit cmake l10n lua-single xdg-utils
[[ ${PV} = *9999* ]] && inherit git-r3

DESCRIPTION="Qt/DC++ based client for DirectConnect and ADC protocols"
HOMEPAGE="https://github.com/eiskaltdcpp/eiskaltdcpp"

LICENSE="GPL-2 GPL-3"
SLOT="0"
IUSE="cli daemon dbus +dht examples idn -javascript json lua +minimal pcre +qt5 spell sqlite upnp -xmlrpc"

REQUIRED_USE="
	?? ( json xmlrpc )
	cli? ( ^^ ( json xmlrpc ) )
	dbus? ( qt5 )
	javascript? ( qt5 )
	lua? ( ${LUA_REQUIRED_USE} )
	spell? ( qt5 )
	sqlite? ( qt5 )
"

if [[ ${PV} != *9999* ]]; then
	SRC_URI="https://github.com/${PN}/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
else
	EGIT_REPO_URI="https://github.com/${PN}/${PN}.git"
	KEYWORDS=""
fi

RDEPEND="
	app-arch/bzip2
	dev-libs/boost:=
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
		json? ( dev-perl/JSON-RPC )
		xmlrpc? ( dev-perl/RPC-XML )
	)
	daemon? ( xmlrpc? ( dev-libs/xmlrpc-c[abyss,cxx] ) )
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
DEPEND="${RDEPEND}
	sys-devel/gettext
	virtual/pkgconfig
	qt5? ( dev-qt/linguist-tools:5 )
"

DOCS=( AUTHORS ChangeLog.txt )

PATCHES=(
	"${FILESDIR}"/${PN}-2.2.10-cmake_lua_version.patch
	"${FILESDIR}"/${PN}-2.2.10-ipv6_upnp.patch
	"${FILESDIR}"/${PN}-2.2.10-miniupnpc{1,2}.patch
	"${FILESDIR}"/${PN}-2.2.10-openssl-1.1.patch
	"${FILESDIR}"/${PN}-2.2.10-tray-close.patch
)

CMAKE_REMOVE_MODULES_LIST="FindLua"

src_prepare() {
	cmake_src_prepare
	l10n_find_plocales_changes 'eiskaltdcpp-qt/translations' '' '.ts'
}

src_configure() {
	local mycmakeargs=(
		-DLIB_INSTALL_DIR="$(get_libdir)"
		-Dlinguas="$(l10n_get_locales)"
		-DLOCAL_MINIUPNP=OFF
		-DUSE_GTK=OFF
		-DUSE_GTK3=OFF
		-DUSE_LIBGNOME2=OFF
		-DUSE_LIBCANBERRA=OFF
		-DUSE_LIBNOTIFY=OFF
		-DUSE_QT=OFF
		-DUSE_QT_QML=OFF
		-DNO_UI_DAEMON=$(usex daemon)
		-DDBUS_NOTIFY=$(usex dbus)
		-DWITH_DHT=$(usex dht)
		-DWITH_EXAMPLES=$(usex examples)
		-DUSE_IDNA=$(usex idn)
		-DUSE_JS=$(usex javascript)
		-DWITH_DEV_FILES=$(usex !minimal)
		-DPERL_REGEX=$(usex pcre)
		-DUSE_QT5=$(usex qt5)
		-DWITH_EMOTICONS=$(usex qt5)
		-DWITH_SOUNDS=$(usex qt5)
		-DUSE_ASPELL=$(usex spell)
		-DUSE_QT_SQLITE=$(usex sqlite)
		-DUSE_MINIUPNP=$(usex upnp)
	)
	if use cli; then
		mycmakeargs+=(
			-DUSE_CLI_JSONRPC=$(usex json)
			-DUSE_CLI_XMLRPC=$(usex xmlrpc)
		)
	fi
	if use daemon; then
		mycmakeargs+=(
			-DJSONRPC_DAEMON=$(usex json)
			-DXMLRPC_DAEMON=$(usex xmlrpc)
		)
	fi
	if use lua; then
		mycmakeargs+=(
			-DLUA_SCRIPT=ON
			-DWITH_LUASCRIPTS=ON
			-DLUA_VERSION=$(ver_cut 1-2 $(lua_get_version))
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
