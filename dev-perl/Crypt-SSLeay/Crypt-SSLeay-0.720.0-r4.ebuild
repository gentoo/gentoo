# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=NANIS
DIST_VERSION=0.72
inherit perl-module

DESCRIPTION="OpenSSL support for LWP"

LICENSE="Artistic-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~mips ppc ppc64 ~riscv ~s390 ~sparc x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-libs/openssl-0.9.7c:0=
	virtual/perl-MIME-Base64
"
DEPEND="
	>=dev-libs/openssl-0.9.7c:0=
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	>=virtual/perl-ExtUtils-CBuilder-0.280.205
	virtual/perl-Getopt-Long
	>=dev-perl/Path-Class-0.260.0
	>=dev-perl/Try-Tiny-0.190.0
	test? (
		>=virtual/perl-Test-Simple-0.190.0
	)
"
# PDEPEND: circular dependencies bug #144761
PDEPEND="
	dev-perl/libwww-perl
	>=dev-perl/LWP-Protocol-https-6.20.0
"

PATCHES=(
	"${FILESDIR}/${PN}-0.720.0-no-ssl3.patch"
	"${FILESDIR}/${P}-no-dot-inc.patch"
)
src_compile() {
	mymake=(
		"OPTIMIZE=${CFLAGS}"
	)
	perl-module_src_compile
}
