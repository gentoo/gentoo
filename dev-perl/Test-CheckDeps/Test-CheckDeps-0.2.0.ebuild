# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=LEONT
MODULE_VERSION=0.002
inherit perl-module

DESCRIPTION='Check for presence of dependencies'

SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~x86"
IUSE=""

RDEPEND="
	virtual/perl-CPAN-Meta
	dev-perl/CPAN-Meta-Check
	virtual/perl-Module-Metadata
"
DEPEND="${RDEPEND}"

SRC_TEST="do"
