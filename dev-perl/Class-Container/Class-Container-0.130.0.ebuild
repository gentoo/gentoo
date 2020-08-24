# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=KWILLIAMS
DIST_VERSION=0.13
inherit perl-module

DESCRIPTION="Glue object frameworks together transparently"

SLOT="0"
KEYWORDS="~alpha amd64 ~ia64 ~ppc sparc x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	virtual/perl-Carp
	>=dev-perl/Params-Validate-0.24-r1
	virtual/perl-Scalar-List-Utils
"
DEPEND="
	dev-perl/Module-Build
"
BDEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.300.0
	>=dev-perl/Module-Build-0.360.100
	test? (
		virtual/perl-File-Spec
		virtual/perl-Test
	)
"
PERL_RM_FILES=(
	"t/author-critic.t"
)
