# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=RRA
MODULE_VERSION=2.5.3
inherit perl-module

DESCRIPTION="Format POD source into various output formats"

SLOT="0"
KEYWORDS="amd64 ~arm ppc ppc64 x86"
IUSE=""

RDEPEND=">=dev-lang/perl-5.8.8-r8
	>=virtual/perl-Pod-Simple-3.06"
DEPEND="${RDEPEND}"

SRC_TEST=parallel
