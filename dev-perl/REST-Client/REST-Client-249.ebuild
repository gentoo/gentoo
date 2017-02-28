# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

MODULE_AUTHOR="MCRAWFOR"

inherit perl-module

DESCRIPTION="A simple client for interacting with RESTful http/https resources"

LICENSE="|| ( Artistic GPL-1 GPL-2 GPL-3 )"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="dev-perl/URI
	dev-perl/Crypt-SSLeay"
