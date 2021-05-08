# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=BTROTT
DIST_VERSION=0.08
inherit perl-module

DESCRIPTION="Read/write encrypted ASN.1 PEM files"

SLOT="0"
KEYWORDS="~alpha amd64 ~hppa ~mips ppc ppc64 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-solaris"

RDEPEND="
	dev-perl/Class-ErrorHandler
	>=dev-perl/Convert-ASN1-0.100.0
	dev-perl/Crypt-DES_EDE3
	virtual/perl-Digest-MD5
	virtual/perl-MIME-Base64
"
BDEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.420.0
"
PATCHES=(
	"${FILESDIR}/${P}-526.patch"
	"${FILESDIR}/${P}-decryptiontest.patch"
	"${FILESDIR}/${P}-testbuilder.patch"
)
