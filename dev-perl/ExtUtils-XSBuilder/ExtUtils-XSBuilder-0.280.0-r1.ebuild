# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=GRICHTER
MODULE_VERSION=0.28
inherit perl-module

DESCRIPTION="Modules to parse C header files and create XS glue code"

SLOT="0"
KEYWORDS="alpha amd64 ia64 ppc ppc64 sparc x86"
IUSE=""

RDEPEND="dev-perl/Parse-RecDescent
	dev-perl/Tie-IxHash"
DEPEND="${RDEPEND}"

SRC_TEST="do"
