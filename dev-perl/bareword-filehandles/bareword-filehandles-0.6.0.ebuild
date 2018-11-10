# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=ILMARI
DIST_VERSION=0.006
inherit perl-module

DESCRIPTION="Disables bareword filehandles"

SLOT="0"
KEYWORDS="~amd64 ~hppa ~ppc ~x86 ~ppc-aix ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="test"

# Lexical::SealRequireHints only required with Perl < 5.12
# We could add alternation here, but it would be work without benefit
# which would complicate stabilization
RDEPEND="
	dev-perl/B-Hooks-OP-Check
	virtual/perl-if
	virtual/perl-XSLoader
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	dev-perl/ExtUtils-Depends
	test? ( >=virtual/perl-Test-Simple-0.880.0 )
"
