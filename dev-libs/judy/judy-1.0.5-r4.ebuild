# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="A C library that implements a dynamic array"
HOMEPAGE="https://judy.sourceforge.net/"
SRC_URI="https://downloads.sourceforge.net/judy/Judy-${PV}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ~mips ppc ppc64 ~riscv ~s390 sparc x86"

src_prepare() {
	eapply -p0 "${FILESDIR}/${P}-parallel-make.patch"
	eapply "${FILESDIR}/${P}-gcc49.patch"
	sed -i 's/AM_CONFIG_HEADER/AC_CONFIG_HEADERS/g' configure.ac || die
	eapply_user
	eautoreconf
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die
}
