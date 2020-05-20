# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=MARKOV
MODULE_VERSION=0.19
inherit perl-module

DESCRIPTION="Delayed creation of objects"

SLOT="0"
KEYWORDS="~alpha amd64 ~ppc64 x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	virtual/perl-Scalar-List-Utils
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? ( virtual/perl-Test-Simple )
"

SRC_TEST=do
