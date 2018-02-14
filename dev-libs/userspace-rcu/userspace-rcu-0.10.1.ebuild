# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="userspace RCU (read-copy-update) library"
HOMEPAGE="http://lttng.org/urcu"
SRC_URI="http://lttng.org/files/urcu/${P}.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="0/6" # subslot = soname version
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~x86"
IUSE="static-libs regression-test test"

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
