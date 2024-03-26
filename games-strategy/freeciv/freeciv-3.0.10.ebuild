# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( lua5-3 )

inherit desktop lua-single qmake-utils xdg

MY_PV="${PV/_beta/-beta}"
MY_PV="${MY_PV/_rc/-RC}"
MY_P="${PN}-${MY_PV}"

DESCRIPTION="Multiplayer strategy game (Civilization Clone)"
HOMEPAGE="https://www.freeciv.org/"

if [[ ${PV} != *_beta* ]] && [[ ${PV} != *_rc* ]] ; then
	SRC_URI="mirror://sourceforge/freeciv/${MY_P}.tar.xz"
	KEYWORDS="~amd64 ~ppc64 ~x86"
fi

LICENSE="GPL-2+"
SLOT="0"
IUSE="aimodules auth dedicated +gtk mapimg modpack mysql nls qt5 readline sdl +server +sound sqlite +system-lua"

REQUIRED_USE="
	system-lua? ( ${LUA_REQUIRED_USE} )
	dedicated? ( !gtk !mapimg !modpack !nls !qt5 !sdl !sound )
	!dedicated? ( || ( gtk qt5 sdl ) )
"

# postgres isn't yet really supported by upstream
RDEPEND="
	app-arch/bzip2
	app-arch/xz-utils
	dev-libs/icu:=
	net-misc/curl
	sys-libs/zlib
	auth? (
		app-arch/zstd:=
		dev-libs/openssl:=
		!mysql? ( ( !sqlite? ( dev-db/mysql-connector-c:= ) ) )
		mysql? ( dev-db/mysql-connector-c:= )
		sqlite? ( dev-db/sqlite:3 )
	)
	aimodules? ( dev-libs/libltdl )
	!dedicated? (
		media-libs/libpng
		gtk? ( x11-libs/gtk+:3 )
		mapimg? ( media-gfx/imagemagick:= )
		modpack? ( x11-libs/gtk+:3 )
		nls? ( virtual/libintl )
		qt5? (
			dev-qt/qtcore:5
			dev-qt/qtgui:5
			dev-qt/qtwidgets:5
		)
		!sdl? ( !gtk? ( x11-libs/gtk+:3 ) )
		sdl? (
			media-libs/libsdl2[video]
			media-libs/sdl2-gfx
			media-libs/sdl2-image[png]
			media-libs/sdl2-ttf
		)
		server? ( aimodules? ( dev-build/libtool ) )
		sound? (
			media-libs/libsdl2[sound]
			media-libs/sdl2-mixer[vorbis]
		)
	)
	readline? ( sys-libs/readline:= )
	system-lua? ( ${LUA_DEPS} )
"
DEPEND="${RDEPEND}
	!dedicated? ( x11-base/xorg-proto )
"
# Calls gzip during build
BDEPEND="
	app-arch/gzip
	virtual/pkgconfig
	!dedicated? ( nls? ( sys-devel/gettext ) )
"

S="${WORKDIR}/${MY_P}"

pkg_setup() {
	if ! use dedicated && ! use server ; then
		ewarn "Disabling server USE flag will make it impossible to start local"
		ewarn "games, but you will still be able to join multiplayer games."
	fi

	use system-lua && lua-single_pkg_setup
}

src_configure() {
	local myclient=() mydatabase=() myeconfargs=()

	if use auth ; then
		if ! use mysql && ! use sqlite ; then
			einfo "No database backend chosen, defaulting"
			einfo "to mysql!"
			mydatabase=( mysql )
		else
			use mysql && mydatabase+=( mysql )
			use sqlite && mydatabase+=( sqlite3 )
		fi
	else
		mydatabase=( no )
	fi

	if use dedicated ; then
		myclient=( no )
		myeconfargs+=(
			--enable-server
			--enable-freeciv-manual=html
		)
	else
		if use !sdl && use !gtk && ! use qt5 ; then
			einfo "No client backend given, defaulting to gtk3 client!"
			myclient=( gtk3 )
		else
			use sdl && myclient+=( sdl2 )
			# Since all gtk3 in gentoo is >= 3.22 we can use the better client
			use gtk && myclient+=( gtk3.22 )
			if use qt5 ; then
				local -x MOCCMD=$(qt5_get_bindir)/moc
				myclient+=( qt )
			fi
		fi
		myeconfargs+=(
			$(use_enable server)
			$(use_enable server freeciv-manual html )
		)
	fi

	myeconfargs+=(
		--enable-aimodules="$(usex aimodules "yes" "no")"
		--enable-client="${myclient[*]}"
		--enable-fcdb="${mydatabase[*]}"
		--enable-fcmp="$(usex modpack "gtk3" "no")"
		--enable-ipv6
		# disabling shared libs will break aimodules USE flag
		--enable-shared
		--localedir=/usr/share/locale
		--with-appdatadir="${EPREFIX}"/usr/share/metainfo
		$(use_enable mapimg)
		$(use_enable nls)
		$(use_enable sound sdl-mixer)
		$(use_enable system-lua sys-lua)
		$(use_with readline)
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	default

	if use server ; then
		# Create and install the html manual. It can't be done for dedicated
		# servers, because the 'freeciv-manual' tool is then not built. Also
		# delete freeciv-manual from the GAMES_BINDIR, because it's useless.
		# Note: to have it localized, it should be ran from _postinst, or
		# something like that, but then it's a PITA to avoid orphan files...
		# freeciv-manual only supports one ruleset argument at a time.
		elog "Generating html manual..."
		for RULESET in alien civ1 civ2 civ2civ3 classic experimental multiplayer sandbox
		do
			./tools/freeciv-manual -r ${RULESET} || die
			docinto html/rulesets/${RULESET}
			dodoc ${RULESET}*.html
		done
	fi

	find "${ED}" -name "freeciv-manual*" -delete || die

	if use dedicated ; then
		elog "Tidying up dedicated server installation..."
		find "${ED}"/usr/share/man/man6/ \
			-not \( -name 'freeciv.6' -o -name 'freeciv-ruledit.6' \
			-o -name 'freeciv-ruleup.6' -o -name 'freeciv-server.6' \) -mindepth 1 -delete || die
	else
		# sdl client needs some special handling
		if use sdl ; then
			make_desktop_entry freeciv-sdl "Freeciv (SDL)" freeciv-client
		else
			rm "${ED}"/usr/share/man/man6/freeciv-sdl2.6 || die
		fi

		rm -f "${ED}"/usr/share/man/man6/freeciv-xaw.6 || die
	fi

	find "${ED}" -type f -name "*.la" -delete || die
}
