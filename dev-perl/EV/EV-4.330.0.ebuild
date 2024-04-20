# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=MLEHMANN
DIST_VERSION=4.33
inherit flag-o-matic perl-module

DESCRIPTION="Perl interface to libev, a high performance full-featured event loop"
LICENSE=" || ( Artistic GPL-1+ ) || ( BSD-2 GPL-2+ )"
SLOT="0"
KEYWORDS="amd64 ~arm ppc ppc64 ~riscv x86"
IUSE=""

RDEPEND="
	dev-perl/common-sense
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	dev-perl/Canary-Stability
"
src_compile() {
	# See bug #855869 and its large number of dupes in bundled libev copies.
	filter-lto
	append-flags -fno-strict-aliasing

	mymake=(
		"OPTIMIZE=${CFLAGS}"
	)
	perl-module_src_compile
}
