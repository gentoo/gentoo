# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=IBB
DIST_VERSION=0.08
inherit perl-module

DESCRIPTION="Module, that 'unblesses' Perl objects"

SLOT="0"
KEYWORDS="amd64 x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND=""
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		dev-perl/Test-Exception
		virtual/perl-Test-Simple
	)
"
PATCHES=( "${FILESDIR}/${PN}-${DIST_VERSION}-respect-cflags.patch" )
