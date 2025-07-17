# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CMAKE_BUILD_TYPE="Release"
LUA_COMPAT=( lua5-1 luajit )

inherit cmake flag-o-matic lua-single systemd xdg

MY_PN="luanti"
MY_P="${MY_PN}-${PV}"
MY_PF="${MY_PN}-${PVR}"

DESCRIPTION="A free open-source voxel game engine with easy modding and game creation"
HOMEPAGE="https://www.luanti.org/"
SRC_URI="https://github.com/luanti-org/${MY_PN}/archive/${PV}.tar.gz -> ${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="LGPL-2.1+ CC-BY-SA-3.0 OFL-1.1 Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~riscv"
IUSE="+client +curl doc leveldb ncurses nls postgres prometheus redis +server +sound spatial test"
# NOTE: test USE flag controls compiling the tests, they need to be run
# manually. we do that in src_test but maybe USE=test-install could be used?

REQUIRED_USE="${LUA_REQUIRED_USE}
	|| ( client server )"

RESTRICT="!test? ( test )"

# Use bundled PUC Lua if lua5-1 has been requested requested due to C++
# interoperability issues, at least until Bug #825766 has been resolved anyway.
RDEPEND="lua_single_target_luajit? ( ${LUA_DEPS} )
	app-arch/zstd
	dev-db/sqlite:3
	dev-libs/gmp:0=
	dev-libs/jsoncpp:=
	sys-libs/zlib
	client? (
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
	)
	spatial? ( sci-libs/libspatialindex:= )"
DEPEND="${RDEPEND}"
BDEPEND="
	doc? (
		app-text/doxygen
		media-gfx/graphviz
	)
	nls? ( sys-devel/gettext )"

PATCHES=(
	"${FILESDIR}"/minetest-5.9.1-no_upstream_optflags.patch
)

src_prepare() {
	cmake_src_prepare

	# To avoid TEXTRELs on riscv
	append-flags -fPIC
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_CLIENT=$(usex client)
		-DBUILD_SERVER=$(usex server)
		-DBUILD_UNITTESTS=$(usex test)
		-DCUSTOM_BINDIR="${EPREFIX}/usr/bin"
		-DCUSTOM_DOCDIR="${EPREFIX}/usr/share/doc/${MY_PF}"
		-DCUSTOM_EXAMPLE_CONF_DIR="${EPREFIX}/usr/share/doc/${MY_PF}"
		-DCUSTOM_LOCALEDIR="${EPREFIX}/usr/share/${MY_PN}/locale"
		-DCUSTOM_MANDIR="${EPREFIX}/usr/share/man"
		-DCUSTOM_SHAREDIR="${EPREFIX}/usr/share/${MY_PN}"
		-DENABLE_CURL=$(usex curl)
		-DENABLE_CURSES=$(usex ncurses)
		-DENABLE_GETTEXT=$(usex nls)
		-DENABLE_LEVELDB=$(usex leveldb)
		-DENABLE_LUAJIT=$(usex lua_single_target_luajit)
		-DENABLE_POSTGRESQL=$(usex postgres)
		-DENABLE_PROMETHEUS=$(usex prometheus)
		-DENABLE_REDIS=$(usex redis)
		-DENABLE_SPATIAL=$(usex spatial)
		-DENABLE_SOUND=$(usex sound)
		-DENABLE_SYSTEM_GMP=1
		-DENABLE_SYSTEM_JSONCPP=1
		-DENABLE_UPDATE_CHECKER=no
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

src_test() {
	"${S}"/bin/./minetest --run-unittests || die
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
