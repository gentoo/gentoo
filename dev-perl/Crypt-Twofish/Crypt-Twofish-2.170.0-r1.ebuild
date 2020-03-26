# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=AMS
MODULE_VERSION=2.17
inherit perl-module

DESCRIPTION="The Twofish Encryption Algorithm"

SLOT="0"
KEYWORDS="amd64 ia64 ~ppc sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x86-solaris"
IUSE=""
PATCHES=("${FILESDIR}/no-dot-inc.patch")
SRC_TEST="do"
