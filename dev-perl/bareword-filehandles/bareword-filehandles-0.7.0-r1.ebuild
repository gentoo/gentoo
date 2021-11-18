# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=ILMARI
DIST_VERSION=0.007
inherit perl-module

DESCRIPTION="Disables bareword filehandles"

SLOT="0"
KEYWORDS="~alpha amd64 ~arm arm64 ~hppa ~ia64 ~mips ppc ppc64 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="test"
RESTRICT="!test? ( test )"

# Lexical::SealRequireHints only required with Perl < 5.12
# We could add alternation here, but it would be work without benefit
# which would complicate stabilization
RDEPEND="
	dev-perl/B-Hooks-OP-Check
	virtual/perl-if
	virtual/perl-XSLoader
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	dev-perl/ExtUtils-Depends
	test? ( >=virtual/perl-Test-Simple-0.880.0 )
"
src_compile() {
	mymake=(
		"OPTIMIZE=${CFLAGS}"
	)
	perl-module_src_compile
}
