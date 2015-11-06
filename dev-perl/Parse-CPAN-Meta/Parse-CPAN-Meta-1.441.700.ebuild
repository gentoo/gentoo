# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=DAGOLDEN
MODULE_VERSION=1.4417
inherit perl-module

DESCRIPTION="Parse META.yml and META.json CPAN metadata files"

SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE="test"

RDEPEND=""
DEPEND="${REPEND}
	test? (
		virtual/perl-File-Spec
	)
	"

SRC_TEST="do"
