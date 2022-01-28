# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="userspace RCU (read-copy-update) library"
HOMEPAGE="https://liburcu.org/"
SRC_URI="https://lttng.org/files/urcu/${P}.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="0/8" # subslot = soname version
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~mips ppc ppc64 ~riscv sparc x86"
IUSE="static-libs regression-test test"
RESTRICT="!test? ( test )"

DEPEND="test? ( sys-process/time )"

src_prepare() {
	default

	# Refresh libtool (see https://github.com/gentoo/gentoo/pull/23973)
	eautoreconf
}

src_configure() {
	local myeconfargs=(
		--enable-shared
		$(use_enable static-libs static)
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	default
	find "${ED}" -type f -name "*.la" -delete || die
}

src_test() {
	default
	if use regression-test ; then
		emake -C tests/regression regtest
	fi
}
