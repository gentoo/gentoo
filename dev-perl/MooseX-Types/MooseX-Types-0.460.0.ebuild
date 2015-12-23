# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DIST_AUTHOR=ETHER
DIST_VERSION=0.46
inherit perl-module

DESCRIPTION="Organise your Moose types in libraries"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="
	virtual/perl-Carp
	>=dev-perl/Carp-Clan-6
	virtual/perl-Exporter
	dev-perl/Module-Runtime
	>=dev-perl/Moose-1.06
	virtual/perl-Scalar-List-Utils
	>=dev-perl/Sub-Exporter-ForMethods-0.100.52
	dev-perl/Sub-Name
	>=dev-perl/namespace-autoclean-0.160.0
"
DEPEND="${RDEPEND}
	>=dev-perl/Module-Build-Tiny-0.7.0
	test? (
		virtual/perl-ExtUtils-MakeMaker
		virtual/perl-File-Spec
		dev-perl/Test-Fatal
		>=virtual/perl-Test-Simple-0.880.0
		dev-perl/Test-Requires
		dev-perl/Test-CheckDeps
		virtual/perl-if
	)
"
