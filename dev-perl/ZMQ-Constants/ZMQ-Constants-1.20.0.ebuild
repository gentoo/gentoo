# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/ZMQ-Constants/ZMQ-Constants-1.20.0.ebuild,v 1.4 2014/02/16 12:38:57 zlogene Exp $

EAPI=5

MODULE_AUTHOR=DMAKI
MODULE_VERSION=1.02
inherit perl-module

DESCRIPTION="Constants for libzmq"

SLOT="0"
KEYWORDS="amd64 hppa ppc ppc64 x86"
IUSE=""

RDEPEND="
	net-libs/zeromq
"
DEPEND="${RDEPEND}"

SRC_TEST=do
