# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=EXODIST
DIST_VERSION=0.016
inherit perl-module optfeature

DESCRIPTION="Format a header and rows into a table"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	virtual/perl-Carp
	>=dev-perl/Importer-0.24.0
	virtual/perl-Scalar-List-Utils
"
DEPEND="
	${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		>=virtual/perl-Test-Simple-1.302.97
	)
"
pkg_postinst() {
	# optfeature "Improved Automatic detection of terminal width" Term::Size::Any
	optfeature "Improved rendering of UTF8 Characters" '>=dev-perl/Unicode-LineBreak-2013.100.0'
	optfeature "Automatic detection of terminal width" 'dev-perl/TermReadKey'
}
