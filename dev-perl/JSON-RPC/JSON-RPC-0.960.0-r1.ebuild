# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=MAKAMAKA
MODULE_VERSION=0.96
inherit perl-module

DESCRIPTION="Perl implementation of JSON-RPC 1.1 protocol"

SLOT="0"
KEYWORDS="alpha amd64 ia64 ppc ppc64 sparc x86"
IUSE=""

RDEPEND="dev-perl/libwww-perl
	>=dev-perl/JSON-2.21"
DEPEND="${RDEPEND}"

SRC_TEST="do"
