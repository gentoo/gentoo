# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

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
