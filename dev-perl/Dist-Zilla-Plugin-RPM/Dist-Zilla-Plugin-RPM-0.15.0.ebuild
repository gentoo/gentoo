# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=SKYSYMBOL
DIST_VERSION=0.015
inherit perl-module

DESCRIPTION="Build an RPM from your Dist::Zilla release"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="
	virtual/perl-Carp
	dev-perl/Dist-Zilla
	virtual/perl-File-Temp
	dev-perl/IPC-Run
	dev-perl/Moose
	dev-perl/Moose-Autobox
	dev-perl/Path-Class
	dev-perl/Path-Tiny
	dev-perl/Text-Template
	dev-perl/namespace-autoclean
	app-arch/rpm
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		dev-perl/File-Which
		dev-perl/Test-Differences
		>=virtual/perl-Test-Simple-0.880.0
	)
"
