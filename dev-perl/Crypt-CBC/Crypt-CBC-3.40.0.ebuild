# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=LDS
DIST_VERSION=3.04
DIST_EXAMPLES=("eg/*")
inherit perl-module

DESCRIPTION="Encrypt Data with Cipher Block Chaining Mode"

SLOT="0"
KEYWORDS="~alpha amd64 arm64 ~ia64 ~mips ppc64 ~riscv sparc"

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
