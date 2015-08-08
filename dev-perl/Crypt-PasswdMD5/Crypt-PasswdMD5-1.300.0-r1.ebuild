# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=LUISMUNOZ
MODULE_VERSION=1.3
inherit perl-module

DESCRIPTION="Provides interoperable MD5-based crypt() functions"

LICENSE="${LICENSE} BEER-WARE"
SLOT="0"
KEYWORDS="amd64 ~arm ~mips ~ppc ~ppc64 ~sparc x86"
IUSE=""

SRC_TEST="do"
