# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=TIMLEGGE
DIST_VERSION=1.18
inherit perl-module

DESCRIPTION="Pure-Perl OpenPGP-compatible PGP implementation"

SLOT="0"
KEYWORDS="amd64 x86"

# Note: Don't depend on Alt::, non Alt:: works for now
RDEPEND="
	dev-perl/Bytes-Random-Secure
	dev-perl/Crypt-RSA
	dev-perl/Crypt-Blowfish
	dev-perl/Crypt-CAST5_PP
	dev-perl/Crypt-DES_EDE3
	>=dev-perl/Crypt-DSA-1.170.0
	dev-perl/Crypt-IDEA
	>=dev-perl/Crypt-RIPEMD160-0.50.0
	dev-perl/Crypt-Rijndael
	>=dev-perl/Crypt-Twofish-2.00
	virtual/perl-Digest-MD5
	virtual/perl-Digest-SHA
	dev-perl/File-HomeDir
	virtual/perl-IO-Compress
	dev-perl/libwww-perl
	virtual/perl-MIME-Base64
	virtual/perl-Math-BigInt
	dev-perl/TermReadKey
	dev-perl/URI
	>=dev-perl/Data-Buffer-0.04
"
BDEPEND="
	${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		dev-perl/Test-Exception
		virtual/perl-Test-Simple
	)
"
