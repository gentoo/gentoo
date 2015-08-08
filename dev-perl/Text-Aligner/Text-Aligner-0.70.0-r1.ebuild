# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=ANNO
MODULE_VERSION=0.07
inherit perl-module

DESCRIPTION="Used to justify strings to various alignment styles"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=virtual/perl-Term-ANSIColor-2.01"
DEPEND="${RDEPEND}"

SRC_TEST="do"
