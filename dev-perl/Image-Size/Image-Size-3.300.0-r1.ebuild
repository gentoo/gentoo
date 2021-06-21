# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=RJRAY
DIST_VERSION=3.300
inherit perl-module

DESCRIPTION="A library to extract height/width from images"

SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	virtual/perl-IO-Compress
	>=virtual/perl-File-Spec-0.800.0
"
BDEPEND="${RDEPEND}
	>=dev-perl/Module-Build-0.420.0
	test? (
		virtual/perl-Test-Simple
	)
"

mydoc="ToDo"
