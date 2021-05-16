# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=IZUT
DIST_VERSION=3.03
inherit perl-module

DESCRIPTION="A simple date object"

SLOT="0"
LICENSE="|| ( Artistic GPL-2+ )"
KEYWORDS="amd64 ~arm x86 ~x86-solaris"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	virtual/perl-Scalar-List-Utils
"
BDEPEND="
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-Test-Simple
	)
"
src_compile() {
	mymake=(
		"OPTIMIZE=${CFLAGS}"
	)
	perl-module_src_compile
}
