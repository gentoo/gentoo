# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=BHOLZMAN
DIST_VERSION=1.04
inherit perl-module

DESCRIPTION="Perl XML::Generator - A module to help in generating XML documents"

SLOT="0"
KEYWORDS="~alpha amd64 arm ~hppa ~ia64 ~mips ppc ppc64 ~s390 sparc x86"

DEPEND="
	dev-libs/expat
"
RDEPEND="${DEPEND}"
BDEPEND="${DEPEND}"
