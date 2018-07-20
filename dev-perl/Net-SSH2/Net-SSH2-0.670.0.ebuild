# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=SALVA
DIST_VERSION=0.67
DIST_EXAMPLES=( "example/*" )
inherit perl-module

DESCRIPTION="Support for the SSH 2 protocol via libssh2"

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
	virtual/perl-ExtUtils-Constant
	>=virtual/perl-ExtUtils-MakeMaker-6.50
"
PATCHES=(
	"${FILESDIR}/${PN}-0.67-perl-5.26.patch"
)

src_configure() {
	use gcrypt && myconf=gcrypt
	perl-module_src_configure
}
