# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=NEZUMI
DIST_VERSION=0.03
inherit perl-module

DESCRIPTION="An eucJP-open mapping"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc x86 ~ppc-aix ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE=""

PERL_RM_FILES=( "t/pod.t" )
RDEPEND=">=virtual/perl-Encode-1.140.0"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"
