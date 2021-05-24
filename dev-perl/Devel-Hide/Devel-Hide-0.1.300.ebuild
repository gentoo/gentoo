# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=DCANTRELL
DIST_VERSION=0.0013
inherit perl-module

DESCRIPTION="Forces the unavailability of specified Perl modules (for testing)"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc x86 ~amd64-linux ~x86-linux ~x64-macos"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	virtual/perl-File-Temp
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-Test-Simple
	)
"
PERL_RM_FILES=(
	t/090pod.t
	t/098pod-coverage.t
)
