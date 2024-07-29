# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=ALEXMV
DIST_VERSION=0.04
inherit perl-module

DESCRIPTION="Simple XML file reading based on their DTDs"

SLOT="0"
KEYWORDS="~amd64 x86"

RDEPEND="
	>=dev-perl/XML-Parser-2.340.0
"
BDEPEND="${RDEPEND}
"
