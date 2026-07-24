# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=ARODLAND
DIST_VERSION=0.261630
inherit perl-module

DESCRIPTION="The PBKDF2 password hashing algorithm"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~mips ~ppc64 ~riscv ~sparc"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-perl/Crypt-URandom
	>=virtual/perl-Digest-1.160.0
	>=dev-perl/Digest-HMAC-1.10.0
	>=dev-perl/Digest-SHA3-0.220.0
	dev-perl/Module-Runtime
	>=dev-perl/Moo-2.0.0
	>=dev-perl/Try-Tiny-0.40.0
	>=dev-perl/Type-Tiny-1.0.5
	dev-perl/namespace-autoclean
	>=dev-perl/strictures-2.0.0
"
BDEPEND="${RDEPEND}
	>=dev-perl/Module-Build-Tiny-0.34.0
	test? (
		dev-perl/Test-Fatal
	)
"
