# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=ETHER
MODULE_VERSION=1.70
inherit perl-module

DESCRIPTION="Utilities to write and check a MANIFEST file"

SLOT="0"
KEYWORDS=""
IUSE=""

SRC_TEST="do"
PREFER_BUILDPL="no"

RDEPEND="!=perl-core/ExtUtils-MakeMaker-7.40.0"
