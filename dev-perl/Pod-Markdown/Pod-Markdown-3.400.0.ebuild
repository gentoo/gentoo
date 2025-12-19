# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=RWSTAUNER
DIST_VERSION=3.400
inherit perl-module

DESCRIPTION="Convert POD to Markdown"

SLOT="0"
KEYWORDS="amd64 ~riscv x86 ~x64-macos ~x64-solaris"
IUSE="minimal"

RDEPEND="
	!minimal? (
		dev-perl/HTML-Parser
	)
	virtual/perl-Encode
	virtual/perl-Getopt-Long
	>=virtual/perl-Pod-Simple-3.270.0
	dev-perl/URI
	virtual/perl-parent
"
BDEPEND="
	${RDEPEND}
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
