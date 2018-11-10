# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=MANU
MODULE_VERSION=1.26
inherit perl-module

DESCRIPTION="Perl extension for manipulating IPv4/IPv6 addresses"

SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~m68k ~mips ppc ppc64 s390 sh sparc x86 ~ppc-aix ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x86-solaris"
IUSE=""

PATCHES=( "${FILESDIR}/initip-0.patch" )
SRC_TEST="do"
