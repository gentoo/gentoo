# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR="NEELY"
MODULE_VERSION="0.10"

inherit perl-module

DESCRIPTION="Light weight module for validating domains"

SLOT="0"
KEYWORDS="amd64 ~hppa"
IUSE="test"

RDEPEND=">=dev-perl/Net-Domain-TLD-1.690.0"
DEPEND="${RDEPEND}
	test? ( virtual/perl-Test-Simple )
"

SRC_TEST=do
