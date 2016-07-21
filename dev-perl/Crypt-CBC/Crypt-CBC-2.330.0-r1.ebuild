# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=LDS
MODULE_VERSION=2.33
inherit perl-module

DESCRIPTION="Encrypt Data with Cipher Block Chaining Mode"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="alpha amd64 hppa ia64 ~mips ppc ppc64 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x86-solaris"
IUSE="test"

RDEPEND="virtual/perl-Digest-MD5"
DEPEND="${RDEPEND}
	test? (
		dev-perl/Crypt-Blowfish
		dev-perl/Crypt-DES
		dev-perl/Crypt-IDEA
	)"
#		dev-perl/Crypt-Rijndael"

SRC_TEST="do"
