# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PV="${PV/_beta/-beta}"
MY_PV="${MY_PV/_rc/-RC}"
MY_P="${PN}-${MY_PV}"
inherit desktop flag-o-matic xdg

DESCRIPTION="multiplayer strategy game (Civilization Clone)"
HOMEPAGE="http://www.freeciv.org/"

if [[ ${PV} != *_beta* ]] && [[ ${PV} != *_rc* ]] ; then
	SRC_URI="mirror://sourceforge/freeciv/${MY_P}.tar.bz2"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-2+"
SLOT="0"
IUSE="aimodules auth dedicated +gtk ipv6 mapimg modpack mysql nls qt5 readline sdl +server +sound sqlite system-lua"

# postgres isn't yet really supported by upstream
BDEPEND="
	virtual/pkgconfig
	!dedicated? (
		x11-base/xorg-proto
		nls? ( sys-devel/gettext )
	)
"
DEPEND="
	app-arch/bzip2
	app-arch/xz-utils
	net-misc/curl
	sys-libs/zlib
	auth? (
		!mysql? ( ( !sqlite? ( dev-db/mysql-connector-c:0= ) ) )
		mysql? ( dev-db/mysql-connector-c:0= )
		sqlite? ( dev-db/sqlite:3 )
	)
	dedicated? ( aimodules? ( dev-libs/libltdl:0 ) )
	!dedicated? (
		media-libs/libpng:0
		gtk? ( x11-libs/gtk+:2 )
		mapimg? ( media-gfx/imagemagick:= )
		modpack? ( x11-libs/gtk+:2 )
		nls? ( virtual/libintl )
		qt5? (
			dev-qt/qtcore:5
			dev-qt/qtgui:5
			dev-qt/qtwidgets:5
		)
		!sdl? ( !gtk? ( x11-libs/gtk+:2 ) )
		sdl? (
			media-libs/libsdl2[video]
			media-libs/sdl2-gfx
			media-libs/sdl2-image[png]
			media-libs/sdl2-ttf
		)
		server? ( aimodules? ( sys-devel/libtool:2 ) )
		sound? (
			media-libs/libsdl2[sound]
			media-libs/sdl2-mixer[vorbis]
		)
	)
	readline? ( sys-libs/readline:0= )
	system-lua? ( >=dev-lang/lua-5.3:= )
"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

pkg_setup() {
	if use !dedicated && use !server ; then
		ewarn "Disabling server USE flag will make it impossible"
		ewarn "to start local games, but you will still be able to"
		ewarn "join multiplayer games."
	fi
}

src_prepare() {
	default

	# install the .desktop in /usr/share/applications
	# install the icons in /usr/share/pixmaps
	sed -i \
		-e 's:^.*\(desktopfiledir = \).*:\1/usr/share/applications:' \
		-e 's:^\(icon[0-9]*dir = \)$(prefix)\(.*\):\1/usr\2:' \
		-e 's:^\(icon[0-9]*dir = \)$(datadir)\(.*\):\1/usr/share\2:' \
		client/Makefile.in \
		server/Makefile.in \
		tools/Makefile.in \
		data/icons/Makefile.in || die
	sed -i -e 's/=SDL/=X-SDL/' bootstrap/freeciv-sdl.desktop.in || die
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
			einfo "No client backend given, defaulting to"
			einfo "gtk2 client!"
			myclient=( gtk2 )
		else
			use sdl && myclient+=( sdl2 )
			use gtk && myclient+=( gtk2 )
			if use qt5 ; then
				myclient+=( qt )
				append-cxxflags -std=c++11
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
		--enable-fcmp="$(usex modpack "gtk2" "no")"
		# disabling shared libs will break aimodules USE flag
		--enable-shared
		--localedir=/usr/share/locale
		$(use_enable ipv6)
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

	if use dedicated ; then
		rm -rf "${ED}"/usr/share/pixmaps
		rm -f "${ED}"/usr/share/man/man6/freeciv-{client,gtk2,gtk3,modpack,qt,sdl,xaw}*
	else
		if use server ; then
			# Create and install the html manual. It can't be done for dedicated
			# servers, because the 'freeciv-manual' tool is then not built. Also
			# delete freeciv-manual from the GAMES_BINDIR, because it's useless.
			# Note: to have it localized, it should be ran from _postinst, or
			# something like that, but then it's a PITA to avoid orphan files...
			./tools/freeciv-manual || die
			docinto html
			dodoc classic*.html
		fi
		if use sdl ; then
			make_desktop_entry freeciv-sdl "Freeciv (SDL)" freeciv-client
		else
			rm -f "${ED}"/usr/share/man/man6/freeciv-sdl*
		fi
		rm -f "${ED}"/usr/share/man/man6/freeciv-xaw*
	fi
	find "${ED}" -name "freeciv-manual*" -delete

	rm -f "${ED}/usr/$(get_libdir)"/*.a
	find "${ED}" -name "*.la" -delete || die
}
