# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/HTML-Strip/HTML-Strip-2.90.0.ebuild,v 1.1 2015/06/27 14:51:37 dilfridge Exp $

EAPI=5

MODULE_AUTHOR=KILINRAX
MODULE_VERSION=2.09
inherit perl-module

DESCRIPTION="Extension for stripping HTML markup from text"

SLOT="0"
KEYWORDS="~amd64 ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="test"

RDEPEND="
	virtual/perl-Carp
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		dev-perl/Test-Exception
		virtual/perl-Test-Simple
	)
"

SRC_TEST="do parallel"
