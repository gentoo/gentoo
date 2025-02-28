# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=RKITOVER
DIST_VERSION=0.73
DIST_EXAMPLES=( "example/*" )
inherit perl-module

DESCRIPTION="Support for the SSH 2 protocol via libssh2"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gcrypt"

RDEPEND="
	net-libs/libssh2
	sys-libs/zlib
	!gcrypt? (
		dev-libs/openssl:=
	)
	gcrypt? (
		dev-libs/libgcrypt:=
	)
"
DEPEND="${RDEPEND}"
BDEPEND="
	${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.50
"

src_configure() {
	use gcrypt && myconf=gcrypt
	perl-module_src_configure
}
