# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=ILYAZ
DIST_SECTION=modules
DIST_VERSION=1.0303

inherit perl-module

DESCRIPTION="Quick implementation of readline utilities"

SLOT="0"
KEYWORDS="~alpha amd64 arm ~arm64 ~hppa ~mips ppc ppc64 ~riscv ~s390 ~sparc x86"

PATCHES=(
	"${FILESDIR}/${PN}-1.0303-nointeractive.patch"
	"${FILESDIR}/${PN}-1.0303-packlistcollision.patch"
)

RDEPEND="
	dev-perl/TermReadKey
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"
