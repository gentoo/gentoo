# Copyright 2020-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Embeddable, replicated and fault tolerant SQL engine"
HOMEPAGE="https://dqlite.io/ https://github.com/canonical/dqlite"
SRC_URI="https://github.com/canonical/dqlite/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-3-with-linking-exception"
SLOT="0/1.18.0"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="+lz4 test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-db/sqlite-3.34.0:3
	dev-libs/libuv:=
	lz4? ( app-arch/lz4:= )
"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/dqlite-1.18.0-disable-werror.patch
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	local myeconfargs=(
		--disable-backtrace
		--disable-debug
		--disable-sanitize
		--disable-static

		# Linking to a separately-built libraft is no longer supported.
		--enable-build-raft=yes

		# Will build a bundled libsqlite3.so.
		--enable-build-sqlite=no

		$(use_with lz4)
	)

	econf "${myeconfargs[@]}"
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die
}
