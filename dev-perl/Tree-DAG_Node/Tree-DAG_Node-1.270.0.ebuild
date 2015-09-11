# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=RSAVAGE
MODULE_A_EXT=tgz
MODULE_VERSION=1.27
inherit perl-module

DESCRIPTION="(Super)class for representing nodes in a tree"

LICENSE="Artistic-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x86-solaris"
IUSE="test"

RDEPEND="
	>=dev-perl/File-Slurp-Tiny-0.3.0
	>=virtual/perl-File-Spec-3.400.0
	>=virtual/perl-File-Temp-0.190.0
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		>=dev-perl/Test-Pod-1.480.0
		>=virtual/perl-Test-Simple-1.1.14
	)
"

SRC_TEST="do parallel"
