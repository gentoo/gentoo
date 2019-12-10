# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=KWILLIAMS
DIST_VERSION=0.37
inherit perl-module

DESCRIPTION="Cross-platform path specification manipulation"

SLOT="0"
KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 ~m68k ~mips ppc ppc64 s390 ~sh sparc x86 ~ppc-aix ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	virtual/perl-Carp
	virtual/perl-Exporter
	virtual/perl-File-Path
	>=virtual/perl-File-Spec-3.260.0
	virtual/perl-File-Temp
	virtual/perl-IO
	virtual/perl-Perl-OSType
	virtual/perl-Scalar-List-Utils
	virtual/perl-parent
"
DEPEND="${RDEPEND}
	>=dev-perl/Module-Build-0.360.100
	>=virtual/perl-ExtUtils-MakeMaker-6.300.0
	test? (
		virtual/perl-Test
		virtual/perl-Test-Simple
	)
"
src_test() {
	perl_rm_files "t/author-critic.t"
	perl-module_src_test
}
