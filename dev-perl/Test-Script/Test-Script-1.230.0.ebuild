# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=PLICEASE
DIST_VERSION=1.23
inherit perl-module

DESCRIPTION="Cross-platform basic tests for scripts"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sh ~sparc ~x86 ~ppc-aix ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-perl/Capture-Tiny
	>=virtual/perl-File-Spec-0.800.0
	virtual/perl-IO
	>=dev-perl/Probe-Perl-0.10.0
	>=virtual/perl-Test-Simple-1.302.15
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		>=dev-perl/Test2-Suite-0.0.72
	)
"
