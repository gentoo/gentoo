# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=TIMLEGGE
DIST_VERSION=0.13
inherit perl-module

DESCRIPTION="Read/write encrypted ASN.1 PEM files"

SLOT="0"
KEYWORDS="~alpha amd64 ~hppa ~mips ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos"

RDEPEND="
	dev-perl/Class-ErrorHandler
	>=dev-perl/Convert-ASN1-0.340.0
	dev-perl/Crypt-DES_EDE3
	dev-perl/CryptX
	virtual/perl-Digest-MD5
	virtual/perl-MIME-Base64
"
BDEPEND="
	${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? ( dev-perl/Test-Exception )
"
