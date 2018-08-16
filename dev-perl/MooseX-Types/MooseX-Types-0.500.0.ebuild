# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=ETHER
DIST_VERSION=0.50
DIST_EXAMPLES=("eg/*")
inherit perl-module

DESCRIPTION="Organise your Moose types in libraries"

SLOT="0"
KEYWORDS="amd64 ~hppa ppc x86"
IUSE="test"

RDEPEND="
	virtual/perl-Carp
	>=dev-perl/Carp-Clan-6
	virtual/perl-Exporter
	dev-perl/Module-Runtime
	>=dev-perl/Moose-1.60.0
	>=virtual/perl-Scalar-List-Utils-1.190.0
	dev-perl/Sub-Exporter
	>=dev-perl/Sub-Exporter-ForMethods-0.100.52
	dev-perl/Sub-Install
	dev-perl/Sub-Name
	>=dev-perl/namespace-autoclean-0.160.0
"
DEPEND="${RDEPEND}
	>=dev-perl/Module-Build-Tiny-0.34.0
	test? (
		virtual/perl-File-Spec
		virtual/perl-Module-Metadata
		dev-perl/Test-Fatal
		dev-perl/Test-Requires
		>=virtual/perl-Test-Simple-0.880.0
		virtual/perl-if
	)
"
