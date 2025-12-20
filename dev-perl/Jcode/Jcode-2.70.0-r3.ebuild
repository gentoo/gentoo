# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=DANKOGAI
DIST_VERSION=2.07
inherit perl-module

DESCRIPTION="Japanese transcoding module for Perl"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~x64-macos ~x64-solaris"

RDEPEND=">=virtual/perl-MIME-Base64-2.1"
BDEPEND="${RDEPEND}"
