# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=DROLSKY
DIST_VERSION=0.05
inherit perl-module

DESCRIPTION="Build a URI from a set of named parameters"
LICENSE="Artistic-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	virtual/perl-Carp
	virtual/perl-Exporter
	dev-perl/Params-Validate
	>=dev-perl/URI-1.680.0
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-File-Spec
		dev-perl/Test-Fatal
		>=virtual/perl-Test-Simple-0.960.0
	)
"
PERL_RM_FILES=(
	"t/author-00-compile.t"
	"t/author-eol.t"
	"t/author-mojibake.t"
	"t/author-no-tabs.t"
	"t/author-pod-spell.t"
	"t/author-test-version.t"
	"t/release-cpan-changes.t"
	"t/release-cpan-changes.t"
	"t/release-pod-coverage.t"
	"t/release-pod-linkcheck.t"
	"t/release-pod-no404s.t"
	"t/release-pod-syntax.t"
	"t/release-portability.t"
	"t/release-synopsis.t"
	"t/release-tidyall.t"
)
