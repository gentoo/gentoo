# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CMAKE_BUILD_TYPE="Release"
LUA_COMPAT=( lua5-1 luajit )

inherit cmake flag-o-matic lua-single systemd xdg

DESCRIPTION="A free open-source voxel game engine with easy modding and game creation"
HOMEPAGE="https://www.minetest.net"
SRC_URI="https://github.com/${PN}/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1+ CC-BY-SA-3.0 OFL-1.1 Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~riscv"
IUSE="+client +curl doc leveldb ncurses nls postgres prometheus redis +server +sound spatial test"

REQUIRED_USE="${LUA_REQUIRED_USE}
	|| ( client server )"

RESTRICT="!test? ( test )"

RDEPEND="${LUA_DEPS}
	$(lua_gen_impl_dep 'deprecated' lua5-1)
	app-arch/zstd
	dev-db/sqlite:3
	dev-libs/gmp:0=
	dev-libs/jsoncpp:=
	sys-libs/zlib
	client? (
		>=dev-games/irrlicht-mt-1.9.0.8
		media-libs/freetype:2
		media-libs/libpng:0=
		media-libs/libjpeg-turbo
		virtual/opengl
		x11-libs/libX11
		x11-libs/libXxf86vm
		sound? (
			media-libs/libvorbis
			media-libs/openal
		)
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
		>=dev-games/irrlicht-mt-headers-1.9.0.8
	)
	spatial? ( sci-libs/libspatialindex:= )"
DEPEND="${RDEPEND}"
BDEPEND="
	doc? (
		app-doc/doxygen
		media-gfx/graphviz
	)
	nls? ( sys-devel/gettext )"

PATCHES=(
	"${FILESDIR}"/${PN}-5.4.1-system_puc_lua.patch
	"${FILESDIR}"/${PN}-5.6.0-no_upstream_optflags.patch
)

src_prepare() {
	cmake_src_prepare

	# remove bundled libraries other than bitop
	rm -rf lib/{gmp,jsoncpp,lua} || die

	# To avoid TEXTRELs on riscv
	append-flags -fPIC
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
		-DCUSTOM_MANDIR="${EPREFIX}/usr/share/man"
		-DCUSTOM_SHAREDIR="${EPREFIX}/usr/share/${PN}"
		-DENABLE_CURL=$(usex curl)
		-DENABLE_CURSES=$(usex ncurses)
		-DENABLE_GETTEXT=$(usex nls)
		-DENABLE_GLES=no
		-DENABLE_LEVELDB=$(usex leveldb)
		-DENABLE_LUAJIT=$(usex lua_single_target_luajit)
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

	if use doc; then
		cmake_src_compile doc
		HTML_DOCS=( "${BUILD_DIR}"/doc/html/. )
	fi
}

src_install() {
	cmake_src_install

	if use server; then
		keepdir /etc/minetest
		fowners root:minetest /etc/minetest
		fperms 2750 /etc/minetest

		keepdir /var/log/minetest
		fowners minetest:minetest /var/log/minetest

		newconfd "${FILESDIR}"/minetestserver.confd minetest-server
		newinitd "${FILESDIR}"/minetestserver.initd minetest-server

		systemd_newunit "${FILESDIR}"/minetestserver_default.service minetest-server.service
		systemd_newunit "${FILESDIR}"/minetestserver_template.service minetest-server@.service

		insinto /etc/logrotate.d
		newins "${FILESDIR}"/minetestserver.logrotate minetest-server
	fi
}

pkg_postinst() {
	xdg_pkg_postinst
}
