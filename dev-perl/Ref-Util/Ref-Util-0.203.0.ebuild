# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=ARC
DIST_VERSION=0.203
inherit perl-module

DESCRIPTION="Utility functions for checking references"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sh ~sparc ~x86 ~ppc-aix ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
LICENSE="MIT"
IUSE="test +xs"
RESTRICT="!test? ( test )"

RDEPEND="
	xs? (
		dev-perl/Ref-Util-XS
	)
	>=virtual/perl-Exporter-5.570.0
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	virtual/perl-Text-ParseWords
	test? (
		>=virtual/perl-CPAN-Meta-2.120.900
		>=virtual/perl-Test-Simple-0.960.0
		virtual/perl-File-Spec
	)
"
