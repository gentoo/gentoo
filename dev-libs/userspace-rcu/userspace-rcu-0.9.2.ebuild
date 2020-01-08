# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit autotools-utils

DESCRIPTION="userspace RCU (read-copy-update) library"
HOMEPAGE="https://liburcu.org/"
SRC_URI="https://lttng.org/files/urcu/${P}.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="0/4" # subslot = soname version
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~x86"
IUSE="static-libs regression-test test"
RESTRICT="!test? ( test )"

DEPEND="test? ( sys-process/time )"

# tests fail with separate build dir
AUTOTOOLS_IN_SOURCE_BUILD=1

src_configure() {
	local myeconfargs=(
		--docdir="${EPREFIX}/usr/share/doc/${PF}"
	)
	autotools-utils_src_configure
}

src_test() {
	default
	if use regression-test; then
		emake -C tests/regression regtest
	fi
}
