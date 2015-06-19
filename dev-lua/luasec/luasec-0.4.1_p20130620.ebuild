# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-lua/luasec/luasec-0.4.1_p20130620.ebuild,v 1.4 2015/06/06 19:43:42 jlec Exp $

EAPI=5

inherit vcs-snapshot multilib toolchain-funcs

DESCRIPTION="Lua binding for OpenSSL library to provide TLS/SSL communication"
HOMEPAGE="https://github.com/brunoos/luasec http://www.inf.puc-rio.br/~brunoos/luasec/"
COMMIT="063e8a8a5c57858cdc845f8d51b994426edd37ab"
SRC_URI="https://github.com/brunoos/luasec/tarball/${COMMIT} -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 arm ~x86"
IUSE=""

RDEPEND="
	>=dev-lang/lua-5.1:0[deprecated]
	dev-lua/luasocket
	dev-libs/openssl:0"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	sed -i -e "s#^LUAPATH.*#LUAPATH=$(pkg-config --variable INSTALL_LMOD lua)#"\
		-e "s#^LUACPATH.*#LUACPATH=$(pkg-config --variable INSTALL_CMOD lua)#" Makefile || die
	sed -i -e "s/-O2//" src/Makefile || die
}

src_compile() {
	emake \
		CC="$(tc-getCC)" \
		LD="$(tc-getCC)" \
		linux
}
