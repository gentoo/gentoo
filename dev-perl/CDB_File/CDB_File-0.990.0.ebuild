# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DIST_AUTHOR=TODDR
DIST_VERSION=0.99
DIST_EXAMPLES=("examples/*")
inherit perl-module

DESCRIPTION="Tie to CDB (Bernstein's constant DB) files"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND=""
DEPEND="virtual/perl-ExtUtils-MakeMaker
	test? ( virtual/perl-Test-Simple )
"

src_prepare() {
	mkdir "${S}/examples"
	einfo "Moving bun-x.pl to examples/"
	cp "${S}/bun-x.pl" "${S}/examples/"
	perl_rm_files bun-x.pl
	perl-module_src_prepare
}
