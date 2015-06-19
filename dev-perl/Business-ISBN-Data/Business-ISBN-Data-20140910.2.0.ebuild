# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Business-ISBN-Data/Business-ISBN-Data-20140910.2.0.ebuild,v 1.1 2015/04/18 18:55:11 dilfridge Exp $

EAPI=5

MODULE_AUTHOR=BDFOY
MODULE_VERSION=20140910.002
inherit perl-module

DESCRIPTION="Data pack for Business::ISBN"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="
	virtual/perl-Carp
	virtual/perl-File-Spec
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		>=virtual/perl-Test-Simple-0.950.0
		dev-perl/Test-Pod
		dev-perl/Test-Pod-Coverage
	)
"

SRC_TEST=do
