# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=ALEXMV
MODULE_VERSION=0.04
inherit perl-module

DESCRIPTION="Simple XML file reading based on their DTDs"

SLOT="0"
KEYWORDS="~amd64 x86"
IUSE=""

DEPEND=">=dev-perl/XML-Parser-2.34"
RDEPEND="${DEPEND}"

SRC_TEST=do
