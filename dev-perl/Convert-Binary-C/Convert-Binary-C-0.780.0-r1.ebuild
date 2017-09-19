# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=MHX
DIST_VERSION=0.78
# NB: Examples are generated
DIST_EXAMPLES=("examples/*")
inherit perl-module

DESCRIPTION="Binary Data Conversion using C Types"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

# bison >= 1.31?
DEPEND="virtual/perl-ExtUtils-MakeMaker"

MAKEOPTS+=" -j1"
PATCHES=( "${FILESDIR}/${P}-perl-526.patch" )
src_test() {
	perl_rm_files tests/802_pod.t tests/803_pod_coverage.t
	perl-module_src_test
}
