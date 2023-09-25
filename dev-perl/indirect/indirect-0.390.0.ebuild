# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=VPIT
DIST_VERSION=0.39
inherit perl-module

DESCRIPTION="Lexically warn about using the indirect method call syntax"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"

RDEPEND="
	virtual/perl-Carp
	virtual/perl-XSLoader
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	virtual/perl-Socket
	test? ( virtual/perl-Test-Simple )
"
