# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=THEPLER
MODULE_VERSION=0.06
inherit perl-module

DESCRIPTION="A Path::Class type library for Moose"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=dev-perl/Moose-1.990
	>=dev-perl/Moose-0.390.0
	>=dev-perl/MooseX-Types-0.40.0
	>=dev-perl/Path-Class-0.160.0"

DEPEND="${RDEPEND}"

SRC_TEST="do"
