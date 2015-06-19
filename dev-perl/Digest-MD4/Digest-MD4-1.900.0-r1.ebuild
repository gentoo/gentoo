# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Digest-MD4/Digest-MD4-1.900.0-r1.ebuild,v 1.8 2014/01/19 16:24:29 zlogene Exp $

EAPI=5

MODULE_AUTHOR=MIKEM
MODULE_VERSION=1.9
MODULE_SECTION=DigestMD4
inherit perl-module

DESCRIPTION="MD4 message digest algorithm"

SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~m68k ~mips ppc ppc64 ~s390 ~sh sparc x86"

SRC_TEST="do"
