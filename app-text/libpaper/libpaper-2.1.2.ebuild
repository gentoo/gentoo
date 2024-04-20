# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Library for handling paper characteristics"
HOMEPAGE="https://github.com/rrthomas/libpaper"
SRC_URI="https://github.com/rrthomas/libpaper/releases/download/v${PV}/${P}.tar.gz"

# See README.
# paperspecs is public-domain
LICENSE="LGPL-2.1+ GPL-3+ public-domain"
SLOT="0/$(ver_cut 1)"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~arm64-macos ~ppc-macos ~x64-macos ~x64-solaris"

QA_CONFIG_IMPL_DECL_SKIP=(
	# Gnulib false positives #898346
	# These are all tested without an #include first
	MIN alignof static_assert
)

src_configure() {
	econf --enable-relocatable
}

src_install() {
	default

	find "${ED}" -type f -name '*.la' -delete || die
}
