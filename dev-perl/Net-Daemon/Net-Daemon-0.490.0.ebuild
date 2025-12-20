# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=TODDR
DIST_VERSION=0.49
inherit perl-module

DESCRIPTION="Perl extension for portable daemons"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~x64-macos ~x64-solaris"

# loop-t and loop-child-t race-condition
# due to Net::Daemon::Test writing
# specific files to CWD
DIST_TEST="do"
