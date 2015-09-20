# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=RKITOVER
MODULE_VERSION=0.53
inherit perl-module

DESCRIPTION="Net::SSH2 - Support for the SSH 2 protocol via libssh2"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gcrypt libressl"

RDEPEND="
	sys-libs/zlib
	net-libs/libssh2
	!gcrypt? (
		!libressl? ( dev-libs/openssl:0 )
		libressl? ( dev-libs/libressl )
	)
	gcrypt? (
		dev-libs/libgcrypt:0
	)
"
DEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.50
"

SRC_TEST="do"

src_configure() {
	use gcrypt && myconf=gcrypt
	perl-module_src_configure
}
