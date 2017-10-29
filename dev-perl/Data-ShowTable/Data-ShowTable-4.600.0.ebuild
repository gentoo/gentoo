# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=AKSTE
MODULE_VERSION=4.6
inherit perl-module

DESCRIPTION="routines to display tabular data in several formats"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="alpha amd64 ia64 ppc sparc x86"
IUSE=""

DEPEND="virtual/perl-ExtUtils-MakeMaker"

SRC_TEST="do parallel"

PATCHES=(
	"${FILESDIR}/${P}-perl526.patch"
	"${FILESDIR}/${P}-parallel.patch"
)
