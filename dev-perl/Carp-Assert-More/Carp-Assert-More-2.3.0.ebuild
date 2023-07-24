# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=PETDANCE
inherit perl-module

DESCRIPTION="Convenience assertions for common situations"

LICENSE="Artistic-2"
SLOT="0"
KEYWORDS="~amd64 ~ia64 ~ppc ~sparc x86 ~amd64-linux ~x86-linux ~ppc-macos"

RDEPEND="
	virtual/perl-Carp
	virtual/perl-Scalar-List-Utils
"
BDEPEND="
	${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		dev-perl/Test-Exception
		>=virtual/perl-Test-Simple-0.180.0
	)
"

PERL_RM_FILES=(
	"t/pod-coverage.t"
	"t/pod.t"
)
