# Copyright 2020-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="Embeddable, replicated and fault tolerant SQL engine"
HOMEPAGE="https://dqlite.io/ https://github.com/canonical/dqlite"
SRC_URI="https://github.com/canonical/dqlite/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-3-with-linking-exception"
SLOT="0"
KEYWORDS="~amd64 ~arm64"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="dev-db/sqlite:3
	dev-libs/libuv
	dev-libs/raft"
DEPEND="${RDEPEND}
	test? ( >=dev-libs/raft-0.11.1[lz4,test] )"

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	local myeconfargs=(
		--disable-debug
		--disable-sanitize
		--disable-static
	)

	econf "${myeconfargs[@]}"
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die
}
