# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/crypt-rsa/crypt-rsa-1.990.0-r1.ebuild,v 1.1 2014/08/22 15:59:14 axs Exp $

EAPI=5

MY_PN=Crypt-RSA
MODULE_AUTHOR=VIPUL
MODULE_VERSION=1.99
inherit perl-module

DESCRIPTION="RSA public-key cryptosystem"

SLOT="0"
KEYWORDS="alpha amd64 hppa ~mips ~ppc x86 ~x86-solaris"
IUSE=""

DEPEND="dev-perl/class-loader
	dev-perl/Crypt-Blowfish
	dev-perl/convert-ascii-armour
	dev-perl/crypt-cbc
	dev-perl/crypt-primes
	dev-perl/crypt-random
	dev-perl/data-buffer
	dev-perl/digest-md2
	virtual/perl-Digest-MD5
	dev-perl/Digest-SHA1
	>=dev-perl/math-pari-2.010603
	dev-perl/Sort-Versions
	dev-perl/tie-encryptedhash"
RDEPEND="${DEPEND}"

SRC_TEST="do"
