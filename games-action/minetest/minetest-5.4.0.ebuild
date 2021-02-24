# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LUA_COMPAT=( luajit )

inherit cmake lua-single xdg

DESCRIPTION="A free open-source voxel game engine with easy modding and game creation"
HOMEPAGE="https://www.minetest.net"
SRC_URI="https://github.com/${PN}/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1+ CC-BY-SA-3.0 OFL-1.1 Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+client +curl doc +leveldb ncurses nls postgres prometheus redis +server +sound spatial test +truetype"
REQUIRED_USE="
	${LUA_REQUIRED_USE}
	|| ( client server )"
RESTRICT="!test? ( test )"

RDEPEND="
	${LUA_DEPS}
	dev-db/sqlite:3
	dev-libs/gmp:0=
	dev-libs/jsoncpp:=
	sys-libs/zlib
	client? (
		app-arch/bzip2
		dev-games/irrlicht
		media-libs/libpng:0=
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
	curl? ( net-misc/curl )
	leveldb? ( dev-libs/leveldb:= )
	ncurses? ( sys-libs/ncurses:0= )
	nls? ( virtual/libintl )
	postgres? ( >=dev-db/postgresql-9.5:= )
	prometheus? ( dev-cpp/prometheus-cpp )
	redis? ( dev-libs/hiredis:= )
	server? (
		acct-group/minetest
		acct-user/minetest
		dev-games/irrlicht-headers
	)
	spatial? ( sci-libs/libspatialindex:= )"
DEPEND="${RDEPEND}"
BDEPEND="
	doc? (
		app-doc/doxygen
		media-gfx/graphviz
	)
	nls? ( sys-devel/gettext )"

src_prepare() {
	cmake_src_prepare
	# set paths
	sed \
		-e "s#@BINDIR@#${EPREFIX}/usr/bin#g" \
		-e "s#@GROUP@#${PN}#g" \
		"${FILESDIR}"/minetestserver.confd > "${T}"/minetestserver.confd || die

	# remove bundled libraries
	rm -rf lib || die
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_CLIENT=$(usex client)
		-DBUILD_SERVER=$(usex server)
		-DBUILD_UNITTESTS=$(usex test)
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
		-DENABLE_LUAJIT=1
		-DENABLE_POSTGRESQL=$(usex postgres)
		-DENABLE_PROMETHEUS=$(usex prometheus)
		-DENABLE_REDIS=$(usex redis)
		-DENABLE_SPATIAL=$(usex spatial)
		-DENABLE_SOUND=$(usex sound)
		-DENABLE_SYSTEM_GMP=1
		-DENABLE_SYSTEM_JSONCPP=1
		-DRUN_IN_PLACE=0
	)

	cmake_src_configure
}

src_compile() {
	cmake_src_compile

	if use doc ; then
		cmake_src_compile doc
		HTML_DOCS=( "${BUILD_DIR}"/doc/html/. )
	fi
}

src_install() {
	cmake_src_install

	if use server ; then
		keepdir /var/log/minetest
		fowners minetest:minetest /var/log/minetest

		newconfd "${T}"/minetestserver.confd minetest-server
		newinitd "${FILESDIR}"/minetestserver.initd minetest-server

		insinto /etc/logrotate.d
		newins "${FILESDIR}"/minetestserver.logrotate minetest-server
	fi
}

pkg_postinst() {
	xdg_pkg_postinst

	if use server ; then
		elog
		elog "Configure your server via /etc/conf.d/minetest-server"
		elog
	fi

	elog
	elog "The version 5.x series is not compatible to the version 0.4 series."
	elog "This applies to clients and servers, other content such as mods,"
	elog "texture packs and worlds is unaffected and backwards-compatible"
	elog "as usual."
	elog
}
