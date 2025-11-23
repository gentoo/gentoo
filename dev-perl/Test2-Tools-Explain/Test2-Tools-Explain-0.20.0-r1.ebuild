# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=PETDANCE
DIST_VERSION=0.02
inherit perl-module

DESCRIPTION="Explain tools for Perl's Test2 framework"

SLOT="0"
KEYWORDS="amd64 ~x86"

RDEPEND="virtual/perl-Test2-Suite"
