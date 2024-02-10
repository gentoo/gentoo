# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=NEILB
DIST_VERSION=0.04
inherit perl-module

DESCRIPTION="Porter's stemming algorithm for Russian (KOI8-R only)"

SLOT="0"
KEYWORDS="amd64 ~ia64 ~ppc sparc x86"

RDEPEND="
	virtual/perl-Carp
	>=virtual/perl-Exporter-5.570.0
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? ( virtual/perl-Test-Simple )
"
