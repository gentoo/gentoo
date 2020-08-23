# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
DIST_AUTHOR=KMX
DIST_VERSION=0.19
inherit perl-module

DESCRIPTION='Digital Signature Algorithm using OpenSSL'
SLOT="0"
KEYWORDS="~alpha amd64 arm hppa ~ia64 ~mips ppc ppc64 sparc x86"
IUSE="libressl"

RDEPEND="
	!libressl? ( dev-libs/openssl:0 )
	libressl? ( >=dev-libs/libressl-2.7.2 )
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"

DIST_TEST=do
# otherwise random fails occur
