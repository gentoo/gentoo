# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MY_PN=Convert-PEM
MODULE_AUTHOR=BTROTT
MODULE_VERSION=0.08
inherit perl-module

DESCRIPTION="Read/write encrypted ASN.1 PEM files"

SLOT="0"
KEYWORDS="alpha amd64 hppa ~mips ~ppc ppc64 x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x86-solaris"
IUSE=""

RDEPEND="
	dev-perl/Class-ErrorHandler
	dev-perl/Convert-ASN1
	dev-perl/Crypt-DES_EDE3
	virtual/perl-Digest-MD5
	virtual/perl-MIME-Base64
"
DEPEND="${RDEPEND}"

SRC_TEST=do
