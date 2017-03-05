# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=ADAMK
MODULE_VERSION=0.6
inherit perl-module

DESCRIPTION="Format validation and more for Net:: related strings"

SLOT="0"
KEYWORDS="alpha amd64 hppa ~mips ~ppc x86"
IUSE="test"

RDEPEND="dev-perl/Class-Default"
DEPEND="${RDEPEND}
	test? ( virtual/perl-Test-Simple )"

SRC_TEST="do"
