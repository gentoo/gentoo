# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=MIYAGAWA
DIST_VERSION=0.15
inherit perl-module

DESCRIPTION="Mixin to add / call inheritable triggers"

SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~mips ppc ppc64 x86 ~amd64-linux ~x86-linux ~ppc-macos ~sparc-solaris ~x86-solaris"
IUSE="test"
RESTRICT="!test? ( test )"

BDEPEND="
	>=virtual/perl-ExtUtils-MakeMaker-6.590.0
	test? (
		dev-perl/IO-stringy
		>=virtual/perl-Test-Simple-0.320.0
	)
"
PERL_RM_FILES=(
	t/author-pod-syntax.t
)
