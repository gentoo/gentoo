# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Bio-SamTools/Bio-SamTools-1.390.0-r1.ebuild,v 1.4 2015/06/13 19:35:04 dilfridge Exp $

EAPI=5

MODULE_AUTHOR=LDS
MODULE_VERSION=1.39

inherit perl-module toolchain-funcs

DESCRIPTION="Read SAM/BAM database files"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	sci-biology/bioperl
	>=sci-biology/samtools-1
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-CBuilder
	dev-perl/Module-Build
"

SRC_TEST=do

PATCHES=(
	"${FILESDIR}"/${P}-samtools-1.patch
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
