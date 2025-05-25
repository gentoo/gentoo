# Copyright 2020-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Embeddable, replicated and fault tolerant SQL engine (fork of dqlite)"
HOMEPAGE="https://cowsql.dev/ https://github.com/cowsql/cowsql"
SRC_URI="https://github.com/cowsql/cowsql/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-3-with-linking-exception"
SLOT="0"
KEYWORDS="amd64 ~arm64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="dev-db/sqlite:3
	=dev-libs/libuv-1.50*:=
	>=dev-libs/raft-0.18.1:="
DEPEND="${RDEPEND}
	test? ( dev-libs/raft[lz4,test] )"
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

src_test() {
	default
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die
}
