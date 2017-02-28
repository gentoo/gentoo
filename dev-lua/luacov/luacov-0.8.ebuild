# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit eutils

DESCRIPTION="LuaCov is a simple coverage analyzer for Lua scripts"
HOMEPAGE="https://github.com/keplerproject/luacov"
SRC_URI="https://github.com/keplerproject/luacov/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

COMMON_DEPEND=">=dev-lang/lua-5.1:="
DEPEND="${COMMON_DEPEND}
virtual/pkgconfig"
RDEPEND="${COMMON_DEPEND}"

src_prepare() {
	epatch "${FILESDIR}"/${PF}-fix-makefile.patch
}

src_compile() {
	return 0
}

src_install() {
	emake DESTDIR="${ED}" \
		PREFIX=/usr \
		LUADIR="$(pkg-config --variable INSTALL_LMOD lua)" install
dohtml -r doc/*
	dodoc -r examples
}
