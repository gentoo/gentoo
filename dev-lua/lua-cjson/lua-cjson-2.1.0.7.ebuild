# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils

DESCRIPTION="A fast JSON encoding/parsing module for Lua"
HOMEPAGE="https://www.kyne.com.au/~mark/software/lua-cjson.php https://github.com/openresty/lua-cjson"
SRC_URI="https://github.com/openresty/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+internal-fpconv luajit test +threads"
RESTRICT="!test? ( test )"

REQUIRED_USE="threads? ( internal-fpconv )"

RDEPEND=">=dev-lang/lua-5.1:0"
DEPEND="${RDEPEND}"
BDEPEND="test? ( dev-lang/perl )"

DOCS=( NEWS README.md THANKS manual.txt performance.txt )

PATCHES=(
	"${FILESDIR}"/sparse_array_test_fix.patch
)

src_configure() {
	local mycmakeargs=(
		-DUSE_INTERNAL_FPCONV="$(usex internal-fpconv)"
		-DMULTIPLE_THREADS="$(usex threads)"
	)

	cmake-utils_src_configure
}

src_test() {
	cd tests || die
	ln -s "${BUILD_DIR}"/cjson.so ./ || die
	ln -s "${S}"/lua/cjson ./ || die
	./genutf8.pl || die
	./test.lua || die
}
