# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="userspace RCU (read-copy-update) library"
HOMEPAGE="https://liburcu.org/"
SRC_URI="https://lttng.org/files/urcu/${P}.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="0/6" # subslot = soname version
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ppc ppc64 sparc x86"
IUSE="static-libs regression-test test"
RESTRICT="!test? ( test )"

DEPEND="test? ( sys-process/time )"

src_configure() {
	local myeconfargs=(
		--enable-shared
		$(use_enable static-libs static)
	)
	econf "${myeconfargs[@]}"
}

src_test() {
	default
	if use regression-test; then
		emake -C tests/regression regtest
	fi
}
