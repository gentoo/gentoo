# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic

DESCRIPTION="Console based chess interface"
HOMEPAGE="https://www.gnu.org/software/chess/chess.html"
SRC_URI="mirror://gnu/chess/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ppc64 ~riscv x86"

src_configure() {
	# -Wodr warnings, bug #858611
	filter-lto

	# bug #491088
	econf --without-readline
}
