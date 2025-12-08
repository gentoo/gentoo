# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=DHARRIS
DIST_VERSION=0.05
inherit perl-module

DESCRIPTION="Locking with flock wrapper for DB_File"

SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="virtual/perl-DB_File"
BDEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}/${PN}-0.05-RT98224.patch"
)
