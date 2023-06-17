# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=OALDERS
DIST_VERSION=2.06
inherit perl-module

DESCRIPTION="Handy web browsing in a Perl object"

SLOT="0"
KEYWORDS="amd64 ~arm ppc ~riscv x86 ~amd64-linux ~x86-linux"

RDEPEND="
	virtual/perl-Carp
	virtual/perl-Getopt-Long
	>=dev-perl/HTML-Form-1.0.0
	dev-perl/HTML-Parser
	>=dev-perl/HTML-Tree-5
	dev-perl/HTTP-Cookies
	>=dev-perl/HTTP-Message-1.300.0
	>=dev-perl/libwww-perl-6.450.0
	>=virtual/perl-Scalar-List-Utils-1.140.0
	virtual/perl-Tie-RefHash
	dev-perl/URI
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		>=dev-perl/CGI-4.320.0
		virtual/perl-Exporter
		virtual/perl-File-Spec
		virtual/perl-File-Temp
		>=dev-perl/HTTP-Daemon-6.120.0
		dev-perl/HTTP-Server-Simple
		dev-perl/Path-Tiny
		dev-perl/Test-Deep
		dev-perl/Test-Exception
		dev-perl/Test-Fatal
		>=dev-perl/Test-Memory-Cycle-1.60.0
		dev-perl/Test-Output
		>=dev-perl/Test-Taint-1.80.0
		>=virtual/perl-Test-Simple-0.960.0
		>=dev-perl/Test-NoWarnings-1.40.0
		dev-perl/Test-Warn
		dev-perl/Test-Warnings
	)
"
