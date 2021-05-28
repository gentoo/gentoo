# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=ETJ
DIST_VERSION=1.27
inherit perl-module

DESCRIPTION="Fast, generic event loop"

SLOT="0"
KEYWORDS="~alpha ~amd64 arm ~ia64 ppc ~ppc64 sparc ~x86 ~x86-solaris"
IUSE="test"
RESTRICT="!test? ( test )"

BDEPEND="
	virtual/perl-ExtUtils-MakeMaker
	test? (
		>=virtual/perl-Test-1.0.0
	)
"
src_compile() {
	mymake=(
		"OPTIMIZE=${CFLAGS}"
	)
	perl-module_src_compile
}
mydoc="ANNOUNCE INSTALL TODO Tutorial.pdf Tutorial.pdf-errata.txt"
