# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=DROLSKY
DIST_VERSION=2.63
inherit perl-module

DESCRIPTION="Dispatches messages to one or more outputs"

LICENSE="Artistic-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~ppc-aix"
IUSE="test"
RESTRICT="!test? ( test )"

PERL_RM_FILES=(
	"t/email-exit.t"
)
RDEPEND="
	virtual/perl-Carp
	dev-perl/Devel-GlobalDestruction
	>=dev-perl/Dist-CheckConflicts-0.20.0
	virtual/perl-Encode
	virtual/perl-Exporter
	virtual/perl-IO
	dev-perl/Module-Runtime
	dev-perl/Params-ValidationCompiler
	virtual/perl-Scalar-List-Utils
	>=dev-perl/Specio-0.320.0
	>=virtual/perl-Sys-Syslog-0.280.0
	dev-perl/Try-Tiny
	dev-perl/namespace-autoclean
	virtual/perl-parent
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-Data-Dumper
		virtual/perl-File-Spec
		virtual/perl-File-Temp
		virtual/perl-Getopt-Long
		dev-perl/IPC-Run3
		dev-perl/Test-Fatal
		dev-perl/Test-Needs
		>=virtual/perl-Test-Simple-0.960.0
	)
"
