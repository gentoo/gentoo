# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=VIPUL
DIST_VERSION=1.99
inherit perl-module

DESCRIPTION="RSA public-key cryptosystem"

SLOT="0"
KEYWORDS="~alpha amd64 ~hppa x86 ~x86-solaris"

RDEPEND="
	>=dev-perl/Class-Loader-2.0.0
	dev-perl/Convert-ASCII-Armour
	dev-perl/Crypt-Blowfish
	dev-perl/Crypt-CBC
	>=dev-perl/Crypt-Primes-0.380.0
	>=dev-perl/Crypt-Random-0.340.0
	dev-perl/Data-Buffer
	virtual/perl-Data-Dumper
	dev-perl/Digest-MD2
	virtual/perl-Digest-MD5
	dev-perl/Digest-SHA1
	>=dev-perl/Math-Pari-2.10.603
	dev-perl/Sort-Versions
	dev-perl/Tie-EncryptedHash"
BDEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}/${PN}-1.99-no-dot-inc.patch"
	"${FILESDIR}/${PN}-1.99-test-segv.patch"
)
