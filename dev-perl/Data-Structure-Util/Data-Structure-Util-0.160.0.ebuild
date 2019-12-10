# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=ANDYA
DIST_VERSION=0.16
inherit perl-module

DESCRIPTION="Change nature of data within a structure"

SLOT="0"
KEYWORDS="alpha amd64 ia64 ppc ppc64 sparc x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	virtual/perl-Digest-MD5
	>=virtual/perl-Scalar-List-Utils-1.10.0
	virtual/perl-Storable
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? ( virtual/perl-Test-Simple )
"

src_test() {
	perl_rm_files t/00pod.t t/06signature.t
	perl-module_src_test
}
