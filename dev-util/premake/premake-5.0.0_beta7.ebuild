# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( lua5-3 )

inherit lua-single toolchain-funcs

MY_PV=${PV/_/-}

DESCRIPTION="A makefile generation tool"
HOMEPAGE="https://premake.github.io"
SRC_URI="https://github.com/premake/premake-core/archive/v${MY_PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-core-${MY_PV}"

LICENSE="BSD"
SLOT="5"
KEYWORDS="amd64 ~arm64 ppc ~ppc64 x86"

REQUIRED_USE="${LUA_REQUIRED_USE}"
RDEPEND="
	${LUA_DEPS}
	$(lua_gen_cond_dep '
		dev-lua/luasocket[${LUA_USEDEP}]
	')
	dev-libs/libzip
	net-misc/curl
	sys-apps/util-linux
	"
DEPEND="${RDEPEND}"

src_compile() {
	# bug #773505
	tc-export AR CC

	emake -f Bootstrap.mak PREMAKE_OPTS="--zlib-src=system --curl-src=system --lua-src=system" linux
}

src_test() {
	bin/release/premake${SLOT} test || die
}

src_install() {
	dobin bin/release/premake${SLOT}

	einstalldocs
}
