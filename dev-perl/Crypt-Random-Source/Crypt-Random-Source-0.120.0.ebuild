# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=ETHER
DIST_VERSION=0.12
inherit perl-module

DESCRIPTION="Get weak or strong random data from pluggable sources"

SLOT="0"
KEYWORDS="amd64 x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-perl/Capture-Tiny-0.80.0
	virtual/perl-Carp
	virtual/perl-File-Spec
	>=virtual/perl-IO-1.140.0
	dev-perl/Module-Find
	dev-perl/Module-Runtime
	>=dev-perl/Moo-1.2.0
	dev-perl/Sub-Exporter
	dev-perl/Type-Tiny
	>=dev-perl/namespace-clean-0.110.0
"
DEPEND="${RDEPEND}
	>=dev-perl/Module-Build-Tiny-0.34.0
	test? (
		virtual/perl-ExtUtils-MakeMaker
		dev-perl/Test-Exception
		>=virtual/perl-Test-Simple-1.1.10
	)
"
