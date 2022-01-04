# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=MANU
DIST_VERSION=1.26
inherit perl-module

DESCRIPTION="Perl extension for manipulating IPv4/IPv6 addresses"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~m68k ~mips ppc ppc64 ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-solaris"

PATCHES=( "${FILESDIR}/initip-0.patch" )
