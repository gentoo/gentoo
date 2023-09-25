# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=RJBS
DIST_VERSION=0.335
inherit perl-module

DESCRIPTION="Write command line apps with less suffering"

SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE="minimal"

RDEPEND="
	>=dev-perl/Capture-Tiny-0.130.0
	virtual/perl-Carp
	>=dev-perl/Class-Load-0.60.0
	dev-perl/Data-OptList
	>=virtual/perl-Getopt-Long-2.390.0
	>=dev-perl/Getopt-Long-Descriptive-0.84.0
	dev-perl/IO-TieCombine
	dev-perl/Module-Pluggable
	dev-perl/String-RewritePrefix
	dev-perl/Sub-Exporter
	dev-perl/Sub-Install
	virtual/perl-parent
"
BDEPEND="
	${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		!minimal? (
			>=virtual/perl-CPAN-Meta-2.120.900
		)
		virtual/perl-Data-Dumper
		virtual/perl-File-Spec
		virtual/perl-IPC-Cmd
		dev-perl/Test-Fatal
		>=virtual/perl-Test-Simple-0.960.0
	)
"
