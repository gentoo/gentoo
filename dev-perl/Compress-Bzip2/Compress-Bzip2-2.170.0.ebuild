# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_VERSION=2.17
MODULE_AUTHOR=RURBAN
inherit perl-module

DESCRIPTION="A Bzip2 perl module"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ia64 ~mips sparc x86 ~ppc-aix"
IUSE=""

RDEPEND="app-arch/bzip2"
DEPEND="${RDEPEND}"

SRC_TEST="do"
