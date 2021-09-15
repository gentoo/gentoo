# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=GSB
DIST_VERSION=3.08
inherit perl-module

DESCRIPTION="Interface to FITS headers"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64 arm ~hppa ~mips ppc x86 ~amd64-linux ~x86-linux"
IUSE="test"
RESTRICT="!test? ( test )"

BDEPEND="
	>=dev-perl/Module-Build-0.300.0
	test? (
		virtual/perl-Test-Simple
	)
"
