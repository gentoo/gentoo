# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( lua5-4 )
PYTHON_COMPAT=( python{3_9,3_10,3_11} )

inherit cmake linux-info lua-single python-any-r1 readme.gentoo-r1 xdg

DESCRIPTION="An advanced, highly configurable system monitor for X"
HOMEPAGE="https://github.com/brndnmtthws/conky"
SRC_URI="https://github.com/brndnmtthws/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3 BSD LGPL-2.1 MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~ppc ~ppc64 ~riscv ~sparc ~x86"
IUSE="apcupsd bundled-toluapp cmus curl doc extras hddtemp ical iconv imlib
	intel-backlight iostats irc lua-cairo lua-imlib lua-rsvg math moc mpd
	mysql ncurses nvidia +portmon pulseaudio rss systemd thinkpad truetype
	wayland webserver wifi X xinerama xmms2"

COMMON_DEPEND="
	curl? ( net-misc/curl )
	ical? ( dev-libs/libical:= )
	iconv? ( virtual/libiconv )
	imlib? ( media-libs/imlib2[X] )
	irc? ( net-libs/libircclient )
	lua-cairo? ( x11-libs/cairo[X] )
	lua-imlib? ( media-libs/imlib2[X] )
	lua-rsvg? ( gnome-base/librsvg )
	mysql? ( dev-db/mysql-connector-c )
	ncurses? ( sys-libs/ncurses:= )
	nvidia? ( x11-drivers/nvidia-drivers[tools,static-libs] )
	pulseaudio? ( media-libs/libpulse )
	rss? ( dev-libs/libxml2 net-misc/curl dev-libs/glib:2 )
	systemd? ( sys-apps/systemd )
	truetype? ( x11-libs/libXft >=media-libs/freetype-2 )
	wayland? (
		dev-libs/wayland
		x11-libs/pango
	)
	wifi? ( net-wireless/wireless-tools )
	webserver? ( net-libs/libmicrohttpd:= )
	X? (
		x11-libs/libX11
		x11-libs/libXdamage
		x11-libs/libXfixes
		x11-libs/libXext
	)
	xinerama? ( x11-libs/libXinerama )
	xmms2? ( media-sound/xmms2 )
	${LUA_DEPS}
"
RDEPEND="
	${COMMON_DEPEND}
	apcupsd? ( sys-power/apcupsd )
	cmus? ( media-sound/cmus )
	hddtemp? ( app-admin/hddtemp )
	moc? ( media-sound/moc )
	extras? (
		app-editors/nano
		|| ( app-editors/vim app-editors/gvim )
		)
"
DEPEND="
	${COMMON_DEPEND}
	wayland? (
		dev-libs/wayland-protocols
	)
