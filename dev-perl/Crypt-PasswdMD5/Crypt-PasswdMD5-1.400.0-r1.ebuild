# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=RSAVAGE
DIST_VERSION=1.40
DIST_A_EXT=tgz
inherit perl-module

DESCRIPTION="Provides interoperable MD5-based crypt() functions"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~ia64 ~mips ~ppc ppc64 ~sparc x86"
IUSE="test"
RESTRICT="!test? ( test )"
RDEPEND="
	>=virtual/perl-Digest-MD5-2.530.0
"
DEPEND="dev-perl/Module-Build"
BDEPEND="
	dev-perl/Module-Build
	test? (
		>=virtual/perl-Test-Simple-0.940.0
	)
"
