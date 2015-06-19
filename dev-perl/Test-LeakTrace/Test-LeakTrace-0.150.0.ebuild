# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Test-LeakTrace/Test-LeakTrace-0.150.0.ebuild,v 1.7 2015/06/04 13:18:03 zlogene Exp $

EAPI=5

MODULE_AUTHOR=GFUJI
MODULE_VERSION=0.15
inherit perl-module

DESCRIPTION='Traces memory leaks'

SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 sparc x86"
IUSE=""

SRC_TEST="do"
