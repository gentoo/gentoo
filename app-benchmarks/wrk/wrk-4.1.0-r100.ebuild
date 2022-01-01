# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LUA_COMPAT=( luajit )

inherit lua-single

DESCRIPTION="A HTTP benchmarking tool"
HOMEPAGE="https://www.github.com/wg/wrk"
SRC_URI="https://www.github.com/wg/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

KEYWORDS="amd64 ~x86"
LICENSE="Apache-2.0 BSD MIT"
SLOT="0"
IUSE="libressl"
REQUIRED_USE="${LUA_REQUIRED_USE}"

RDEPEND="
	libressl? ( dev-libs/libressl:0= )
	!libressl? ( dev-libs/openssl:0= )
	${LUA_DEPS}
"

DEPEND="${RDEPEND}"

DOCS=( "CHANGES" "NOTICE" "README.md" "SCRIPTING" )

PATCHES=( "${FILESDIR}/${P}-r100-makefile.patch" )

src_compile() {
	myemakeargs=(
		CC="$(tc-getCC)"
		LUA_LIBS="$(lua_get_LIBS)"
		VER="${PV}"
		WITH_LUAJIT="$(lua_get_CFLAGS)"
		WITH_OPENSSL="/usr"
	)

	emake "${myemakeargs[@]}"
}

src_install() {
	dobin wrk

	insinto /usr/share/wrk
	doins -r scripts

	einstalldocs
}
