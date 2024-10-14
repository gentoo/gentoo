# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=MHX
DIST_VERSION=0.85
# NB: Examples are generated
DIST_EXAMPLES=("examples/*")
inherit perl-module

DESCRIPTION="Binary Data Conversion using C Types"

LICENSE="|| ( GPL-1+ Artistic ) BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

# bison >= 1.31?
BDEPEND="virtual/perl-ExtUtils-MakeMaker"

PERL_RM_FILES=(
	tests/802_pod.t
	tests/803_pod_coverage.t
)
