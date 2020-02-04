# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=MAXMIND
DIST_VERSION=0.040001
inherit perl-module

DESCRIPTION="Code shared by the MaxMind DB reader and writer modules"
LICENSE="Artistic-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="
	virtual/perl-Carp
	dev-perl/Data-Dumper-Concise
	dev-perl/DateTime
	virtual/perl-Exporter
	dev-perl/List-AllUtils
	virtual/perl-Math-BigInt
	dev-perl/Moo
	dev-perl/MooX-StrictConstructor
	virtual/perl-Scalar-List-Utils
	dev-perl/Sub-Quote
	virtual/perl-autodie
	dev-perl/namespace-autoclean
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-File-Spec
		>=virtual/perl-Test-Simple-0.960.0
	)
"
PERL_RM_FILES=(
	"t/author-00-compile.t"
	"t/author-eol.t"
	"t/author-no-tabs.t"
	"t/author-pod-spell.t"
	"t/author-pod-syntax.t"
	"t/author-test-version.t"
	"t/release-cpan-changes.t"
	"t/release-portability.t"
	"t/release-synopsis.t"
	"t/release-tidyall.t"
)
