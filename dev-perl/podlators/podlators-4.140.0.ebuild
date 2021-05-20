# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=RRA
DIST_VERSION=4.14
inherit perl-module

DESCRIPTION="Convert POD source into various output formats"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~x64-cygwin ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE=""

RDEPEND="
	>=virtual/perl-Pod-Simple-3.60.0
	!perl-core/podlators
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"
