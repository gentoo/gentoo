# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=MSCHWARTZ
DIST_VERSION=0.112
inherit perl-module

DESCRIPTION="Map charsets from and to utf16 code"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~arm64-macos ~x64-macos ~x64-solaris"

PATCHES=( "${FILESDIR}"/0.112-no-scripts.patch )
