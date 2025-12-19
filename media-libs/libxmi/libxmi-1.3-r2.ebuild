# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="C/C++ function library for rasterizing 2-D vector graphics"
HOMEPAGE="https://www.gnu.org/software/libxmi/"
SRC_URI="https://dev.gentoo.org/~jlec/distfiles/${P}.tar.xz"
#mirror://gnu/${PN}/${P}.tar.gz"
# Version unbundled from plotutils

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ppc ppc64 ~riscv ~s390 ~sparc x86"

PATCHES=(
	"${FILESDIR}/${P}-gcc15.patch"
	"${FILESDIR}/${P}-implicit.patch"
)

src_prepare() {
	default
	mv configure.in configure.ac || die
	eautoreconf
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die
}
