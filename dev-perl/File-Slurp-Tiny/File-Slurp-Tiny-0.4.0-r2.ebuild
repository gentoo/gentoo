# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=LEONT
DIST_VERSION=0.004
inherit perl-module

DESCRIPTION="Simple, sane and efficient file slurper"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86"

RDEPEND="
	>=virtual/perl-Exporter-5.570.0
"
BDEPEND="${RDEPEND}"
