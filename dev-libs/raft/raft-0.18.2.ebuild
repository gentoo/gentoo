# Copyright 2020-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="C implementation of the Raft consensus protocol"
HOMEPAGE="https://github.com/cowsql/raft"
SRC_URI="https://github.com/cowsql/raft/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-3-with-linking-exception"

# Upstream change from canonical to cowsql resetted SONAME, 3 -> 0. bgo#915960
SLOT="0/0"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="lz4 test zfs"
RESTRICT="!test? ( test )"

DEPEND="dev-libs/libuv:=
	lz4? ( app-arch/lz4:= )"
RDEPEND="${DEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/raft-0.10.0-toggle-zfs.patch
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	local myeconfargs=(
		--enable-uv

		--disable-backtrace
		--disable-benchmark
		--disable-debug
		--disable-example
		--disable-sanitize
		--disable-static

		$(use_enable test fixture)

		$(use_with lz4)
		$(use_with zfs)
	)

	econf "${myeconfargs[@]}"
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die
}
