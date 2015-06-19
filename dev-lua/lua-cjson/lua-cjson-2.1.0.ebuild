# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-lua/lua-cjson/lua-cjson-2.1.0.ebuild,v 1.3 2015/06/06 19:40:03 jlec Exp $

EAPI=5

inherit cmake-utils

DESCRIPTION="A fast JSON encoding/parsing module for Lua"
HOMEPAGE="http://www.kyne.com.au/~mark/software/lua-cjson.php https://github.com/mpx/lua-cjson/"
SRC_URI="http://www.kyne.com.au/~mark/software/download/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc test"

RDEPEND=">=dev-lang/lua-5.1:0"
DEPEND="${RDEPEND}
	test? ( dev-lang/perl )"

DOCS=( NEWS THANKS )

src_test() {
	cd tests || die
	ln -s "${BUILD_DIR}"/cjson.so ./ || die
	ln -s "${S}"/lua/cjson ./ || die
	./genutf8.pl || die
	./test.lua || die
}

src_install() {
	cmake-utils_src_install
	use doc && dohtml manual.html performance.html
}
