# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=DROLSKY
DIST_VERSION=2.54
inherit perl-module

DESCRIPTION="Dispatches messages to one or more outputs"

LICENSE="Artistic-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86 ~ppc-aix"
IUSE="test"

PERL_RM_FILES=(
	"t/email-exit.t"
	"t/release-cpan-changes.t"
	"t/release-portability.t"
	"t/release-pod-coverage.t"
	"t/release-tidyall.t"
	"t/author-eol.t"
	"t/author-mojibake.t"
	"t/author-no-tabs.t"
	"t/author-pod-spell.t"
	"t/author-pod-syntax.t"
	"t/author-test-dependents.t"
	"t/author-test-version.t"
)
RDEPEND="
	virtual/perl-Carp
	dev-perl/Devel-GlobalDestruction
	>=dev-perl/Dist-CheckConflicts-0.20.0
	virtual/perl-Encode
	dev-perl/Module-Runtime
	virtual/perl-IO
	>=virtual/perl-JSON-PP-2.273.0
	>=dev-perl/Params-Validate-1.30.0
	virtual/perl-Scalar-List-Utils
	>=virtual/perl-Sys-Syslog-0.280.0
"
DEPEND="${RDEPEND}
	>=dev-perl/Dist-CheckConflicts-0.20.0
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-Data-Dumper
		virtual/perl-Exporter
		virtual/perl-File-Spec
		virtual/perl-File-Temp
		virtual/perl-Getopt-Long
		dev-perl/IPC-Run3
		virtual/perl-IO
		dev-perl/Test-Fatal
		>=virtual/perl-Test-Simple-0.960.0
		dev-perl/Test-Requires
	)
"
