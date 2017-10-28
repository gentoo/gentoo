# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=LDS
DIST_VERSION=1.43
inherit perl-module toolchain-funcs

DESCRIPTION="Read SAM/BAM database files"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
LICENSE="|| ( Apache-2.0 Artistic-2 GPL-1+ )"

RDEPEND="
	>=sci-biology/bioperl-1.6.9
	sci-biology/samtools:0.1-legacy=
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-CBuilder
	>=dev-perl/Module-Build-0.420.0
"

PATCHES=(
	"${FILESDIR}"/${PN}-1.430.0-legacy.patch
)

src_prepare() {
	perl-module_src_prepare
	tc-export CC
}
