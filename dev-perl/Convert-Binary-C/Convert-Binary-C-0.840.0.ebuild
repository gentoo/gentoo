# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=MHX
DIST_VERSION=0.84
# NB: Examples are generated
DIST_EXAMPLES=("examples/*")
inherit perl-module

DESCRIPTION="Binary Data Conversion using C Types"

SLOT="0"
KEYWORDS="~amd64 ~x86"
LICENSE="|| ( GPL-1+ Artistic ) BSD"

# bison >= 1.31?
BDEPEND="virtual/perl-ExtUtils-MakeMaker"

PERL_RM_FILES=(
	tests/802_pod.t
	tests/803_pod_coverage.t
)
src_compile() {
	mymake=(
		"OPTIMIZE=${CFLAGS}"
		# Parallel CC breaks
		"-j1"
	)
	perl-module_src_compile
}
