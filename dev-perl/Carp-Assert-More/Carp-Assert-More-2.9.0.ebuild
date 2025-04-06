# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=PETDANCE
inherit perl-module

DESCRIPTION="Convenience assertions for common situations"

LICENSE="Artistic-2"
SLOT="0"
KEYWORDS="amd64 ~ppc sparc x86 ~amd64-linux ~x86-linux ~ppc-macos"

BDEPEND="
	>=virtual/perl-ExtUtils-MakeMaker-6.640.0
	test? (
		dev-perl/Test-Exception
		>=virtual/perl-Test-Simple-0.720.0
	)
"

PERL_RM_FILES=(
	"t/pod-coverage.t"
	"t/pod.t"
)
