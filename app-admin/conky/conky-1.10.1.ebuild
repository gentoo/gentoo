# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils cmake-utils linux-info

DESCRIPTION="An advanced, highly configurable system monitor for X"
HOMEPAGE="https://github.com/brndnmtthws/conky"
SRC_URI="https://github.com/brndnmtthws/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3 BSD LGPL-2.1 MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~x86"
IUSE="apcupsd audacious cmus curl debug eve hddtemp ical iconv imlib iostats
	ipv6 irc lua-cairo lua-imlib lua-rsvg math moc mpd mysql nano-syntax
	ncurses nvidia +portmon rss thinkpad truetype vim-syntax weather-metar
	weather-xoap webserver wifi X xmms2"

DEPEND_COMMON="
	X? (
		imlib? ( media-libs/imlib2[X] )
		lua-cairo? (
			>=dev-lua/toluapp-1.0.93
			x11-libs/cairo[X] )
		lua-imlib? (
			>=dev-lua/toluapp-1.0.93
			media-libs/imlib2[X] )
		lua-rsvg? (
			>=dev-lua/toluapp-1.0.93
			gnome-base/librsvg )
		nvidia? ( || ( x11-drivers/nvidia-drivers[tools,static-libs] media-video/nvidia-settings ) )
		truetype? ( x11-libs/libXft >=media-libs/freetype-2 )
		x11-libs/libX11
		x11-libs/libXdamage
		x11-libs/libXfixes
		x11-libs/libXext
		audacious? ( >=media-sound/audacious-1.5 dev-libs/glib:2 )
		xmms2? ( media-sound/xmms2 )
	)
	cmus? ( media-sound/cmus )
	curl? ( net-misc/curl )
	eve? ( net-misc/curl dev-libs/libxml2 )
	ical? ( dev-libs/libical )
	iconv? ( virtual/libiconv )
	irc? ( net-libs/libircclient )
	mysql? ( >=virtual/mysql-5.0 )
	ncurses? ( sys-libs/ncurses:= )
	rss? ( dev-libs/libxml2 net-misc/curl dev-libs/glib:2 )
	wifi? ( net-wireless/wireless-tools )
	weather-metar? ( net-misc/curl )
	weather-xoap? ( dev-libs/libxml2 net-misc/curl )
	webserver? ( net-libs/libmicrohttpd )
	>=dev-lang/lua-5.1.4-r8:0
	"
RDEPEND="
	${DEPEND_COMMON}
	apcupsd? ( sys-power/apcupsd )
	hddtemp? ( app-admin/hddtemp )
	moc? ( media-sound/moc )
	nano-syntax? ( app-editors/nano )
	vim-syntax? ( || ( app-editors/vim app-editors/gvim ) )
	"
DEPEND="
	${DEPEND_COMMON}
	app-text/docbook2X
	"

CONFIG_CHECK=~IPV6

DOCS=( README TODO ChangeLog NEWS AUTHORS )

pkg_setup() {
	use ipv6 && linux-info_pkg_setup
}

src_prepare() {
	epatch "${FILESDIR}/${P}-includewlan.patch"

	# Allow user patches #478482
	epatch_user
}

src_configure() {
	local mycmakeargs

	if use X; then
		mycmakeargs=(
			-DBUILD_X11=ON
			-DOWN_WINDOW=ON
			-DBUILD_XDAMAGE=ON
			-DBUILD_XDBE=ON
			$(cmake-utils_use_build truetype XFT)
			$(cmake-utils_use_build imlib IMLIB2)
			-DBUILD_XSHAPE=ON
			-DBUILD_ARGB=ON
			$(cmake-utils_use_build lua-cairo LUA_CAIRO)
			$(cmake-utils_use_build lua-imlib LUA_IMLIB2)
			$(cmake-utils_use_build lua-rsvg LUA_RSVG)
			$(cmake-utils_use_build nvidia)
			$(cmake-utils_use_build audacious)
			$(cmake-utils_use_build xmms2)
		)
	else
		mycmakeargs=(
			-DBUILD_X11=OFF
			-DBUILD_NVIDIA=OFF
			-DBUILD_LUA_CAIRO=OFF
			-DBUILD_LUA_IMLIB2=OFF
			-DBUILD_LUA_RSVG=OFF
			-DBUILD_AUDACIOUS=OFF
			-DBUILD_XMMS2=OFF
		)
	fi

	mycmakeargs+=(
		$(cmake-utils_use_build apcupsd)
		$(cmake-utils_use_build debug)
		$(cmake-utils_use_build cmus)
		$(cmake-utils_use_build curl)
		$(cmake-utils_use_build eve)
		$(cmake-utils_use_build hddtemp)
		$(cmake-utils_use_build iostats)
		$(cmake-utils_use_build ical)
		$(cmake-utils_use_build iconv)
		$(cmake-utils_use_build ipv6)
		$(cmake-utils_use_build irc)
		$(cmake-utils_use_build math)
		$(cmake-utils_use_build moc)
		$(cmake-utils_use_build mpd)
		$(cmake-utils_use_build mysql)
		$(cmake-utils_use_build ncurses)
		$(cmake-utils_use_build portmon PORT_MONITORS)
		$(cmake-utils_use_build rss)
		$(cmake-utils_use_build thinkpad IBM)
		$(cmake-utils_use_build weather-metar WEATHER_METAR)
		$(cmake-utils_use_build weather-xoap WEATHER_XOAP)
		$(cmake-utils_use_build webserver HTTP)
		$(cmake-utils_use_build wifi WLAN)
		-DBUILD_BUILTIN_CONFIG=ON
		-DBUILD_OLD_CONFIG=ON
		-DBUILD_I18N=ON
		-DMAINTAINER_MODE=OFF
		-DRELEASE=ON
		-DBUILD_AUDACIOUS_LEGACY=OFF
		-DBUILD_BMPX=OFF
		-DDOC_PATH=/usr/share/doc/${PF}
	)

	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install

	if use vim-syntax; then
		insinto /usr/share/vim/vimfiles/ftdetect
		doins "${S}"/extras/vim/ftdetect/conkyrc.vim

		insinto /usr/share/vim/vimfiles/syntax
		doins "${S}"/extras/vim/syntax/conkyrc.vim
	fi

	if use nano-syntax; then
		insinto /usr/share/nano/
		doins "${S}"/extras/nano/conky.nanorc
	fi
}

pkg_postinst() {
	if [[ -z "${REPLACING_VERSIONS}" ]]; then
		elog "You can find sample configurations at ${ROOT%/}/usr/share/doc/${PF}."
		elog "To customize, copy to ${XDG_CONFIG_HOME}/conky/conky.conf"
		elog "and edit it to your liking."
		elog
		elog "There are pretty html docs available at the conky homepage"
		elog "or in ${ROOT%/}/usr/share/doc/${PF}/html."
		elog
		elog "Also see https://wiki.gentoo.org/wiki/Conky/HOWTO"
		elog
	fi
}
