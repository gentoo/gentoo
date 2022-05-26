# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=DAGOLDEN
DIST_VERSION=0.028
inherit perl-module

DESCRIPTION="Report on prerequisite versions during automated testing"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	virtual/perl-CPAN-Meta
	virtual/perl-Data-Dumper
	>=dev-perl/Data-Section-0.200.2
	>=dev-perl/Dist-Zilla-4
	dev-perl/Moose
	dev-perl/Sub-Exporter-ForMethods
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		dev-perl/Capture-Tiny
		virtual/perl-File-Spec
		dev-perl/File-pushd
		dev-perl/Path-Tiny
		>=virtual/perl-Test-Simple-0.960.0
	)
"
