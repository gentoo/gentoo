# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=MANWAR
DIST_VERSION=1.42
DIST_EXAMPLES=("examples/*")
inherit perl-module

DESCRIPTION="A XPath Perl Module"

SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ia64 ~mips ~ppc ~ppc64 sparc x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x86-solaris"
IUSE="test"

RDEPEND=">=dev-perl/XML-Parser-2.230.0"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		>=dev-perl/Path-Tiny-0.76.0
		virtual/perl-Test-Simple
	)
"
src_test() {
	perl_rm_files t/meta-json.t t/meta-yml.t
	perl-module_src_test
}
