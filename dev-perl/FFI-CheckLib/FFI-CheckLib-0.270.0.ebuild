# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=PLICEASE
DIST_VERSION=0.27
DIST_EXAMPLES=("example/*")
inherit perl-module

DESCRIPTION="Check that a library is available for FFI"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~x64-macos"
IUSE="test"
RESTRICT="!test? ( test )"

BDEPEND="
	virtual/perl-ExtUtils-MakeMaker
	test? (
		>=virtual/perl-Test-Simple-1.302.15
		>=dev-perl/Test2-Suite-0.0.60
	)
"
PERL_RM_FILES=(
	"t/ci.t"
)
