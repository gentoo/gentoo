# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=MIKEM
MODULE_VERSION=1.9
MODULE_SECTION=DigestMD4
inherit perl-module

DESCRIPTION="MD4 message digest algorithm"

SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~m68k ~mips ppc ppc64 ~s390 ~sh sparc x86"

SRC_TEST="do"
