# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=FRODWITH
MODULE_VERSION=0.01
inherit perl-module

DESCRIPTION="Attributes with aliases for constructor arguments"

SLOT="0"
KEYWORDS="~amd64 ~x86 ~x64-macos"
IUSE="test"

RDEPEND="dev-perl/Moose"
DEPEND="test? ( ${DEPEND}
		dev-perl/Test-Pod )"

SRC_TEST="do"
