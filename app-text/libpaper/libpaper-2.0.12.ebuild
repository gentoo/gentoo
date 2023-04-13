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
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~x64-cygwin ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"

src_configure() {
	econf --enable-relocatable
}

src_install() {
	default

	find "${ED}" -type f -name '*.la' -delete || die
}
