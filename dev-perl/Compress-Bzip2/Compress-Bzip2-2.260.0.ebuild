# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_VERSION=2.26
DIST_AUTHOR=RURBAN
inherit perl-module

DESCRIPTION="Interface to Bzip2 compression library"

SLOT="0"
KEYWORDS="amd64 ia64 ~mips sparc x86 ~ppc-aix ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="test"

RDEPEND="
	app-arch/bzip2
	virtual/perl-Carp
	virtual/perl-File-Spec
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? ( virtual/perl-Test-Simple )
"

src_test() {
	perl_rm_files t/900_*.t
	perl-module_src_test
}
