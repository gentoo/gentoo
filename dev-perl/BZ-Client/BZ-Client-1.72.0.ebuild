# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=JWIED
MODULE_VERSION=1.04
inherit perl-module

DESCRIPTION="A client for the Bugzilla web services API."

LICENSE="|| ( Artistic GPL-1 GPL-2 GPL-3 )"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	dev-perl/URI
	dev-perl/XML-Writer
	dev-perl/XML-Parser
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"
