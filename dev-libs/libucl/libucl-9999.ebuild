# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( lua5-{1..3} )
inherit lua-single autotools

DESCRIPTION="Universal configuration library parser"
HOMEPAGE="https://github.com/vstakhov/libucl"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/vstakhov/libucl.git"
else
	SRC_URI="https://github.com/vstakhov/libucl/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="BSD-2"
SLOT="0/9"
IUSE="lua +regex sign urls +utils static-libs test"
REQUIRED_USE="lua? ( ${LUA_REQUIRED_USE} )"
RESTRICT="!test? ( test )"

DEPEND="!!dev-libs/ucl
	lua? ( ${LUA_DEPS} )
	urls? ( net-misc/curl )
	sign? ( dev-libs/openssl:0= )
"
BDEPEND="${DEPEND}
	virtual/pkgconfig
"
RDEPEND="${DEPEND}"

DOCS=( README.md doc/api.md )

pkg_setup() {
	use lua && lua-single_pkg_setup
}

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	local myeconfargs=(
		"$(use_enable lua)"
		"$(use_enable regex)"
		"$(use_enable sign signatures)"
		"$(use_enable urls)"
		"$(use_enable utils)"
	)
	use lua && myeconfargs+=(
		LUA_INCLUDE="$(lua_get_CFLAGS)"
		LIB_LIBS="$(lua_get_LIBS)"
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	default
	use lua && DOCS+=( "doc/lua_api.md" )
	einstalldocs
	if ! use static-libs; then
		find "${ED}" \( -name "*.a" -o -name "*.la" \) -delete || \
			die "error while deleting static library"
	fi
}
