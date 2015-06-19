# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Import-Into/Import-Into-1.2.4.ebuild,v 1.1 2015/03/28 14:08:29 zlogene Exp $

EAPI=5

MODULE_AUTHOR=ETHER
MODULE_VERSION=1.002004
inherit perl-module

DESCRIPTION="Import packages into other packages"

SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~ppc-aix ~x86-solaris"
IUSE="test"

RDEPEND="
	dev-perl/Module-Runtime
"
DEPEND="
	${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-Exporter
		virtual/perl-Test-Simple
	)
"
SRC_TEST=do
