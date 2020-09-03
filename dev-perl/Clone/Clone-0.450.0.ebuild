# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=ATOOMIC
DIST_VERSION=0.45
inherit perl-module

DESCRIPTION="Recursively copy Perl datatypes"

SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~riscv ~sparc ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

BDEPEND="
	virtual/perl-ExtUtils-MakeMaker
	test? (
		>=dev-perl/B-COW-0.4.0
		virtual/perl-Test-Simple
	)
"
src_compile() {
	mymake=(
		"OPTIMIZE=${CFLAGS}"
	)
	perl-module_src_compile
}
