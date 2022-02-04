# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=AKSTE
DIST_VERSION=4.6
inherit perl-module

DESCRIPTION="routines to display tabular data in several formats"

SLOT="0"
LICENSE="GPL-2+"
KEYWORDS="~alpha amd64 ~ia64 ppc sparc x86"

BDEPEND="virtual/perl-ExtUtils-MakeMaker"

PATCHES=(
	"${FILESDIR}/${P}-perl526.patch"
	"${FILESDIR}/${P}-parallel.patch"
)
