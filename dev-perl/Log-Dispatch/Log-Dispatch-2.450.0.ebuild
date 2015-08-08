# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=DROLSKY
MODULE_VERSION=2.45
inherit perl-module

DESCRIPTION="Dispatches messages to multiple Log::Dispatch::* objects"

LICENSE="Artistic-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~ppc-aix"
IUSE="test"

RDEPEND="
	virtual/perl-Carp
	dev-perl/Devel-GlobalDestruction
	>=dev-perl/Dist-CheckConflicts-0.20.0
	dev-perl/Module-Runtime
	dev-perl/Params-Validate
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
		virtual/perl-IO
		dev-perl/Test-Fatal
		>=virtual/perl-Test-Simple-0.880.0
		dev-perl/Test-Requires
	)
"

SRC_TEST="do parallel"
