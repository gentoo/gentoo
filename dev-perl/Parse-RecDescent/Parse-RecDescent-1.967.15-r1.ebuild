# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=JTBRAUN
DIST_VERSION=1.967015
DIST_EXAMPLES=( 'demo/*' )
inherit perl-module

DESCRIPTION="Generate Recursive-Descent Parsers"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"

RDEPEND="
	>=virtual/perl-Text-Balanced-1.950.0
"
BDEPEND="${RDEPEND}
	dev-perl/Module-Build
	test? (
		virtual/perl-Test-Simple
		dev-perl/Test-Warn
	)
"

PERL_RM_FILES=( "t/pod.t" )

src_install() {
	perl-module_src_install
	docinto html/
	dodoc -r tutorial
}
