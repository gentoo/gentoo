# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=DANAJ
DIST_VERSION=0.02
inherit perl-module

DESCRIPTION="DSA Signatures and Key Generation"

SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-perl/Crypt-Random-Seed
	>=dev-perl/Data-Buffer-0.40.0
	dev-perl/Math-BigInt-GMP
	>=dev-perl/Math-Prime-Util-GMP-0.150.0
	>=virtual/perl-Digest-SHA-5.22.0
	>=virtual/perl-Exporter-5.562.0
	>=virtual/perl-Math-BigInt-1.780.0
"
