# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DIST_AUTHOR=SCHWIGON
DIST_VERSION=1.42
inherit perl-module

DESCRIPTION="Perl client Interface to SSH"

SLOT="0"
KEYWORDS="~amd64 ~mips ~x86"
IUSE="minimal test"

RDEPEND="
	>=dev-perl/convert-pem-0.50.0
	dev-perl/Crypt-DES
	>=dev-perl/Crypt-DH-0.10.0
	>=dev-perl/Crypt-DSA-0.110.0
	dev-perl/Crypt-IDEA
	dev-perl/Digest-HMAC
	virtual/perl-Digest-MD5
	>=dev-perl/Digest-SHA1-2.100.0
	dev-perl/File-HomeDir
	virtual/perl-IO
	>=dev-perl/Math-GMP-1.40.0
	>=dev-perl/Math-Pari-2.1.804
	virtual/perl-MIME-Base64
	virtual/perl-Scalar-List-Utils
	>=dev-perl/string-crc32-1.200.0
	!minimal? (
		>=dev-perl/Module-Signature-0.500.0
		dev-perl/digest-bubblebabble
		dev-perl/Crypt-RSA
		dev-perl/TermReadKey
	)
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? ( >=virtual/perl-Test-Simple-0.610.0 )
"
