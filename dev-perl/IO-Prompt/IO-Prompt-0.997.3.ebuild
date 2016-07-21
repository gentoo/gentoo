# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=DCONWAY
MODULE_VERSION=0.997003
inherit perl-module

DESCRIPTION="Interactively prompt for user input"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="
	dev-perl/TermReadKey
	dev-perl/Want
	virtual/perl-version
"
DEPEND="${RDEPEND}
	dev-perl/Module-Build
	test? ( virtual/perl-Test-Simple )
"

SRC_TEST="do parallel"
