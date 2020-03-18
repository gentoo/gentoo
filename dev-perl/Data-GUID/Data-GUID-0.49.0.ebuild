# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=RJBS
DIST_VERSION=0.049
inherit perl-module

DESCRIPTION="Simple interface for generating and using globally unique identifiers"

SLOT="0"
KEYWORDS="amd64"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	virtual/perl-Carp
	>=dev-perl/Data-UUID-1.148.0
	>=dev-perl/Sub-Exporter-0.900.0
	>=dev-perl/Sub-Install-0.30.0
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-File-Spec
		>=virtual/perl-Test-Simple-0.960.0
	)
"
