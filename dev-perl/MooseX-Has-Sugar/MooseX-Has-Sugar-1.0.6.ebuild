# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=KENTNL
DIST_VERSION=1.000006
inherit perl-module

DESCRIPTION="Sugar Syntax for moose 'has' fields"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	virtual/perl-Carp
	dev-perl/Sub-Exporter-Progressive
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-File-Spec
		dev-perl/Test-Fatal
		virtual/perl-Test-Simple
		dev-perl/namespace-clean
	)
"
