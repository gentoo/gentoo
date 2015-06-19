# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/XML-Smart/XML-Smart-1.790.0.ebuild,v 1.1 2014/12/07 16:17:13 dilfridge Exp $

EAPI=5
MODULE_AUTHOR=TMHARISH
MODULE_VERSION=1.79
inherit perl-module

DESCRIPTION='A smart, easy and powerful way to access or create XML from fiels, data and URLs.'
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="
	>=dev-perl/Object-MultiType-0.30.0
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? ( virtual/perl-Test-Simple )
"

SRC_TEST="do"
