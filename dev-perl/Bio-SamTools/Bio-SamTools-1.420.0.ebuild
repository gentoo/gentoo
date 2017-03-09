# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=LDS
DIST_VERSION=1.42
inherit perl-module toolchain-funcs

DESCRIPTION="Read SAM/BAM database files"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
LICENSE="|| ( Apache-2.0 Artistic-2 GPL-1+ )"

RDEPEND="
	>=sci-biology/bioperl-1.6.9
	>=sci-biology/samtools-1:0
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-CBuilder
	>=dev-perl/Module-Build-0.420.0
"

DIST_TEST=skip
# cannot load its own library, fundamentally b0rken

PATCHES=(
	"${FILESDIR}"/${PN}-1.390.0-samtools-1.patch
)

src_prepare() {
	find . -type f -exec chmod +w '{}' + || die
	sed \
		-e 's|my $HeaderFile = "bam.h";|my $HeaderFile = "bam/bam.h";|' \
		-e 's|my $LibFile    = "libbam.a";|my $LibFile    = "libbam.so";|' \
		-i Build.PL || die
	sed \
		-e 's|#include "bam.h"|#include "bam/bam.h"|' \
		-e 's|#include "sam.h"|#include "bam/sam.h"|' \
		-e 's|#include "khash.h"|#include "htslib/khash.h"|' \
		-e 's|#include "faidx.h"|#include "htslib/faidx.h"|' \
		-i lib/Bio/DB/Sam.xs c_bin/bam2bedgraph.c || die

	perl-module_src_prepare

	tc-export CC
}
