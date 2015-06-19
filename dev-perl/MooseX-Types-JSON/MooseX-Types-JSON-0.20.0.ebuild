# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/MooseX-Types-JSON/MooseX-Types-JSON-0.20.0.ebuild,v 1.2 2014/09/04 13:29:37 zlogene Exp $

EAPI=5

MODULE_AUTHOR=MILA
MODULE_VERSION=0.02
inherit perl-module

DESCRIPTION="JSON datatype for Moose"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=dev-perl/JSON-XS-2.00
	>=dev-perl/Moose-0.82
	>=dev-perl/MooseX-Types-0.15"
DEPEND="${RDEPEND}"

SRC_TEST="do"