"
BDEPEND="
	doc? (
		virtual/pandoc
		$(python_gen_any_dep '
			dev-python/pyyaml[${PYTHON_USEDEP}]
			dev-python/jinja[${PYTHON_USEDEP}]
		')
	)
	extras? (
		$(python_gen_any_dep '
			dev-python/pyyaml[${PYTHON_USEDEP}]
			dev-python/jinja[${PYTHON_USEDEP}]
		')
	)
	wayland? ( dev-util/wayland-scanner )
"

python_check_deps() {
	use doc || use extras || return 0
	python_has_version -b "dev-python/pyyaml[${PYTHON_USEDEP}]" &&
	python_has_version -b "dev-python/jinja[${PYTHON_USEDEP}]"
}

REQUIRED_USE="
	imlib? ( X )
	lua-cairo? ( X  bundled-toluapp )
	lua-imlib? ( X  bundled-toluapp )
	lua-rsvg? ( X  bundled-toluapp )
	nvidia? ( X )
	truetype? ( X )
	xinerama? ( X )
"

CONFIG_CHECK="~IPV6"

DOCS=( README.md AUTHORS )

DISABLE_AUTOFORMATTING="yes"
DOC_CONTENTS="You can find sample configurations at ${ROOT}/usr/share/doc/${PF}.
To customize, copy to \${XDG_CONFIG_HOME}/conky/conky.conf and edit it to your liking.

There are pretty html docs available at https://conky.cc/.

Also see https://github.com/brndnmtthws/conky/wiki or https://wiki.gentoo.org/wiki/Conky"

pkg_setup() {
	linux-info_pkg_setup
	lua-single_pkg_setup
	if use doc || use extras; then
		python-any-r1_pkg_setup
	fi
}

src_prepare() {
	# pin lua 5.4
	sed -i -e 's|Lua "5.3" REQUIRED|Lua "5.4" EXACT|g' \
		cmake/ConkyPlatformChecks.cmake || die "ConkyPlatformChecks.cmake"

	cmake_src_prepare
	xdg_environment_reset
}

src_configure() {
	local mycmakeargs=()

	if use X; then
		mycmakeargs+=(
			-DBUILD_ARGB=yes
			-DBUILD_X11=yes
			-DBUILD_XDAMAGE=yes
			-DBUILD_XDBE=yes
			-DBUILD_XSHAPE=yes
			-DBUILD_MOUSE_EVENTS=yes
			-DOWN_WINDOW=yes
		)
	else
		mycmakeargs+=(
			-DBUILD_X11=no
		)
	fi

	mycmakeargs+=(
		-DBUILD_APCUPSD=$(usex apcupsd)
		-DBUILD_AUDACIOUS=no
		-DBUILD_BUILTIN_CONFIG=yes
		-DBUILD_CMUS=$(usex cmus)
		-DBUILD_CURL=$(usex curl)
		-DBUILD_DOCS=$(usex doc)
		-DBUILD_EXTRAS=$(usex extras)
		-DBUILD_HDDTEMP=$(usex hddtemp)
		-DBUILD_HTTP=$(usex webserver)
		-DBUILD_I18N=yes
		-DBUILD_IBM=$(usex thinkpad)
		-DBUILD_ICAL=$(usex ical)
		-DBUILD_ICONV=$(usex iconv)
		-DBUILD_IMLIB2=$(usex imlib)
		-DBUILD_INTEL_BACKLIGHT=$(usex intel-backlight)
		-DBUILD_IOSTATS=$(usex iostats)
		-DBUILD_IPV6=yes
		-DBUILD_IRC=$(usex irc)
		-DBUILD_JOURNAL=$(usex systemd)
		-DBUILD_LUA_CAIRO=$(usex lua-cairo)
		-DBUILD_LUA_IMLIB2=$(usex lua-imlib)
		-DBUILD_LUA_RSVG=$(usex lua-rsvg)
		-DBUILD_MATH=$(usex math)
		-DBUILD_MOC=$(usex moc)
		-DBUILD_MPD=$(usex mpd)
		-DBUILD_MYSQL=$(usex mysql)
		-DBUILD_NCURSES=$(usex ncurses)
		-DBUILD_NVIDIA=$(usex nvidia)
		-DBUILD_OLD_CONFIG=yes
		-DBUILD_PORT_MONITORS=$(usex portmon)
		-DBUILD_PULSEAUDIO=$(usex pulseaudio)
		-DBUILD_RSS=$(usex rss)
		-DBUILD_WAYLAND=$(usex wayland)
		-DBUILD_WLAN=$(usex wifi)
		-DBUILD_XFT=$(usex truetype)
		-DBUILD_XINERAMA=$(usex xinerama)
		-DBUILD_XMMS2=$(usex xmms2)
		-DDOC_PATH=/usr/share/doc/${PF}
		-DMAINTAINER_MODE=no
		-DRELEASE=yes
	)

	if use doc || use extras; then
		mycmakeargs+=( -DPython3_EXECUTABLE="${PYTHON}" )
	fi

	cmake_src_configure
}

src_install() {
	cmake_src_install

	if use extras; then
		insinto /usr/share/vim/vimfiles/ftdetect
		doins "${S}"/extras/vim/ftdetect/conkyrc.vim

		insinto /usr/share/vim/vimfiles/syntax
		doins "${BUILD_DIR}"/extras/vim/syntax/conkyrc.vim

		insinto /usr/share/nano/
		doins "${BUILD_DIR}"/extras/nano/conky.nanorc
	fi

	readme.gentoo_create_doc
}

pkg_postinst() {
	readme.gentoo_print_elog

	xdg_pkg_postinst
}
