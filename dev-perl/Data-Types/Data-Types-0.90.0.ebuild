# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR="DWHEELER"
MODULE_VERSION="0.09"

inherit perl-module

DESCRIPTION="Validate and convert data types."
SLOT="0"
KEYWORDS="amd64"
IUSE="test"
SRC_TEST=do
DEPEND="dev-perl/Module-Build
	test? ( virtual/perl-Test-Simple )"
