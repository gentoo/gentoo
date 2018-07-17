# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit eutils toolchain-funcs

DESCRIPTION="OpenSSL binding for Lua"
HOMEPAGE="https://github.com/zhaozg/lua-openssl"
SRC_URI="https://github.com/zhaozg/lua-openssl/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT openssl PHP-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="libressl luajit"
PATCHES="${FILESDIR}/${P}-Makefile.patch"

RDEPEND="
	luajit? ( dev-lang/luajit:* )
	!luajit? ( >=dev-lang/lua-5.1:*[deprecated] )
	!libressl? ( dev-libs/openssl:0=[-bindist] )
	libressl? ( dev-libs/libressl:0= )
	"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
        epatch "${FILESDIR}/${P}-Makefile.patch"
        use luajit && LUAV=luajit || LUAV=lua
}
