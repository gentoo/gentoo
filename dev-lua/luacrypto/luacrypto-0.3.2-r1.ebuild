# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit eutils autotools

DESCRIPTION="Lua frontend to OpenSSL"
HOMEPAGE="http://mkottman.github.io/luacrypto/ https://github.com/mkottman/luacrypto/"
SRC_URI="https://github.com/mkottman/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="libressl"

RDEPEND="
	>=dev-lang/lua-5.1:0
	!libressl? ( dev-libs/openssl:0 ) libressl? ( dev-libs/libressl:0 )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	epatch "${FILESDIR}"/${P}-lualibdir.patch
	eautoreconf
}

src_configure() {
	econf --htmldir=/usr/share/doc/${PF}/html
}

src_test() {
	emake test
}

src_install() {
	default
	prune_libtool_files --modules
}
