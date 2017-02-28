# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=RJBS
DIST_VERSION=0.099
inherit perl-module

DESCRIPTION="Getopt::Long with usage text"

SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~x86 ~ppc-aix ~ppc-macos ~x86-solaris"
IUSE="test minimal"

# File::Basename -> perl
# List::Util, Scalar::Util -> perl-Scalar-List-Utils
# Sub::Exporter::Util -> Sub-Exporter
RDEPEND="
	virtual/perl-Carp
	>=virtual/perl-Getopt-Long-2.330.0
	>=dev-perl/Params-Validate-0.970.0
	>=dev-perl/Sub-Exporter-0.972.0
	virtual/perl-Scalar-List-Utils
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		!minimal? ( >=virtual/perl-CPAN-Meta-2.120.900 )
		dev-perl/Test-Fatal
		>=dev-perl/Test-Warnings-0.5.0
		virtual/perl-File-Spec
		>=virtual/perl-Test-Simple-0.960.0
	)
"
