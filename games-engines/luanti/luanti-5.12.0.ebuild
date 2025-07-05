# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( lua5-1 luajit )

inherit cmake edo eapi9-ver flag-o-matic lua-single systemd xdg

DESCRIPTION="A free open-source voxel game engine with easy modding and game creation"
HOMEPAGE="https://www.luanti.org/"
SRC_URI="
	https://github.com/luanti-org/luanti/archive/${PV}.tar.gz
		-> ${P}.tar.gz
"

LICENSE="LGPL-2.1+ CC-BY-SA-3.0 OFL-1.1 Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~riscv"
IUSE="benchmark +client +curl doc leveldb ncurses nls openssl postgres prometheus redis sdl +server +sound spatial test-install"

REQUIRED_USE="
	${LUA_REQUIRED_USE}
	|| ( client server )
"

RESTRICT="!test-install? ( test )"

# Use bundled PUC Lua if lua5-1 has been requested requested due to C++
# interoperability issues, at least until Bug #825766 has been resolved anyway.
RDEPEND="
	app-arch/zstd:=
	dev-db/sqlite:3
	dev-libs/gmp:0=
	dev-libs/jsoncpp:=
	sys-libs/zlib
	client? (
		media-libs/freetype:2
		media-libs/libpng:0=
		media-libs/libjpeg-turbo:=
		virtual/opengl
		sdl? ( media-libs/libsdl2 )
		!sdl? (
			x11-libs/libX11
			x11-libs/libXi
		)
		sound? (
			media-libs/libvorbis
			media-libs/openal
		)
	)
	curl? ( net-misc/curl )
	leveldb? ( dev-libs/leveldb:= )
	lua_single_target_luajit? ( ${LUA_DEPS} )
	ncurses? ( sys-libs/ncurses:0= )
	nls? ( virtual/libintl )
	openssl? ( dev-libs/openssl:= )
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
		app-text/doxygen[dot]
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
		-DENABLE_LTO=OFF # respect user cflags
		-DENABLE_SYSTEM_GMP=ON
		-DENABLE_SYSTEM_JSONCPP=ON
		-DENABLE_UPDATE_CHECKER=OFF
		-DPRECOMPILE_HEADERS=OFF
		-DRUN_IN_PLACE=OFF

		-DCUSTOM_BINDIR="${EPREFIX}/usr/bin"
		-DCUSTOM_DOCDIR="${EPREFIX}/usr/share/doc/${PF}"
		-DCUSTOM_EXAMPLE_CONF_DIR="${EPREFIX}/usr/share/doc/${PF}"
		-DCUSTOM_LOCALEDIR="${EPREFIX}/usr/share/luanti/locale"
		-DCUSTOM_MANDIR="${EPREFIX}/usr/share/man"
		-DCUSTOM_SHAREDIR="${EPREFIX}/usr/share/luanti"

		-DBUILD_BENCHMARKS=$(usex benchmark)
		-DBUILD_CLIENT=$(usex client)
		-DBUILD_SERVER=$(usex server)
		-DBUILD_UNITTESTS=$(usex test-install)
		-DENABLE_CURL=$(usex curl)
		-DENABLE_CURSES=$(usex ncurses)
		-DENABLE_GETTEXT=$(usex nls)
		-DENABLE_LEVELDB=$(usex leveldb)
		-DENABLE_LUAJIT=$(usex lua_single_target_luajit)
		-DENABLE_OPENSSL=$(usex openssl)
		-DENABLE_POSTGRESQL=$(usex postgres)
		-DENABLE_PROMETHEUS=$(usex prometheus)
		-DENABLE_REDIS=$(usex redis)
		-DENABLE_SOUND=$(usex sound)
		-DENABLE_SPATIAL=$(usex spatial)
		# Linux devices use X11 unless SDL is enabled
		-DUSE_SDL2=$(usex sdl)
		-DUSE_SDL2_STATIC=OFF

		-DINSTALL_DEVTEST=$(usex test-install)
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
	local -x MINETEST_GAME_PATH="${S}/games"

	if use client; then
		edo "${S}"/bin/luanti --run-unittests
	fi

	if use server; then
		edo "${S}"/bin/luantiserver --run-unittests
		# Affected by system files. Eg previous luanti will cause a test failure
		#edo "${S}"/util/test_multiplayer.sh
	fi
}

src_install() {
	cmake_src_install

	if use server; then
		# TODO: renaming users and groups opens the ID can of worms

		# Upstream hasn't changed the configuration file locations yet
		keepdir /etc/minetest
		fowners root:minetest /etc/minetest
		fperms 2750 /etc/minetest

		keepdir /var/log/luanti
		fowners minetest:minetest /var/log/luanti

		newconfd "${FILESDIR}"/luantiserver.confd luanti-server
		newinitd "${FILESDIR}"/luantiserver.initd luanti-server

		systemd_newunit "${FILESDIR}"/luantiserver_default.service luanti-server.service
		systemd_newunit "${FILESDIR}"/luantiserver_template.service luanti-server@.service

		insinto /etc/logrotate.d
		newins "${FILESDIR}"/luantiserver.logrotate luanti-server

		# For backwards compatiblity, can be removed when upstream removes their minetest symlinks
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

	if ver_replacing -lt 5.12; then
		elog "Minetest has been renamed to Luanti in 5.10.0"
		elog "Configuration remains unchanged, and minetest binaries and service scripts exist"
		elog "for backwards compatibility for the time being."
		elog
		elog "https://blog.luanti.org/2024/10/13/Introducing-Our-New-Name/"
	fi
}
