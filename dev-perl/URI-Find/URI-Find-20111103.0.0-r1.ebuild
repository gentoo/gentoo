# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=MSCHWERN
MODULE_VERSION=20111103
inherit perl-module

DESCRIPTION="Find URIs in plain text"

SLOT="0"
KEYWORDS="~amd64 ~x86 ~x86-solaris"
IUSE="test"

RDEPEND="dev-perl/URI"
DEPEND=">=dev-perl/Module-Build-0.30
	test? ( >=virtual/perl-Test-Simple-0.82
		dev-perl/Test-Pod
		${RDEPEND} )"

SRC_TEST=do
