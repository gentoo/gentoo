# Copyright 2020-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="C implementation of the Raft consensus protocol"
HOMEPAGE="https://github.com/canonical/raft"
SRC_URI="https://github.com/canonical/raft/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-3-with-linking-exception"
SLOT="0"
KEYWORDS="~amd64 ~arm64"
IUSE="test zfs"
RESTRICT="!test? ( test )"

DEPEND="dev-libs/libuv"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/raft-0.9.25-Always-skip-init-oom-test.patch
	"${FILESDIR}"/raft-0.10.0-toggle-zfs.patch
	)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	local myeconfargs=(
		--enable-uv

		--disable-benchmark
		--disable-debug
		--disable-example
		--disable-sanitize
		--disable-static

		$(use_enable test fixture)

		$(use_with zfs)
	)

	econf "${myeconfargs[@]}"
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die
}
