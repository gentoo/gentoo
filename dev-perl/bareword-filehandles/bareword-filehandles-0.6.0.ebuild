# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=ILMARI
DIST_VERSION=0.006
inherit perl-module

DESCRIPTION="Disables bareword filehandles"

SLOT="0"
KEYWORDS="~amd64 ~hppa ~ppc ~x86"
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
