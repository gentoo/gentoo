# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( lua5-{1..4} luajit )

inherit lua

MY_PN="mmdblua"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Maxmind database parser for lua"
HOMEPAGE="https://github.com/daurnimator/mmdblua"
EGIT_COMMIT_MAXMIND="1ca40fbf5223b61bc26c5dae4335942b56327c85"
SRC_URI="https://github.com/daurnimator/${MY_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	test? ( https://github.com/maxmind/MaxMind-DB/archive/${EGIT_COMMIT_MAXMIND}.tar.gz
			-> ${P}-maxminddb-${EGIT_COMMIT_MAXMIND}.tar.gz )"

S="${WORKDIR}/${MY_P}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

REQUIRED_USE="${LUA_REQUIRED_USE}"

DEPEND="
	${LUA_DEPS}
	lua_targets_luajit? ( dev-lua/compat53[lua_targets_luajit(-)] )
	lua_targets_lua5-1? ( dev-lua/compat53[lua_targets_lua5-1(-)] )
"
RDEPEND="${DEPEND}"

lua_enable_tests busted

src_unpack() {
	unpack ${P}.tar.gz

	if use test; then
		tar -xf "${DISTDIR}"/${P}-maxminddb-${EGIT_COMMIT_MAXMIND}.tar.gz \
			-C "${S}"/spec/MaxMind-DB --strip-components=1 || die
	fi
}

src_prepare() {
	default
	sed -e 's:require "mmdb":require "mmdb.init":' -i spec/test-data_spec.lua || die
	lua_copy_sources
}

lua_src_install() {
	insinto $(lua_get_lmod_dir)/mmdb/
	doins mmdb/init.lua
}

src_install() {
	lua_foreach_impl lua_src_install
	einstalldocs
}
