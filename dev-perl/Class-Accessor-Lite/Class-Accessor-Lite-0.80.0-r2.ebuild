# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=KAZUHO
DIST_VERSION=0.08
inherit perl-module

DESCRIPTION="A minimalistic variant of Class::Accessor"

SLOT="0"
KEYWORDS="~alpha amd64 ~ia64 ppc ppc64 ~riscv sparc x86"

BDEPEND="
	>=virtual/perl-ExtUtils-MakeMaker-6.360.0
"

PATCHES=(
	"${FILESDIR}/${PN}-0.08-no-dot-inc.patch"
)
