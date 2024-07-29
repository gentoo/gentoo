# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=BARBIE
DIST_VERSION=0.25
inherit perl-module

DESCRIPTION="Validate your CPAN META.yml file"

SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86"

RDEPEND=""
BDEPEND="${RDEPEND}
	test? (
		virtual/perl-Parse-CPAN-Meta
	)"
