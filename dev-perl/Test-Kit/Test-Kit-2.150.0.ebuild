# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=KAORU
DIST_VERSION=2.15
inherit perl-module

DESCRIPTION="Build custom test packages with only the features you want"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"
RDEPEND="
	virtual/perl-Exporter
	dev-perl/Hook-LexWrap
	dev-perl/Import-Into
	dev-perl/Module-Runtime
	virtual/perl-Scalar-List-Utils
	dev-perl/Sub-Delete
	virtual/perl-Test-Simple
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		dev-perl/Test-Exception
		dev-perl/Test-NoWarnings
		dev-perl/Test-Output
		>=virtual/perl-Test-Simple-0.920.0
		dev-perl/Test-Warn
	)
"
PERL_RM_FILES=(
	"t/author-pod-syntax.t"
	"t/release-cpan-changes.t"
)
