# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=NEILB
DIST_VERSION=1.71
inherit perl-module

DESCRIPTION="Perl5 module for reading configuration files and parsing command line arguments"

SLOT="0"
KEYWORDS="~alpha ~amd64 arm arm64 ~ia64 ~ppc ~ppc64 sparc x86 ~ppc-aix ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-perl/File-HomeDir-0.57
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-Test-Simple
	)
"
src_test() {
	perl_rm_files t/97-pod.t t/99_author.t
	perl-module_src_test
}
