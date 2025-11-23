# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=DOY
DIST_VERSION=0.07
inherit perl-module

DESCRIPTION="Refresh your classes during runtime"

SLOT="0"
KEYWORDS="~amd64"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	virtual/perl-Carp
	dev-perl/Class-Load
	dev-perl/Class-Unload
	dev-perl/Devel-OverrideGlobalRequire
	dev-perl/Try-Tiny
"
BDEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.300.0
	test? (
		virtual/perl-Exporter
		virtual/perl-File-Spec
		virtual/perl-File-Temp
		dev-perl/Test-Fatal
		>=virtual/perl-Test-Simple-0.880.0
		dev-perl/Test-Requires
	)
"
