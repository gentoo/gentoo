# Copyright 2020-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Embeddable, replicated and fault tolerant SQL engine"
HOMEPAGE="https://dqlite.io/ https://github.com/canonical/dqlite"
SRC_URI="https://github.com/canonical/dqlite/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-3-with-linking-exception"
SLOT="0/1.12.0"
KEYWORDS="amd64 ~arm64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="dev-db/sqlite:3
	dev-libs/libuv:=
	>=dev-libs/raft-0.17.1:="
DEPEND="${RDEPEND}
	test? ( >=dev-libs/raft-0.13.0[lz4,test] )"
BDEPEND="virtual/pkgconfig"

PATCHES=( "${FILESDIR}"/dqlite-1.12.0-disable-werror.patch )

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

		# Will build a bundled libsqlite3.so.
		--enable-build-sqlite=no
	)

	econf "${myeconfargs[@]}"
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die
}
