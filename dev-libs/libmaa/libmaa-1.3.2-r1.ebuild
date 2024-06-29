# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="Library with low-level data structures which are helpful for writing compilers"
HOMEPAGE="https://dict.org/"
SRC_URI="https://downloads.sourceforge.net/dict/${P}.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ppc ppc64 ~riscv sparc x86 ~amd64-linux ~x86-linux"

PATCHES=(
	"${FILESDIR}"/${P}-libtool.patch # 778464
)

src_prepare() {
	default

	eautoreconf
}

src_install() {
	default
	dodoc doc/libmaa.600dpi.ps

	# don't want static or libtool archives, #401935
	find "${D}" \( -name '*.a' -o -name '*.la' \) -delete || die
}
