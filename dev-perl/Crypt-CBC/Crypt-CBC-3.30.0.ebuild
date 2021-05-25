# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=LDS
DIST_VERSION=3.03
DIST_EXAMPLES=("eg/*")
inherit perl-module

DESCRIPTION="Encrypt Data with Cipher Block Chaining Mode"

SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ia64 ~mips ~ppc64 ~sparc"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-perl/CryptX
	dev-perl/Crypt-PBKDF2
	virtual/perl-Digest-MD5
	virtual/perl-Digest-SHA
	virtual/perl-Math-BigInt
	dev-perl/Math-Int128
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		dev-perl/Crypt-Blowfish
		dev-perl/Crypt-DES
		dev-perl/Crypt-IDEA
		dev-perl/Crypt-Rijndael
	)
"
