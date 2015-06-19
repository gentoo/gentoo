# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Compress-Bzip2/Compress-Bzip2-2.170.0.ebuild,v 1.2 2013/12/01 19:47:43 zlogene Exp $

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
