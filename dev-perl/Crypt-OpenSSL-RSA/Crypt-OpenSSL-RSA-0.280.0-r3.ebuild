# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=PERLER
MODULE_VERSION=0.28
inherit perl-module

DESCRIPTION="Crypt::OpenSSL::RSA module for perl"

SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~m68k ~mips ppc ppc64 ~s390 ~sh sparc x86 ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos"
IUSE="libressl"

RDEPEND="dev-perl/Crypt-OpenSSL-Bignum
	dev-perl/Crypt-OpenSSL-Random
	!libressl? ( dev-libs/openssl:0 )
	libressl? ( dev-libs/libressl )
"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}/${P}-openssl-1.1.0.patch"
)

SRC_TEST="do"

mydoc="rfc*.txt"
