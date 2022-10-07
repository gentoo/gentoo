# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Userspace RCU (read-copy-update) library"
HOMEPAGE="https://liburcu.org/"
SRC_URI="https://lttng.org/files/urcu/${P}.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="0/8" # subslot = soname version
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~mips ppc ppc64 ~riscv ~s390 sparc x86"
IUSE="static-libs test"
RESTRICT="!test? ( test )"

BDEPEND="test? ( sys-process/time )"

PATCHES=(
	"${FILESDIR}"/${PN}-0.13.1-tests-no-benchmark.patch
	"${FILESDIR}"/${PN}-0.13.1-loong.patch
)

src_prepare() {
	default

	# Needed for tests patch
	# ... and refresh libtool (see https://github.com/gentoo/gentoo/pull/23973)
	# ... and for build on loong (see https://github.com/gentoo/gentoo/pull/25189)
	eautoreconf
}

src_configure() {
	local myeconfargs=(
		--enable-shared
		$(use_enable static-libs static)
	)

	econf "${myeconfargs[@]}"
}

src_test() {
	default

	emake -C tests/regression regtest
}

src_install() {
	default

	find "${ED}" -type f -name "*.la" -delete || die
}
