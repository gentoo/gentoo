# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Library with low-level data structures which are helpful for writing compilers"
HOMEPAGE="http://www.dict.org/"
SRC_URI="mirror://sourceforge/dict/${P}.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="alpha amd64 ~arm ~arm64 ~hppa ia64 ~mips ppc ppc64 sparc x86 ~amd64-linux ~x86-linux"

src_install() {
	default
	dodoc doc/libmaa.600dpi.ps

	# don't want static or libtool archives, #401935
	find "${D}" \( -name '*.a' -o -name '*.la' \) -delete || die
}
