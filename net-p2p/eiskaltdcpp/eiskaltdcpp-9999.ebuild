# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-p2p/eiskaltdcpp/eiskaltdcpp-9999.ebuild,v 1.41 2014/12/07 20:19:57 maksbotan Exp $

EAPI="5"

PLOCALES="be bg cs de el en es fr hu it pl pt_BR ru sk sr@latin sv_SE uk vi zh_CN"

inherit cmake-utils eutils l10n fdo-mime gnome2-utils
[[ ${PV} = *9999* ]] && inherit git-r3

DESCRIPTION="Qt based client for DirectConnect and ADC protocols, based on DC++ library"
HOMEPAGE="https://code.google.com/p/eiskaltdc/"

LICENSE="GPL-2 GPL-3"
SLOT="0"
IUSE="cli daemon dbus +dht +emoticons examples -gtk idn -javascript json libcanberra libnotify lua +minimal pcre +qt4 sound spell sqlite upnp -xmlrpc"

REQUIRED_USE="
	cli? ( ^^ ( json xmlrpc ) )
	emoticons? ( || ( gtk qt4 ) )
	dbus? ( qt4 )
	javascript? ( qt4 )
	json? ( !xmlrpc )
	libcanberra? ( gtk )
	libnotify? ( gtk )
	spell? ( qt4 )
	sound? ( || ( gtk qt4 ) )
	sqlite? ( qt4 )
"

if [[ ${PV} != *9999* ]]; then
	SRC_URI="https://eiskaltdc.googlecode.com/files/${P}.tar.xz"
	KEYWORDS="~amd64 ~x86"
else
	EGIT_REPO_URI="https://github.com/${PN}/${PN}.git"
	KEYWORDS=""
fi

RDEPEND="
	app-arch/bzip2
	>=dev-libs/boost-1.38:=
	>=dev-libs/openssl-0.9.8
	sys-apps/attr
	sys-libs/zlib
	virtual/libiconv
	virtual/libintl
	idn? ( net-dns/libidn )
	lua? ( >=dev-lang/lua-5.1 )
	pcre? ( >=dev-libs/libpcre-4.2 )
	upnp? ( >=net-libs/miniupnpc-1.6 )
	cli? (
		>=dev-lang/perl-5.10
		virtual/perl-Getopt-Long
		dev-perl/Data-Dump
		dev-perl/Term-ShellUI
		json? ( dev-perl/JSON-RPC )
		xmlrpc? ( dev-perl/RPC-XML )
	)
	daemon? ( xmlrpc? ( >=dev-libs/xmlrpc-c-1.19.0[abyss,cxx] ) )
	gtk? (
		x11-libs/pango
		x11-libs/gtk+:3
		>=dev-libs/glib-2.24:2
		x11-themes/hicolor-icon-theme
		libcanberra? ( media-libs/libcanberra )
		libnotify? ( >=x11-libs/libnotify-0.4.1 )
	)
	qt4? (
		>=dev-qt/qtcore-4.6.0:4
		>=dev-qt/qtgui-4.6.0:4
		dbus? ( >=dev-qt/qtdbus-4.6.0:4 )
		javascript? (
			dev-qt/qtscript:4
			x11-libs/qtscriptgenerator
		)
		spell? ( app-text/aspell )
		sqlite? ( dev-qt/qtsql:4[sqlite] )
	)
"
DEPEND="${RDEPEND}
	sys-devel/gettext
	virtual/pkgconfig
"
DOCS=( AUTHORS ChangeLog.txt )

pkg_pretend() {
	if [[ ${MERGE_TYPE} != binary ]]; then
		[[ $(gcc-major-version) -lt 4 ]] || \
				( [[ $(gcc-major-version) -eq 4 && $(gcc-minor-version) -le 4 ]] ) \
			&& die "Sorry, but gcc-4.4 and earlier won't work."
	fi
}

src_prepare() {
	l10n_find_plocales_changes 'eiskaltdcpp-qt/translations' '' '.ts'

	epatch_user
}

src_configure() {
	local mycmakeargs=(
		-DLIB_INSTALL_DIR="$(get_libdir)"
		-Dlinguas="$(l10n_get_locales)"
		-DLOCAL_MINIUPNP=OFF
		-DUSE_GTK=OFF
		-DUSE_LIBGNOME2=OFF
		"$(use cli && cmake-utils_use json USE_CLI_JSONRPC)"
		"$(use cli && cmake-utils_use xmlrpc USE_CLI_XMLRPC)"
		"$(cmake-utils_use daemon NO_UI_DAEMON)"
		"$(use daemon && cmake-utils_use json JSONRPC_DAEMON)"
		"$(use daemon && cmake-utils_use xmlrpc XMLRPC_DAEMON)"
		"$(cmake-utils_use dbus DBUS_NOTIFY)"
		"$(cmake-utils_use dht WITH_DHT)"
		"$(cmake-utils_use emoticons WITH_EMOTICONS)"
		"$(cmake-utils_use examples WITH_EXAMPLES)"
		"$(cmake-utils_use gtk USE_GTK3)"
		"$(cmake-utils_use idn USE_IDNA)"
		"$(cmake-utils_use javascript USE_JS)"
		"$(cmake-utils_use libcanberra LIBCANBERRA)"
		"$(cmake-utils_use libnotify USE_LIBNOTIFY)"
		"$(cmake-utils_use lua LUA_SCRIPT)"
		"$(cmake-utils_use lua WITH_LUASCRIPTS)"
		"$(cmake-utils_use !minimal WITH_DEV_FILES)"
		"$(cmake-utils_use pcre PERL_REGEX)"
		"$(cmake-utils_use qt4 USE_QT)"
		"$(cmake-utils_use sound WITH_SOUNDS)"
		"$(cmake-utils_use spell USE_ASPELL)"
		"$(cmake-utils_use sqlite USE_QT_SQLITE)"
		"$(cmake-utils_use upnp USE_MINIUPNP)"
	)
	cmake-utils_src_configure
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	fdo-mime_desktop_database_update
	gnome2_icon_cache_update
}

pkg_postrm() {
	fdo-mime_desktop_database_update
	gnome2_icon_cache_update
}
