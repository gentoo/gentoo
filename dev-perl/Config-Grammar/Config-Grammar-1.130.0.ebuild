# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=DSCHWEI
DIST_VERSION=1.13
inherit perl-module

DESCRIPTION="A grammar-based, user-friendly config parser"

SLOT="0"
KEYWORDS="amd64 ~hppa ~sparc x86"
IUSE="test"
RESTRICT="!test? ( test )"

BDEPEND="virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-Test
		virtual/perl-Test-Simple
	)
"
PERL_RM_FILES=(
	"lib/Config/Grammar.pm~"
)
