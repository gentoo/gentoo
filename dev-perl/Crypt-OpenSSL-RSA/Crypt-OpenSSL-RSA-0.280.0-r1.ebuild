# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Crypt-OpenSSL-RSA/Crypt-OpenSSL-RSA-0.280.0-r1.ebuild,v 1.1 2014/08/22 15:28:22 axs Exp $

EAPI=5

MODULE_AUTHOR=PERLER
MODULE_VERSION=0.28
inherit perl-module

DESCRIPTION="Crypt::OpenSSL::RSA module for perl"

SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86 ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos"
IUSE=""

RDEPEND="dev-perl/Crypt-OpenSSL-Bignum
	dev-perl/Crypt-OpenSSL-Random
	dev-libs/openssl"
DEPEND="${RDEPEND}"

SRC_TEST="do"

mydoc="rfc*.txt"
