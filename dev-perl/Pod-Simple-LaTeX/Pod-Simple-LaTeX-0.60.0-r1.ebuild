# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=JGOFF
DIST_VERSION=0.06
inherit perl-module

DESCRIPTION="format Pod as LaTeX"
SLOT="0"
KEYWORDS="amd64 ~riscv x86 ~x64-macos ~x64-solaris"

RDEPEND="
	>=virtual/perl-Pod-Simple-0.10.0
"
BDEPEND="${RDEPEND}
"
