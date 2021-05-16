# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=DWHEELER
MODULE_VERSION=3.28
inherit perl-module

DESCRIPTION="Framework for parsing Pod"

SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND=">=virtual/perl-Pod-Escapes-1.04"
RDEPEND="${DEPEND}"

SRC_TEST="parallel"
