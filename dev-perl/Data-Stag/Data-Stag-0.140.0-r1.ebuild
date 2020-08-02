# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=CMUNGALL
MODULE_VERSION=0.14
inherit perl-module

DESCRIPTION="Structured Tags datastructures"
HOMEPAGE="http://stag.sourceforge.net/ https://metacpan.org/release/Data-Stag"

SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="dev-perl/IO-String"
DEPEND="${RDEPEND}"

SRC_TEST="do"
