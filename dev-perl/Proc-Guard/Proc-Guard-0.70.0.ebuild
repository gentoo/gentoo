# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DIST_AUTHOR=TOKUHIROM
DIST_VERSION=0.07
inherit perl-module

DESCRIPTION="process runner with RAII pattern"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="
	>=dev-perl/Class-Accessor-Lite-0.50.0
	>=virtual/perl-Exporter-5.630.0
"
DEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.590.0
	>=dev-perl/Module-Build-0.380.0
	test? (
		dev-perl/File-Which
		dev-perl/Test-TCP
		dev-perl/Test-Requires
		dev-perl/Test-SharedFork
		>=virtual/perl-Test-Simple-0.940.0
	)
"
