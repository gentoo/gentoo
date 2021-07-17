# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=JV
MODULE_VERSION=2.42
inherit perl-module

DESCRIPTION="Advanced handling of command line options"

SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="dev-perl/Pod-Parser"
DEPEND="${RDEPEND}"

SRC_TEST=do
