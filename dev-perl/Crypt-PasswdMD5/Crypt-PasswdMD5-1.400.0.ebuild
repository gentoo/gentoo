# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=RSAVAGE
MODULE_VERSION=1.40
MODULE_A_EXT=tgz
inherit perl-module

DESCRIPTION="Provides interoperable MD5-based crypt() functions"
SLOT="0"
KEYWORDS="amd64 ~arm ~mips ~ppc ~ppc64 ~sparc x86"

DEPEND="dev-perl/Module-Build"

SRC_TEST="do"
