# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=AUDREYT
MODULE_VERSION=0.79
inherit perl-module

DESCRIPTION="Module signature file manipulation"

LICENSE="CC0-1.0"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~x86-solaris"
IUSE="test"

# this needs checking, there is no indication in the metadata about any deps!!!
RDEPEND="
	virtual/perl-MIME-Base64
	dev-perl/PAR-Dist
	virtual/perl-IO-Compress
	dev-perl/Crypt-CBC
	dev-perl/Crypt-DES
	dev-perl/Crypt-Blowfish
	dev-perl/Crypt-RIPEMD160
	dev-perl/class-loader
	dev-perl/tie-encryptedhash
	dev-perl/convert-ascii-armour
	dev-perl/data-buffer
	dev-perl/digest-md2
	>=dev-perl/math-pari-2.010603
	dev-perl/Crypt-Random
	dev-perl/Crypt-Primes
	dev-perl/Crypt-DES_EDE3
	dev-perl/Crypt-DSA
	dev-perl/Crypt-RSA
	dev-perl/Convert-ASN1
	dev-perl/convert-pem
	dev-perl/Crypt-OpenPGP
	app-crypt/gnupg
	virtual/perl-File-Temp
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		dev-perl/IPC-Run
	)
"

SRC_TEST="do parallel"

src_test() {
	export TEST_SIGNATURE="1"
	perl-module_src_test
}
