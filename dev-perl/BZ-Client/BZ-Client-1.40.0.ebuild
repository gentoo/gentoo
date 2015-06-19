# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/BZ-Client/BZ-Client-1.40.0.ebuild,v 1.1 2014/10/21 23:16:06 dilfridge Exp $

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
