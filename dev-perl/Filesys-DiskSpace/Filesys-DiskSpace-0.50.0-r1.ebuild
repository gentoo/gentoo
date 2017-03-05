# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=FTASSIN
MODULE_VERSION=0.05
inherit perl-module

DESCRIPTION="Perl df"

SLOT="0"
KEYWORDS="amd64 ~ppc sparc x86"
IUSE=""

#Disabled - assumes you have ext2 mounts actively mounted!?!
#SRC_TEST="do"
