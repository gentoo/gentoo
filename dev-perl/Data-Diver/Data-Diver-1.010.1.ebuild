# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=TYEMQ
MODULE_VERSION=1.0101
MODULE_A_EXT=tgz

inherit perl-module

DESCRIPTION="Simple, ad-hoc access to elements of deeply nested structures"

SLOT="0"
KEYWORDS="amd64 ~mips x86"

SRC_TEST="do parallel"
