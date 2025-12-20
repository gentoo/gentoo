# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=NEILB
DIST_VERSION=1.71
inherit perl-module

DESCRIPTION="Perl5 module for reading configuration files and parsing command line arguments"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~x64-macos ~x64-solaris"
IUSE="test"
RESTRICT="!test? ( test )"

# https://bugs.gentoo.org/721206
# https://rt.cpan.org/Public/Bug/Display.html?id=132442
LICENSE="Artistic"

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
