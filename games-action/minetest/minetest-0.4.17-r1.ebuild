# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit cmake-utils gnome2-utils user

DESCRIPTION="An InfiniMiner/Minecraft inspired game"
HOMEPAGE="https://www.minetest.net"
SRC_URI="https://github.com/${PN}/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1+ CC-BY-SA-3.0 OFL-1.1 Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+curl dedicated doc jsoncpp +leveldb luajit ncurses nls postgres redis +server +sound spatial +truetype"

RDEPEND="dev-db/sqlite:3
	sys-libs/zlib
	curl? ( net-misc/curl )
	!dedicated? (
		app-arch/bzip2
		>=dev-games/irrlicht-1.8-r2
		dev-libs/gmp:0=
		media-libs/libpng:0=
		virtual/jpeg:0
		virtual/opengl
		x11-libs/libX11
		x11-libs/libXxf86vm
		sound? (
			media-libs/libogg:=
			media-libs/libvorbis:=
			media-libs/openal:=
		)
		truetype? ( media-libs/freetype:2 )
	)
	jsoncpp? ( dev-libs/jsoncpp )
	leveldb? ( dev-libs/leveldb:= )
	luajit? ( dev-lang/luajit:2 )
	ncurses? ( sys-libs/ncurses:0= )
	nls? ( virtual/libintl )
	postgres? ( >=dev-db/postgresql-9.5:= )
	redis? ( dev-libs/hiredis )
	spatial? ( sci-libs/libspatialindex )"
DEPEND="${RDEPEND}
	>=dev-games/irrlicht-1.8-r2
	doc? (
		app-doc/doxygen
		media-gfx/graphviz
	)
	nls? ( sys-devel/gettext )"

pkg_setup() {
	if use server || use dedicated ; then
		enewgroup ${PN}
		enewuser ${PN} -1 -1 /var/lib/${PN} ${PN}
	fi
}

src_prepare() {
	cmake-utils_src_prepare
	# set paths
	sed \
		-e "s#@BINDIR@#${EPREFIX}/usr/bin#g" \
		-e "s#@GROUP@#${PN}#g" \
		"${FILESDIR}"/minetestserver.confd > "${T}"/minetestserver.confd || die
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_CLIENT=$(usex !dedicated)
		-DCUSTOM_BINDIR="${EPREFIX}/usr/bin"
		-DCUSTOM_DOCDIR="${EPREFIX}/usr/share/doc/${PF}"
		-DCUSTOM_EXAMPLE_CONF_DIR="${EPREFIX}/usr/share/doc/${PF}"
		-DCUSTOM_LOCALEDIR="${EPREFIX}/usr/share/${PN}/locale"
		-DCUSTOM_SHAREDIR="${EPREFIX}/usr/share/${PN}"
		-DENABLE_CURL=$(usex curl)
		-DENABLE_CURSES=$(usex ncurses)
		-DENABLE_FREETYPE=$(usex truetype)
		-DENABLE_GETTEXT=$(usex nls)
		-DENABLE_GLES=0
		-DENABLE_LEVELDB=$(usex leveldb)
		-DENABLE_LUAJIT=$(usex luajit)
		-DENABLE_POSTGRESQL=$(usex postgres)
		-DENABLE_REDIS=$(usex redis)
		-DENABLE_SPATIAL=$(usex spatial)
		-DENABLE_SOUND=$(usex sound)
		-DENABLE_SYSTEM_JSONCPP=$(usex jsoncpp)
		-DRUN_IN_PLACE=0
	)

	use dedicated && mycmakeargs+=(
		-DIRRLICHT_INCLUDE_DIR="${EPREFIX}/usr/include/irrlicht"
	)

	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile

	if use doc ; then
		cmake-utils_src_compile doc
		HTML_DOCS=( "${CMAKE_BUILD_DIR}"/doc/html/. )
	fi
}

src_install() {
	cmake-utils_src_install

	if use server || use dedicated ; then
		newinitd "${FILESDIR}"/minetestserver.initd minetest-server
		newconfd "${T}"/minetestserver.confd minetest-server
	fi
}

pkg_postinst() {
	gnome2_icon_cache_update

	if ! use dedicated ; then
		elog
		elog "optional dependencies:"
		elog "	games-action/minetest_game (official mod)"
		elog
	fi

	if use server || use dedicated ; then
		elog
		elog "Configure your server via /etc/conf.d/minetest-server"
		elog "The user \"minetest\" is created with /var/lib/${PN} homedir."
		elog "Default logfile is ~/minetest-server.log"
		elog
	fi
}

pkg_postrm() {
	gnome2_icon_cache_update
}
