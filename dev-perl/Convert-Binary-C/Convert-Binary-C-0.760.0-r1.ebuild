# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Convert-Binary-C/Convert-Binary-C-0.760.0-r1.ebuild,v 1.1 2014/08/22 17:40:52 axs Exp $

EAPI=5

MODULE_AUTHOR=MHX
MODULE_VERSION=0.76
inherit perl-module

DESCRIPTION="Binary Data Conversion using C Types"

SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

MAKEOPTS+=" -j1"
SRC_TEST="do"
