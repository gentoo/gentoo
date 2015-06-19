# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/perl-core/Parse-CPAN-Meta/Parse-CPAN-Meta-1.440.900-r1.ebuild,v 1.2 2015/06/08 20:41:01 dilfridge Exp $

EAPI=5

MODULE_AUTHOR=DAGOLDEN
MODULE_VERSION=1.4409
inherit perl-module

DESCRIPTION="Parse META.yml and other similar CPAN metadata files"

SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="
	>=virtual/perl-CPAN-Meta-YAML-0.8.0
	>=virtual/perl-JSON-PP-2.272.0
"
DEPEND="${RDEPEND}"

SRC_TEST=do
