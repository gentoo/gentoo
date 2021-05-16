# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=MIKEM
DIST_VERSION=0.08
inherit perl-module

DESCRIPTION="OpenSSL ECDSA (Elliptic Curve Digital Signature Algorithm) Perl extension"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	>=dev-perl/Crypt-OpenSSL-EC-0.50.0
	dev-libs/openssl:0
"
DEPEND="
	dev-libs/openssl:0
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"
PATCHES=(
	"${FILESDIR}/${P}-0002-Port-to-OpenSSL-1.1.0.patch"
)
src_compile() {
	mymake=(
		"OPTIMIZE=${CFLAGS}"
	)
	perl-module_src_compile
}
