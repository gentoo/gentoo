# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=ETHER
DIST_VERSION=1.73
inherit perl-module

DESCRIPTION="Read/Write YAML files with as little code as possible"

SLOT="0"
KEYWORDS="~amd64 ~arm ~m68k ~mips ~ppc ~s390 ~sh ~x86 ~ppc-aix ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="test minimal"

RDEPEND="
	virtual/perl-Carp
	virtual/perl-Exporter
	virtual/perl-Scalar-List-Utils
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		!minimal? (
			>=virtual/perl-CPAN-Meta-2.120.900
			>=dev-perl/JSON-MaybeXS-1.1.0
		)
		>=virtual/perl-File-Spec-0.80.0
		>=virtual/perl-File-Temp-0.190.0
		virtual/perl-Getopt-Long
		virtual/perl-IO
		virtual/perl-JSON-PP
		>=virtual/perl-Test-Simple-0.880.0
	)
"
