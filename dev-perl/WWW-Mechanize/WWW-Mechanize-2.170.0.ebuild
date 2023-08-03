# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=SIMBABQUE
DIST_VERSION=2.17
inherit perl-module

DESCRIPTION="Handy web browsing in a Perl object"

SLOT="0"
KEYWORDS="amd64 ~arm ~ppc ~riscv x86 ~amd64-linux ~x86-linux"

RDEPEND="
	virtual/perl-Carp
	virtual/perl-Getopt-Long
	>=dev-perl/HTML-Form-6.80.0
	dev-perl/HTML-Parser
	>=dev-perl/HTML-Tree-5
	dev-perl/HTTP-Cookies
	>=dev-perl/HTTP-Message-1.300.0
	>=dev-perl/libwww-perl-6.450.0
	>=virtual/perl-Scalar-List-Utils-1.140.0
	virtual/perl-Tie-RefHash
	dev-perl/URI
"
# dev-perl/Test-Taint is missing from reqs but still needed, see bug #908748
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-File-Spec
		virtual/perl-File-Temp
		>=dev-perl/HTTP-Daemon-6.120.0
		dev-perl/Path-Tiny
		dev-perl/Test-Deep
		dev-perl/Test-Fatal
		dev-perl/Test-Memory-Cycle
		dev-perl/Test-Output
		>=virtual/perl-Test-Simple-0.960.0
		dev-perl/Test-Taint
		dev-perl/Test-Warnings
	)
"
