# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=MINIMAL
DIST_VERSION=0.04
inherit perl-module

DESCRIPTION="Convert POD to Github's specific markdown"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	virtual/perl-Getopt-Long
	dev-perl/Pod-Markdown
	virtual/perl-parent
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-Exporter
		virtual/perl-File-Spec
		virtual/perl-File-Temp
		dev-perl/Test-Differences
		>=virtual/perl-Test-Simple-0.880.0
	)
"
