# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/perl-core/Net-Ping/Net-Ping-2.41-r1.ebuild,v 1.2 2015/06/08 20:21:14 dilfridge Exp $

EAPI=5

MODULE_AUTHOR=SMPETERS
MY_PN=Net-Ping
MY_P=${MY_PN}-${PV}
S=${WORKDIR}/${MY_P}
inherit perl-module

DESCRIPTION="check a remote host for reachability"

SLOT="0"
KEYWORDS=""
IUSE=""

# online tests
SRC_TEST=no
