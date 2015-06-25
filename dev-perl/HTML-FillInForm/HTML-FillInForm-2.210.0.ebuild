# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/HTML-FillInForm/HTML-FillInForm-2.210.0.ebuild,v 1.1 2015/06/24 23:08:32 dilfridge Exp $

EAPI=5

MODULE_AUTHOR=MARKSTOS
MODULE_VERSION=2.21
inherit perl-module

DESCRIPTION="Populates HTML Forms with data"

SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~x86 ~x86-fbsd"
IUSE="test"

RDEPEND="
	dev-perl/HTML-Parser
	virtual/perl-Carp
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? ( dev-perl/CGI )
"
# the dep specs are rather incomplete

SRC_TEST="do parallel"
