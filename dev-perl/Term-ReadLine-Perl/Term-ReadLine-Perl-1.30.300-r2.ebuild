# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=ILYAZ
DIST_SECTION=modules
DIST_VERSION=1.0303

inherit perl-module

DESCRIPTION="Quick implementation of readline utilities"

SLOT="0"
KEYWORDS="alpha amd64 ~arm hppa ia64 ~mips ppc ppc64 ~s390 ~sh sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"
IUSE=""

PATCHES=(
	"${FILESDIR}/${PN}-1.0303-nointeractive.patch"
	"${FILESDIR}/${PN}-1.0303-packlistcollision.patch"
)
RDEPEND="dev-perl/TermReadKey"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"
