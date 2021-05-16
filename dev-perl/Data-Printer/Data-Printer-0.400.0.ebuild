# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=GARU
DIST_VERSION=0.40
DIST_EXAMPLES=(
	"examples/*"
)
inherit perl-module

DESCRIPTION="Colored pretty-print of Perl data structures and objects"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	virtual/perl-Carp
	dev-perl/Clone-PP
	>=dev-perl/File-HomeDir-0.910.0
	virtual/perl-File-Spec
	>=dev-perl/Package-Stash-0.300.0
	virtual/perl-Scalar-List-Utils
	dev-perl/Sort-Naturally
	>=virtual/perl-Term-ANSIColor-3
	>=virtual/perl-version-0.770.0
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-File-Temp
		>=virtual/perl-Test-Simple-0.880.0
	)
"
