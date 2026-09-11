# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=RSAVAGE
DIST_VERSION=1.46
DIST_A_EXT=tgz
inherit perl-module

DESCRIPTION="Provides interoperable MD5-based crypt() functions"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~mips ~ppc ~ppc64 ~riscv ~sparc ~x86"

RDEPEND="
	dev-perl/Crypt-URandom
	>=virtual/perl-Digest-MD5-2.530.0
	>=virtual/perl-Encode-3.210.0
	>=virtual/perl-Exporter-5.780.0
	>=virtual/perl-ExtUtils-MakeMaker-7.770.0
	>=virtual/perl-JSON-PP-4.160.0
"
BDEPEND="
	${RDEPEND}
	test? (
		>=virtual/perl-Test-Simple-1.1.2
	)
"
