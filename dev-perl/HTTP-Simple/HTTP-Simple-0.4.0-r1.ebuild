# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=DBOOK
DIST_VERSION=0.004
inherit perl-module

DESCRIPTION="Simple procedural interface to HTTP::Tiny"

SLOT="0"
KEYWORDS="~alpha amd64 ~hppa ppc x86"

RDEPEND="
	>=virtual/perl-Exporter-5.570.0
	>=virtual/perl-JSON-PP-2.70.0
"
BDEPEND="${RDEPEND}"
