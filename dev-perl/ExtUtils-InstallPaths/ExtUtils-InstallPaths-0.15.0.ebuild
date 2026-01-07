# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=LEONT
DIST_VERSION=0.015
inherit perl-module

DESCRIPTION="Build.PL install path logic made easy"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~x64-macos ~x64-solaris"

RDEPEND="
	>=dev-perl/ExtUtils-Config-0.9.0
"
BDEPEND="${RDEPEND}"
