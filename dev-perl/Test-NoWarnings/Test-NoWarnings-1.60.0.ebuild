# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=HAARG
DIST_VERSION=1.06
inherit perl-module

DESCRIPTION="Make sure you didn't emit any warnings while testing"

SLOT="0"
LICENSE="LGPL-2.1"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~x64-macos ~x64-solaris"

RDEPEND="virtual/perl-Test-Simple"
BDEPEND="${RDEPEND}"
