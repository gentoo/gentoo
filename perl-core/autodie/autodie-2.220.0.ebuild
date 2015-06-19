# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/perl-core/autodie/autodie-2.220.0.ebuild,v 1.2 2015/06/13 10:03:16 dilfridge Exp $

EAPI=5

MODULE_AUTHOR=PJF
MODULE_VERSION=2.22
inherit perl-module

DESCRIPTION='Replace functions with ones that succeed or die with lexical scope'

SLOT="0"
KEYWORDS=""
IUSE=""

SRC_TEST="do"
