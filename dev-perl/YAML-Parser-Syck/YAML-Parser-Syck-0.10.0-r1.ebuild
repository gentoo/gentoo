# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=INGY
MODULE_VERSION=0.01
inherit perl-module

DESCRIPTION="Perl Wrapper for the YAML Parser Extension: libsyck"

SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="dev-libs/syck"
DEPEND="${RDEPEND}"

SRC_TEST="do"
