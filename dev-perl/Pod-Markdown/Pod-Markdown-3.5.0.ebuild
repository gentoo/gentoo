# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=RWSTAUNER
DIST_VERSION=3.005
inherit perl-module

DESCRIPTION="Convert POD to Markdown"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="test minimal"

RDEPEND="
	!minimal? (
		dev-perl/HTML-Parser
	)
	virtual/perl-Encode
	virtual/perl-Getopt-Long
	>=virtual/perl-Pod-Simple-3.270.0
	virtual/perl-parent
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		!minimal? (
			>=virtual/perl-CPAN-Meta-2.120.900
		)
		virtual/perl-Exporter
		virtual/perl-File-Spec
		virtual/perl-File-Temp
		virtual/perl-IO
		dev-perl/Test-Differences
		>=virtual/perl-Test-Simple-0.880.0
	)
"
