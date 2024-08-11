# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( lua5-4 )

inherit desktop lua-single meson xdg

DESCRIPTION="Multiplayer strategy game (Civilization Clone)"
HOMEPAGE="https://www.freeciv.org/ https://github.com/freeciv/freeciv/"

if [[ ${PV} == 9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/freeciv/freeciv/"
else
	MY_PV="R${PV//./_}"
	SRC_URI="https://github.com/freeciv/freeciv/archive/refs/tags/${MY_PV}.tar.gz -> ${P}.tar.gz"
	if [[ ${PV} != *_beta* ]]; then
		KEYWORDS="~amd64 ~ppc64 ~x86"
	fi
	MY_P="${PN}-${MY_PV}"
	S="${WORKDIR}/${MY_P}"
fi

LICENSE="GPL-2+"
SLOT="0"
IUSE="dedicated gtk3 gtk4 json mapimg modpack mysql nls +qt5 qt6 readline rule-editor sdl +server +sound +system-lua web-server"

# I'm pretty sure that you can't build both qt flavours at the same time
REQUIRED_USE="
	system-lua? ( ${LUA_REQUIRED_USE} )
	!dedicated? ( || ( gtk3 gtk4 qt5 qt6 sdl ) )
	dedicated? ( !gtk3 !gtk4 !mapimg !nls !qt5 !qt6 !sdl !sound )
	qt5?  ( !qt6 )
	qt6?  ( !qt5 )
"

RDEPEND="
	app-arch/bzip2
	app-arch/xz-utils
	app-arch/zstd:=
	dev-build/libtool
	dev-db/sqlite:3
	dev-libs/icu:=
	net-misc/curl
	sys-libs/zlib
	!dedicated? (
		media-libs/libpng
		gtk3? ( x11-libs/gtk+:3 )
		gtk4? ( gui-libs/gtk:4 )
		mapimg? ( media-gfx/imagemagick:= )
		nls? ( virtual/libintl )
		qt5? (
			dev-qt/qtcore:5
			dev-qt/qtgui:5
			dev-qt/qtwidgets:5
		)
		qt6? (
			dev-qt/qtbase:6[gui,widgets]
		)
		sdl? (
			media-libs/libsdl2[video]
			media-libs/sdl2-gfx
			media-libs/sdl2-image[png]
			media-libs/sdl2-ttf
		)
		sound? (
			media-libs/libsdl2[sound]
			media-libs/sdl2-mixer[vorbis]
		)
	)
	json? ( dev-libs/jansson:= )
	readline? ( sys-libs/readline:= )
	system-lua? (
		${LUA_DEPS}
	)
"
DEPEND="${RDEPEND}
	!dedicated? ( x11-base/xorg-proto )
"
# Calls gzip during build
BDEPEND="
	app-arch/gzip
	virtual/pkgconfig
	nls? ( sys-devel/gettext )
"

pkg_setup() {
	use system-lua && lua-single_pkg_setup
}

src_prepare() {
	# Upstream's meson.build is not very friendly to our needs
	sed -i -e "s:doc/freeciv:doc/${PF}:" meson.build || die
	sed -i -e "/custom_target('gzip_ChangeLog/,+6d" meson.build || die
	default
}

src_configure() {
	# Docs here: https://github.com/freeciv/freeciv/blob/main/doc/INSTALL.meson
	local myclient=() emesonargs=() myfcmp=()

	# Upstream considers meson "experimental" until 3.2.0 according to their roadmap
	emesonargs+=( -Dack_experimental=true )

	if use dedicated || use server ; then
		emesonargs+=( -Dserver=enabled )
	elif use web-server; then
		emesonargs+=( -Dserver=freeciv-web )
	else
		emesonargs+=( -Dserver=disabled )
	fi

	# Select any client backends that we want enabled; dedicated server shouldn't build a UI
	# for sanity we'll build the modpack bin with the same UIs as the client.
	# 'fcmp' = freeciv modpack (client) - gtk3, qt, cli, gtk4
	freeciv_enable_ui() {
				local flag=$1
				local client_name=${2:-${flag}}
				local fcmp_name=${3:-${client_name}}

				if use ${flag} ; then
					myclient+=( ${client_name} )
					use modpack && myfcmp+=( ${fcmp_name} )
				fi
			}

	if ! use dedicated ; then
		# there's no SDL modpack backend; rather than incidentally pull in GTK3 (as is default)
		# let's explicitly set the backend to CLI
		freeciv_enable_ui sdl sdl2 cli
		freeciv_enable_ui gtk3 gtk3.22 gtk3
		freeciv_enable_ui gtk4
		freeciv_enable_ui qt5 qt
		freeciv_enable_ui qt6 qt
		use qt5 && emesonargs+=( -Dqtver=qt5 )
		use qt6 && emesonargs+=( -Dqtver=qt6 )
	else
		if use modpack ; then
			myfcmp+=( cli )
		fi
	fi

	# the client and fpmc arrays are now populated (or not for dedicated); let's add them to emesonargs
	emesonargs+=(
		-Dclients=$(echo ${myclient[*]} | sed 's/ /,/g')
		-Dfcmp=$(echo ${myfcmp[*]} | sed 's/ /,/g')
	)

	# If we're building a live ebuild, we want to include the git revision in the version string
	if [[ ${PV} == 9999 ]] ; then
		emesonargs+=( -Dgitrev=true )
	fi

	# Anything that can be trivially set by meson_use goes here
	emesonargs+=(
		$(meson_use json json-protocol)
		$(meson_use mapimg mwand)
		$(meson_use nls)
		$(meson_use readline)
		$(meson_use rule-editor ruledit)
		$(meson_use sound audio)
		$(meson_use system-lua syslua)
	)

	meson_src_configure
}

src_install() {

	meson_src_install
	# Create and install the html manual and then cleanup the tool because it's useless.
	# TODO: for proper localisation this should be run during postinst but
	# that would require a lot of work to avoid orphan files.
	# freeciv-manual only supports one ruleset argument at a time.
	elog "Generating html manual..."
	for RULESET in alien civ1 civ2 civ2civ3 classic experimental multiplayer sandbox
	do
		$(find "${WORKDIR}" -type d -maxdepth 1 -mindepth 1 -iname '*-build')/freeciv-manual -r ${RULESET} || die
		docinto html/rulesets/${RULESET}
		dodoc ${RULESET}*.html
	done

	find "${ED}" -name "freeciv-manual*" -delete || die "Failed to remove freeciv-manual"

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
	fi

}

pkg_postinst() {
	if [[ -z ${REPLACING_VERSIONS} ]]; then
		einfo "There are a number of supported authentication backends."
		einfo "sqlite3 is the default, however dedicated servers may wish to"
		einfo "use another supported backend; please consult the documentation"
		einfo "to configure freeciv for a particular backend:"
		einfo "https://github.com/freeciv/freeciv/blob/main/doc/README.fcdb"
	fi
}
