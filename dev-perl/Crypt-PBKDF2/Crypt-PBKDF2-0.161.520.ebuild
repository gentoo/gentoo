# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=ARODLAND
DIST_VERSION=0.161520
inherit perl-module

DESCRIPTION="The PBKDF2 password hashing algorithm"

SLOT="0"
KEYWORDS="~alpha amd64 arm64 ~hppa ~ia64 ~mips ppc64 sparc"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	virtual/perl-Carp
	>=virtual/perl-Digest-1.160.0
	>=dev-perl/Digest-HMAC-1.10.0
	virtual/perl-Digest-SHA
	>=dev-perl/Digest-SHA3-0.220.0
	virtual/perl-MIME-Base64
	dev-perl/Module-Runtime
	>=dev-perl/Moo-2.0.0
	virtual/perl-Scalar-List-Utils
	>=dev-perl/Try-Tiny-0.40.0
	>=dev-perl/Type-Tiny-1.0.5
	dev-perl/namespace-autoclean
	>=dev-perl/strictures-2.0.0
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		dev-perl/Test-Fatal
		virtual/perl-Test-Simple
	)
"
