# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=PEVANS
DIST_VERSION=0.21
inherit perl-module

DESCRIPTION="XS functions to assist in parsing sub-like syntax"

SLOT="0"
KEYWORDS="amd64 ~ppc x86"

BDEPEND="
	>=dev-perl/Module-Build-0.400.400
	test? (
		virtual/perl-Scalar-List-Utils
		dev-perl/Test2-Suite
	)
"
