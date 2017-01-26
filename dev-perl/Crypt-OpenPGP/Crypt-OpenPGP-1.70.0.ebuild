# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=SROMANOV
MODULE_VERSION=1.07
inherit perl-module

DESCRIPTION="Pure-Perl OpenPGP-compatible PGP implementation"

SLOT="0"
KEYWORDS="amd64 x86 ~x86-solaris"
IUSE="test"

# Core dependancies are:
# >=Data-Buffer 0.04
# MIME-Base64
# Math-Pari
# Compress-Zlib
# LWP-UserAgent
# URI-Escape

RDEPEND="
	>=dev-perl/Data-Buffer-0.04
	virtual/perl-MIME-Base64
	virtual/perl-Math-BigInt
	virtual/perl-IO-Compress
	dev-perl/libwww-perl
	dev-perl/URI
	dev-perl/Crypt-DSA
	dev-perl/Crypt-RSA
	dev-perl/File-HomeDir

	dev-perl/Crypt-IDEA
	virtual/perl-Digest-MD5

	dev-perl/Crypt-DES_EDE3
	dev-perl/Digest-SHA1

	dev-perl/Crypt-Rijndael
	dev-perl/Crypt-CAST5_PP
	dev-perl/Crypt-RIPEMD160

	dev-perl/Crypt-Blowfish
	>=dev-perl/Crypt-Twofish-2.00
	"
DEPEND="${RDEPEND}
	test? (
		dev-perl/Test-Exception
	)"

SRC_TEST="do"
