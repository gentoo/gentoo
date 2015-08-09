# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=RSAVAGE
MODULE_VERSION=2.16
MODULE_A_EXT="tgz"
inherit perl-module

DESCRIPTION="Read/Write .ini style files with as little code as possible"

SLOT="0"
KEYWORDS="alpha amd64 hppa ia64 ~mips ppc ppc64 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris"
IUSE="test"

DEPEND=">=dev-perl/Module-Build-0.380.0
	test? (
		>=virtual/perl-File-Spec-3.300.0
		>=virtual/perl-File-Temp-0.220.0
		>=virtual/perl-Test-Simple-0.470.0
	)
"

SRC_TEST="do"
