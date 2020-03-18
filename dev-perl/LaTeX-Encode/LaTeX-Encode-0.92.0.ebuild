# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=EINHVERFR
DIST_VERSION=0.092.0
inherit perl-module

DESCRIPTION="Encode characters for LaTeX formatting"

SLOT="0"
KEYWORDS="amd64 ~arm arm64 ppc ppc64 x86 ~ppc-aix ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	virtual/perl-Getopt-Long
	dev-perl/HTML-Parser
	dev-perl/Pod-LaTeX
	dev-perl/Readonly
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-Test-Simple
		dev-perl/Carp-Always
	)
"
src_test() {
	perl_rm_files t/9*.t
	perl-module_src_test
}
