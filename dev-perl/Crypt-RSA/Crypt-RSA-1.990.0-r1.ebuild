# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=VIPUL
MODULE_VERSION=1.99
inherit perl-module

DESCRIPTION="RSA public-key cryptosystem"

SLOT="0"
KEYWORDS="alpha amd64 hppa ~mips x86 ~x86-solaris"
IUSE=""

DEPEND="dev-perl/Class-Loader
	dev-perl/Crypt-Blowfish
	dev-perl/Convert-ASCII-Armour
	dev-perl/Crypt-CBC
	dev-perl/Crypt-Primes
	dev-perl/Crypt-Random
	dev-perl/Data-Buffer
	dev-perl/Digest-MD2
	virtual/perl-Digest-MD5
	dev-perl/Digest-SHA1
	>=dev-perl/Math-Pari-2.010603
	dev-perl/Sort-Versions
	dev-perl/Tie-EncryptedHash"
RDEPEND="${DEPEND}"

SRC_TEST="do"
