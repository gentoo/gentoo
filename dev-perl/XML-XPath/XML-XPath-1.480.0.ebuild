# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=MANWAR
DIST_VERSION=1.48
DIST_EXAMPLES=("examples/*")
inherit perl-module

DESCRIPTION="An XPath Perl Module"

SLOT="0"
KEYWORDS="~alpha amd64 arm ~arm64 ~hppa ~ia64 ~loong ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"

RDEPEND="
	>=virtual/perl-Scalar-List-Utils-1.450.0
	>=dev-perl/XML-Parser-2.230.0
"
BDEPEND="${RDEPEND}
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
