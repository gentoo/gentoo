# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="C implementation of the Raft consensus protocol"
HOMEPAGE="https://github.com/canonical/raft"
SRC_URI="https://github.com/canonical/raft/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-3-with-linking-exception"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"
RESTRICT="!test? ( test )"

DEPEND="dev-libs/libuv"
RDEPEND="${DEPEND}"

src_prepare() {
	default

	# ACCESS DENIED issue, #723208
	sed -i 's#zfs version 2>/dev/null | cut -f 2 -d - | head -1#< /sys/module/zfs/version cut -f 1#' configure.ac || die

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
	)

	econf "${myeconfargs[@]}"
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die
}
