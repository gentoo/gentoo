# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=ADAMK
MODULE_VERSION=1.17
inherit perl-module

DESCRIPTION="DSA Signatures and Key Generation"

SLOT="0"
KEYWORDS="alpha amd64 hppa ppc sparc x86 ~x86-solaris"
IUSE="test"

RDEPEND="dev-perl/Data-Buffer
	dev-perl/Digest-SHA1
	virtual/perl-File-Spec
	dev-perl/File-Which
	virtual/perl-MIME-Base64
	>=virtual/perl-Math-BigInt-1.78"
DEPEND="test? ( ${RDEPEND}
		dev-perl/Math-BigInt-GMP )"

SRC_TEST="do"
