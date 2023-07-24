# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=AMBS
DIST_VERSION=0.89
DIST_EXAMPLES=( "examples/*" "scripts/*" )

inherit perl-module

DESCRIPTION="A Perl library for reading, parsing, and processing BibTeX files"

SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~ppc ~riscv ~x86"

RDEPEND="
	!dev-libs/btparse
	virtual/perl-Encode
	virtual/perl-Scalar-List-Utils
	virtual/perl-Unicode-Normalize
"
BDEPEND="
	${RDEPEND}
	>=dev-perl/Config-AutoConf-0.320
	>=dev-perl/ExtUtils-LibBuilder-0.20.0
	>=virtual/perl-ExtUtils-CBuilder-0.270.0
	>=dev-perl/Module-Build-0.360.300
	test? (
		>=dev-perl/Capture-Tiny-0.60.0
	)
"

src_prepare() {
	sed -i -e "/#include <stdio.h>/a #include <string.h>"\
		btparse/tests/{tex,purify,postprocess,name,macro}_test.c || die
	perl-module_src_prepare
}

src_install() {
	perl-module_src_install
	doheader btparse/src/btparse.h
	doheader btparse/src/bt_config.h
}
