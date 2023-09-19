# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=SALVA
DIST_VERSION=0.72
DIST_EXAMPLES=( "example/*" )
inherit perl-module

DESCRIPTION="Support for the SSH 2 protocol via libssh2"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gcrypt"

RDEPEND="
	sys-libs/zlib
	net-libs/libssh2
	!gcrypt? (
		dev-libs/openssl:0
	)
	gcrypt? (
		dev-libs/libgcrypt:0
	)
"
DEPEND="${RDEPEND}
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-Constant
	>=virtual/perl-ExtUtils-MakeMaker-6.50
"

src_configure() {
	use gcrypt && myconf=gcrypt
	perl-module_src_configure
}
