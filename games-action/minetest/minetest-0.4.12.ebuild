# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit cmake-utils eutils gnome2-utils user vcs-snapshot

DESCRIPTION="An InfiniMiner/Minecraft inspired game"
HOMEPAGE="http://minetest.net/"
SRC_URI="http://github.com/minetest/minetest/tarball/${PV} -> ${P}.tar.gz"

LICENSE="LGPL-2.1+ CC-BY-SA-3.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+curl dedicated doc leveldb luajit nls redis +server +sound +truetype"

RDEPEND="dev-db/sqlite:3
	sys-libs/zlib
	curl? ( net-misc/curl )
	!dedicated? (
		app-arch/bzip2
		>=dev-games/irrlicht-1.8-r2
		media-libs/libpng:0
		virtual/jpeg:0
		virtual/opengl
		x11-libs/libX11
		x11-libs/libXxf86vm
		sound? (
			media-libs/libogg
			media-libs/libvorbis
			media-libs/openal
		)
		truetype? ( media-libs/freetype:2 )
	)
	leveldb? ( dev-libs/leveldb )
	luajit? ( dev-lang/luajit:2 )
	nls? ( virtual/libintl )
	redis? ( dev-libs/hiredis )"
DEPEND="${RDEPEND}
	>=dev-games/irrlicht-1.8-r2
	doc? ( app-doc/doxygen media-gfx/graphviz )
	nls? ( sys-devel/gettext )"

pkg_setup() {
	if use server || use dedicated ; then
		enewgroup ${PN}
		enewuser ${PN} -1 -1 /var/lib/${PN} ${PN}
	fi
}

src_prepare() {
	epatch \
		"${FILESDIR}"/${PN}-0.4.12-shared-irrlicht.patch \
		"${FILESDIR}"/${PN}-0.4.12-as-needed.patch

	# set paths
	sed \
		-e "s#@BINDIR@#/usr/bin#g" \
		-e "s#@GROUP@#${PN}#g" \
		"${FILESDIR}"/minetestserver.confd > "${T}"/minetestserver.confd || die
}

src_configure() {
	local mycmakeargs=(
		$(usex dedicated "-DBUILD_SERVER=ON -DBUILD_CLIENT=OFF" "$(cmake-utils_use_build server SERVER) -DBUILD_CLIENT=ON")
		-DCUSTOM_BINDIR="/usr/bin"
		-DCUSTOM_DOCDIR="/usr/share/doc/${PF}"
		-DCUSTOM_LOCALEDIR="/usr/share/locale"
		-DCUSTOM_SHAREDIR="/usr/share/${PN}"
		-DENABLE_CURL=$(usex curl)
		$(cmake-utils_use_enable truetype FREETYPE)
		$(cmake-utils_use_enable nls GETTEXT)
		-DENABLE_GLES=0
		$(cmake-utils_use_enable leveldb LEVELDB)
		$(cmake-utils_use_enable redis REDIS)
		$(cmake-utils_use_enable sound SOUND)
		-DDISABLE_LUAJIT=$(usex !luajit)
		-DRUN_IN_PLACE=0
	)
	
	use dedicated && mycmakeargs+=(
		-DIRRLICHT_SOURCE_DIR=/the/irrlicht/source
		-DIRRLICHT_INCLUDE_DIR=/usr/include/irrlicht
	)

	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile

	if use doc ; then
		cmake-utils_src_compile doc
	fi
}

src_install() {
	cmake-utils_src_install

	if use server || use dedicated ; then
		newinitd "${FILESDIR}"/minetestserver.initd minetest-server
		newconfd "${T}"/minetestserver.confd minetest-server
	fi

	if use doc ; then
		cd "${CMAKE_BUILD_DIR}"/doc || die
		dodoc -r html
	fi
}

pkg_preinst() {
	gnome2_icon_savelist
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
