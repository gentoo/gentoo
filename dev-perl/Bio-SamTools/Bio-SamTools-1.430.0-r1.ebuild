# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=LDS
DIST_VERSION=1.43
inherit perl-module toolchain-funcs multilib

DESCRIPTION="Read SAM/BAM database files"

SLOT="0"
KEYWORDS="~amd64 ~x86"
LICENSE="|| ( Apache-2.0 Artistic-2 GPL-1+ )"

RDEPEND="
	>=sci-biology/bioperl-1.6.9
	sci-biology/samtools:0.1-legacy=
"
DEPEND="
	dev-perl/Module-Build
	sci-biology/samtools:0.1-legacy=
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-CBuilder
	>=dev-perl/Module-Build-0.420.0
"

PATCHES=(
	"${FILESDIR}"/${PN}-1.430.0-legacy-r1.patch
)

src_configure() {
	tc-export CC
	SAM_LIB="${EPREFIX}/usr/$(get_libdir)/libbam-0.1-legacy.so" \
		SAM_INCLUDE="${EPREFIX}/usr/include/bam-0.1-legacy" \
		perl-module_src_configure
}
