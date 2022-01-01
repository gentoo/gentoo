# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

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
SLOT="0"

IUSE="lua +regex sign urls +utils static-libs"

DEPEND="!!dev-libs/ucl
	lua? ( >=dev-lang/lua-5.1:0= )
	urls? ( net-misc/curl )
	sign? ( dev-libs/openssl:0 )
"
BDEPEND="${DEPEND}
	virtual/pkgconfig
"
RDEPEND="${DEPEND}"

DOCS=( README.md doc/api.md )

src_prepare() {
	default
	rm tests/schema/{definitions,ref{,Remote}}.json || die

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
	econf "${myeconfargs}"
}

src_install() {
	default
	DOCS+=( $(usex lua "doc/lua_api.md" "") )
	einstalldocs
	if ! use static-libs; then
		find "${ED}" \( -name "*.a" -o -name "*.la" \) -delete || \
			die "error while deleting static library"
	fi
}
