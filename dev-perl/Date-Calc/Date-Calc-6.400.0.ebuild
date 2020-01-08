# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=STBEY
MODULE_VERSION=6.4
inherit perl-module

DESCRIPTION="Gregorian calendar date calculations"

LICENSE="${LICENSE} LGPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 ppc ppc64 ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE=""

RDEPEND="
	>=dev-perl/Bit-Vector-7.400.0
	>=dev-perl/Carp-Clan-6.40.0
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"

SRC_TEST="do"
export OPTIMIZE="$CFLAGS"
mydoc="ToDo"
