# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=DHARRIS
MODULE_VERSION=0.05
inherit perl-module

DESCRIPTION="Locking with flock wrapper for DB_File"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="virtual/perl-DB_File"
DEPEND="${RDEPEND}"

PATCHES=("${FILESDIR}/${PN}-${MODULE_VERSION}-RT98224.patch")

SRC_TEST=do
