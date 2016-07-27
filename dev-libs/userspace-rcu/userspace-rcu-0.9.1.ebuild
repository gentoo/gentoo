# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit autotools-utils

DESCRIPTION="userspace RCU (read-copy-update) library"
HOMEPAGE="http://lttng.org/urcu"
SRC_URI="http://lttng.org/files/urcu/${P}.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="0/4" # subslot = soname version
KEYWORDS="amd64 arm hppa ~ppc ppc64 x86"
IUSE="static-libs regression-test test"

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
