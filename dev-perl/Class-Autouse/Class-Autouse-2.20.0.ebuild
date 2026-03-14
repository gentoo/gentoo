# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=ETHER
DIST_VERSION=2.02
inherit perl-module

DESCRIPTION="Run-time load a class the first time you call a method in it"

SLOT="0"
KEYWORDS="~amd64 ~hppa ~mips ~ppc ~x86"

RDEPEND="
	>=virtual/perl-Scalar-List-Utils-1.180.0
"
BDEPEND="${RDEPEND}"
