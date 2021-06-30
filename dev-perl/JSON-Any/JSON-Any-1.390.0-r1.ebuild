# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=ETHER
DIST_VERSION=1.39
inherit perl-module

DESCRIPTION="Wrapper Class for the various JSON classes (DEPRECATED)"

SLOT="0"
KEYWORDS="~amd64 ~mips ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-solaris"

RDEPEND="
	virtual/perl-Carp
	|| (
		>=dev-perl/JSON-XS-2.3
		virtual/perl-JSON-PP
		dev-perl/JSON
	)
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-Data-Dumper
		virtual/perl-File-Spec
		virtual/perl-Storable
		dev-perl/Test-Fatal
		virtual/perl-Test-Simple
		dev-perl/Test-Requires
		>=dev-perl/Test-Warnings-0.9.0
		dev-perl/Test-Without-Module
	)
"
