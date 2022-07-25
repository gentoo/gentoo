# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=DMAKI
DIST_VERSION=0.00012
inherit perl-module

DESCRIPTION="Crypt::DH Using GMP Directly"

SLOT="0"
KEYWORDS="amd64 ~ppc64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=virtual/perl-XSLoader-0.20.0
	>=dev-libs/gmp-4.0.0:0
"
DEPEND="
	>=dev-libs/gmp-4.0.0:0
"
BDEPEND="${RDEPEND}
	>=dev-perl/Devel-CheckLib-0.400.0
	>=virtual/perl-Devel-PPPort-3.190.0
	>=virtual/perl-ExtUtils-MakeMaker-6.590.0
	>=virtual/perl-ExtUtils-ParseXS-3.180.0
	test? (
		dev-perl/Test-Requires
		virtual/perl-Test-Simple
	)
"
PATCHES=(
	"${FILESDIR}/${PN}-0.00012-no-dot-inc.patch"
)
src_compile() {
	mymake=(
		"OPTIMIZE=${CFLAGS}"
	)
	perl-module_src_compile
}
