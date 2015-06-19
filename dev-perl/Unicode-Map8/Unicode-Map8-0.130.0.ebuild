# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Unicode-Map8/Unicode-Map8-0.130.0.ebuild,v 1.12 2014/07/23 21:54:43 zlogene Exp $

EAPI=5

MODULE_AUTHOR=GAAS
MODULE_VERSION=0.13
inherit perl-module

DESCRIPTION="Convert between most 8bit encodings"

SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 ~s390 ~sh sparc x86"
IUSE=""

RDEPEND=">=dev-perl/Unicode-String-2.06"
DEPEND="${RDEPEND}"

#SRC_TEST=do
