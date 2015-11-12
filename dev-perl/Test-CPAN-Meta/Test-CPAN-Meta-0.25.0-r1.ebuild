# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=BARBIE
MODULE_VERSION=0.25
inherit perl-module

DESCRIPTION="Validate your CPAN META.yml file"

SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86"
IUSE="test"

RDEPEND=""
DEPEND="${RDEPEND}
	test? (
		virtual/perl-Parse-CPAN-Meta
	)"

SRC_TEST="do"
