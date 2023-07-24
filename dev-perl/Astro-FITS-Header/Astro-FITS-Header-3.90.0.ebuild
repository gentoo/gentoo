# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=GSB
DIST_VERSION=3.09
inherit perl-module

DESCRIPTION="Interface to FITS headers"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64 arm ~hppa ~mips ppc x86 ~amd64-linux ~x86-linux"

BDEPEND="
	>=dev-perl/Module-Build-0.300.0
	test? (
		virtual/perl-Test-Simple
	)
"
