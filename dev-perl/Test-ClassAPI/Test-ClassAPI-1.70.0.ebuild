# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=ETHER
DIST_VERSION=1.07
inherit perl-module

DESCRIPTION="Provides basic first-pass API testing for large class trees"

SLOT="0"
KEYWORDS="alpha amd64 hppa ia64 ~mips ppc sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris"
IUSE=""

RDEPEND="
	>=dev-perl/Class-Inspector-1.120.0
	>=dev-perl/Config-Tiny-2.0.0
	>=virtual/perl-File-Spec-0.830.0
	>=dev-perl/Params-Util-1.0.0
	>=virtual/perl-Test-Simple-0.470.0
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"
