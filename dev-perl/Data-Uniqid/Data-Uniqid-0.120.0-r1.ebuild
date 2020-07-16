# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR="MWX"
MODULE_VERSION=0.12
inherit perl-module

DESCRIPTION="Perl extension for simple generating of unique ids"

SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~ppc x86"
IUSE=""

RDEPEND="
	virtual/perl-Math-BigInt
	virtual/perl-Time-HiRes
"
DEPEND="${RDEPEND}"

SRC_TEST="do"
