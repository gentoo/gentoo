# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=LEEJO
DIST_VERSION=0.16
DIST_EXAMPLES=( "example/*" "benchmark" )
inherit perl-module

DESCRIPTION="Traces memory leaks"

SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 ~mips ppc ppc64 ~s390 sparc x86 ~amd64-fbsd ~x86-fbsd"
IUSE=""

RDEPEND="
	>=virtual/perl-Exporter-5.570.0
	>=virtual/perl-Test-Simple-0.620.0
"
DEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.590.0
"
