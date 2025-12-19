# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=TOBYINK
DIST_VERSION=0.002011
inherit perl-module

DESCRIPTION="Base classes wrapping fundamental Perl data types"

SLOT="0"
KEYWORDS="amd64 ~arm ~hppa ppc ~riscv x86 ~x64-macos"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-perl/Class-Method-Modifiers
	dev-perl/List-MoreUtils
	dev-perl/Module-Runtime
	dev-perl/Role-Tiny
	virtual/perl-Scalar-List-Utils
	virtual/perl-parent
	dev-perl/strictures
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		dev-perl/Test-Deep
		dev-perl/Test-Fatal
		dev-perl/Test-Output
	)
"
PERL_RM_FILES=(
	"t/author-pod-coverage.t"
	"t/author-pod-syntax.t"
)
