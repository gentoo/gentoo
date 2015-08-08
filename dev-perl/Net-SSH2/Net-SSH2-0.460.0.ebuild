# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=RKITOVER
MODULE_VERSION=0.46
inherit perl-module

DESCRIPTION="Net::SSH2 - Support for the SSH 2 protocol via libssh2"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="net-libs/libssh2
>=virtual/perl-ExtUtils-MakeMaker-6.50"
DEPEND="${RDEPEND}"

SRC_TEST="do"
