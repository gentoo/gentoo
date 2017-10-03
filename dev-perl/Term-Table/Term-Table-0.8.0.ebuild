# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=EXODIST
DIST_VERSION=0.008
inherit perl-module eutils

DESCRIPTION="Format a header and rows into a table"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="
	virtual/perl-Carp
	>=dev-perl/Importer-0.24.0
	virtual/perl-Scalar-List-Utils
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		>=virtual/perl-Test-Simple-1.302.72
	)
"
pkg_postinst() {
	# optfeature "Improved Automatic detection of terminal width" Term::Size::Any
	optfeature "Improved rendering of UTF8 Characters" '>=dev-perl/Unicode-LineBreak-2013.100.0'
	optfeature "Automatic detection of terminal width" 'dev-perl/TermReadKey'
}
