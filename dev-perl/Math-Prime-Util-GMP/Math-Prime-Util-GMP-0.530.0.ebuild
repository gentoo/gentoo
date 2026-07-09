# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=DANAJ
DIST_VERSION=0.53
inherit perl-module

DESCRIPTION="Utilities related to prime numbers and factoring, using GMP"

SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-libs/gmp:=
	>=virtual/perl-Exporter-5.570.0
	>=virtual/perl-XSLoader-0.10.0
"
BDEPEND="
	${RDEPEND}
	test? (
		>=virtual/perl-Math-BigInt-1.880.0
	)
"
