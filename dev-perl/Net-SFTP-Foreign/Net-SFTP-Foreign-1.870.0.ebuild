# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=SALVA
DIST_VERSION=1.87
DIST_EXAMPLES=("samples/*")
inherit perl-module

DESCRIPTION="SSH File Transfer Protocol client"

SLOT="0"
KEYWORDS="amd64 ~hppa ~sparc x86"
IUSE="test examples"
RESTRICT="!test? ( test )"

RDEPEND="
	virtual/perl-Scalar-List-Utils
	virtual/perl-Time-HiRes
	virtual/ssh
"
DEPEND="
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-Test-Simple
	)
"
