# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DIST_AUTHOR=BAREFOOT
DIST_VERSION=0.12
inherit perl-module

DESCRIPTION="A module used to generate random data"

SLOT="0"
KEYWORDS="~amd64 ~sparc ~x86"
IUSE="test"

RDEPEND="
	virtual/perl-Carp
	>=virtual/perl-Time-Piece-1.160.0
"
DEPEND="
	>=virtual/perl-ExtUtils-MakeMaker-6.360.0
	test? (
		>=virtual/perl-Test-Simple-0.880.0
		virtual/perl-File-Temp
	)
"

src_prepare() {
	sed -i -e '/jsonmeta;/d'        \
                -e '/githubmeta;/d'     \
                Makefile.PL || die
	perl-module_src_prepare
}

src_test() {
	perl_rm_files t/z0_pod.t t/z1_pod-coverage.t
	perl-module_src_test
}
