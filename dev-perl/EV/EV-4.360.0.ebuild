# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=MLEHMANN
DIST_VERSION=4.36
inherit flag-o-matic perl-module

DESCRIPTION="Perl interface to libev, a high performance full-featured event loop"

LICENSE=" || ( Artistic GPL-1+ ) || ( BSD-2 GPL-2+ )"
SLOT="0"
# 4.360.0 segfaults for sam in tests, while 4.340.0 seems OK, so unkeyworded
# for now.
#KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~riscv ~x86"

RDEPEND="
	dev-perl/common-sense
"
BDEPEND="
	${RDEPEND}
	dev-perl/Canary-Stability
"

src_compile() {
	# See bug #855869 and its large number of dupes in bundled libev copies.
	filter-lto
	append-flags -fno-strict-aliasing

	perl-module_src_compile
}
