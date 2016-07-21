# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=BIGPRESH
MODULE_VERSION=0.11
inherit perl-module

DESCRIPTION="Convert POD to README file"

SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="dev-perl/regexp-common"
DEPEND="${RDEPEND}"

SRC_TEST="do"
