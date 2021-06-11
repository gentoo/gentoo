# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=NEILB
MODULE_VERSION=1.80
inherit perl-module

DESCRIPTION="Locate modules in the same fashion as require and use"

SLOT="0"
KEYWORDS="amd64 ppc x86 ~amd64-linux ~x86-linux ~ppc-macos ~sparc-solaris"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	virtual/perl-Carp
	virtual/perl-File-Spec
	virtual/perl-IO
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? ( virtual/perl-Test-Simple )
"

SRC_TEST="do parallel"
