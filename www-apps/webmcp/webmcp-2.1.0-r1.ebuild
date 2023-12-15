# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LUA_COMPAT=( lua5-{2,3} )

inherit lua-single toolchain-funcs

MY_P=${PN}-v${PV}
DESCRIPTION="Web application framework written in Lua and C"
HOMEPAGE="https://www.public-software-group.org/webmcp"
SRC_URI="https://www.public-software-group.org/pub/projects/${PN}/v${PV}/${MY_P}.tar.gz"

LICENSE="HPND"
KEYWORDS="~amd64"
SLOT=0

RDEPEND="
	${LUA_DEPS}
	dev-db/postgresql:=
"
DEPEND="${RDEPEND}"

REQUIRED_USE="${LUA_REQUIRED_USE}"

S="${WORKDIR}"/${MY_P}

PATCHES=(
	"${FILESDIR}"/${P}-gentoo.patch
	"${FILESDIR}"/${P}-c99.patch
)

src_compile() {
	emake CC="$(tc-getCC)" \
		CFLAGS="${CFLAGS} \
		$(lua_get_CFLAGS) -fPIC" \
		LD="$(tc-getCC)" \
		LDFLAGS="${LDFLAGS} -shared" \
		LDFLAGS_PGSQL="-L `pg_config --libdir`" \
		LUALIBS="$(lua_get_LIBS)"
}

src_install() {
	insinto /usr/lib/${PN}
	doins -r framework.precompiled/*
}
