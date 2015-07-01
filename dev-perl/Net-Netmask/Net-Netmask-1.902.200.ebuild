# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Net-Netmask/Net-Netmask-1.902.200.ebuild,v 1.1 2015/07/01 18:47:01 zlogene Exp $

EAPI=5

MODULE_AUTHOR=MUIR
MODULE_SECTION=modules
MODULE_VERSION=1.9022
inherit perl-module

DESCRIPTION="Parse, manipulate and lookup IP network blocks"

SLOT="0"
KEYWORDS="~amd64 ~arm ~mips ~ppc ~x86"
IUSE=""

DEPEND="virtual/perl-ExtUtils-MakeMaker"

SRC_TEST="do"
